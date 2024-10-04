import 'package:beats_music/providers/sleep_timer_provider.dart';
import 'package:beats_music/screens/home.dart';
import 'package:beats_music/screens/permission_screen.dart';
import 'package:beats_music/screens/splash_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:beats_music/database/favorite_model.dart';
import 'package:beats_music/screens/drawer.dart'; // Assuming your drawer file is named main_drawer.dart
import 'package:beats_music/screens/favorite_screen.dart';
import 'package:beats_music/controllers/player_controller.dart'; // Import your PlayerController

void main() {
  // Initialize the PlayerController
  Get.put(PlayerController());

  runApp(
    MultiProvider(
      providers: [
        //  ChangeNotifierProvider(create: (_) => SleepTimerProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteModel()),
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Track permission request progress
  bool isPermissionRequestInProgress = false;

  // Check if storage permission is granted
  Future<bool> _hasStoragePermission() async {
    if (isPermissionRequestInProgress) {
      // If a request is already in progress, wait
      print('Permission request is already in progress. Waiting...');
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay before re-check
      return _hasStoragePermission(); // Retry after delay
    }

    isPermissionRequestInProgress = true; // Set the flag to indicate a request is running
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    // Check the storage permission based on Android SDK version
    PermissionStatus storageStatus;
    if (android.version.sdkInt! < 33) {
      storageStatus = await Permission.storage.status;
    } else {
      storageStatus = await Permission.manageExternalStorage.status;
    }

    isPermissionRequestInProgress = false; // Reset the flag
    return storageStatus.isGranted; // Return true if permission is granted, otherwise false
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasStoragePermission(), // Check permission status on startup
      builder: (context, snapshot) {
        // Show a loading spinner while the future is resolving
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()), // Loading indicator
            ),
          );
        }

        // Check if there was an error
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        }

        // Determine which screen to show based on permission status
        if (snapshot.data == true) {
          // If permission is granted, show the splash screen
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            title: 'Beats',
            theme: ThemeData(
              fontFamily: "regular",
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          );
        } else {
          // If permission is not granted, show the storage permission screen
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home:   PermissionScreen(
              reload: () {
                // Define your reload function or leave it empty if not needed
              },
              permissionGranted: false, // Set this based on your logic
            ),
            title: 'Beats',
            theme: ThemeData(
              fontFamily: "regular",
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          );
        }
      },
    );
  }
}

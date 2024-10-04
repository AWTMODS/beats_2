import 'dart:async';
import 'package:beats_music/screens/home.dart'; // Replace with your home screen import
import 'package:beats_music/screens/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(); // Start navigating to the next screen on initialization
  }

  void _navigateToNextScreen() async {
    // Simulate a long-running task with a delay
    await Future.delayed(Duration(seconds: 5)); // Adjust as necessary

    // Check permissions and navigate to the appropriate screen
    bool permissionGranted = await _checkPermissions();
    if (permissionGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your home screen route
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<bool> _checkPermissions() async {
    if (await Permission.storage.isGranted || await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    if (await Permission.storage.isDenied || await Permission.manageExternalStorage.isDenied) {
      var status = await Permission.storage.request();
      return status.isGranted;
    }

    if (await Permission.storage.isPermanentlyDenied || await Permission.manageExternalStorage.isPermanentlyDenied) {
      return false;
    }

    // For Android 13 and above
    if (await Permission.manageExternalStorage.isDenied) {
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash_animation.json', // Replace with your animation path
              width: 300, // Adjust as necessary
              height: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            // CircularProgressIndicator(), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}

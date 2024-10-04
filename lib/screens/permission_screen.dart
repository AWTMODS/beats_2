import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:beats_music/screens/home.dart'; // Update import paths based on your project structure

class PermissionScreen extends StatelessWidget {
  final void Function() reload;
  final bool permissionGranted;

  const PermissionScreen({
    Key? key,
    required this.reload,
    required this.permissionGranted,
  }) : super(key: key);

  Future<void> _requestPermission(BuildContext context) async {
    bool granted = await _checkPermissions();
    if (granted) {
      // Navigate to the HomeScreen when permission is granted
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showPermissionDeniedMessage(context);
    }
  }

  Future<bool> _checkPermissions() async {
    // Check for granted permissions first
    if (await Permission.storage.isGranted || await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // Request permissions if denied
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    }

    // Check if permission is permanently denied
    if (await Permission.storage.isPermanentlyDenied || await Permission.manageExternalStorage.isPermanentlyDenied) {
      return false;
    }

    // Handle Android 13 and above specific permission checks
    if (await Permission.manageExternalStorage.isDenied) {
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }

    return false;
  }

  void _showPermissionDeniedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Storage permission denied. Please allow access from settings.'),
        action: SnackBarAction(
          label: 'Open Settings',
          onPressed: () {
            openAppSettings();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder_open,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Storage Permission Required',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'We need access to your storage to provide better services. Please grant the permission.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _requestPermission(context),
                child: const Text('Allow Storage Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

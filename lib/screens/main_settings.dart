import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:beats_music/providers/sleep_timer_provider.dart';

class MainSettings extends StatelessWidget {
  const MainSettings({Key? key}) : super(key: key);

  Future<void> _resetApp() async {
    print('Resetting the app...');
  }

  Future<void> _clearCache() async {
    print('Clearing cache...');
  }

  Future<void> _getAndroidVersion() async {
    print('Getting Android version...');
  }

  Future<void> _showSleepTimerDialog(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      Duration duration = Duration(
        hours: selectedTime.hour - TimeOfDay.now().hour,
        minutes: selectedTime.minute - TimeOfDay.now().minute,
      );

      Provider.of<SleepTimerProvider>(context, listen: false).setTimer(duration, () {
        // Callback when timer ends
        // This can be used to show a toast in the HomeScreen
      });

      Get.snackbar(
        'Sleep Timer Set',
        'The sleep timer has been set for ${selectedTime.format(context)}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSettingTile(Icons.palette, 'Theme Change', () {}, Colors.orange),
              _buildSettingTile(Icons.info, 'Android Version', _getAndroidVersion, Colors.blue),
              _buildSettingTile(Icons.security, 'Privacy Policy', () {}, Colors.green),

              _buildSettingTile(Icons.timer, 'Sleep Timer', () => _showSleepTimerDialog(context), Colors.purple),
              _buildSettingTile(Icons.restore, 'Reset App', _resetApp, Colors.red),
              FutureBuilder<String>(
                future: _getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buildAppVersionTile(snapshot.data ?? 'Loading...');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, Function() onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white.withOpacity(0.1),
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersionTile(String version) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(version, style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }


  Future<String> _getAppVersion() async {
    await Future.delayed(Duration(seconds: 2));
    return 'App Version: 1.0.0';
  }
}

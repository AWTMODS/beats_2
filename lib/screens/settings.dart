import 'package:flutter/material.dart';
import 'package:beats_music/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Theme Settings" ,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold),),
        ),
        body: Consumer<ThemeProvider>(
            builder: (context, ThemeProvider notifier, child) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text("Dark Mode" ,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),),
                    trailing: Switch(
                      value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                      onChanged: (value)=>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                    ),
                  )
                ],
              );
            }
        )
    );
  }
}

import 'package:beats_music/colors/colors.dart';
import 'package:beats_music/screens/about.dart';
import 'package:beats_music/screens/home.dart';
import 'package:beats_music/screens/toasts.dart';
import 'package:flutter/material.dart';
import 'package:beats_music/screens/main_settings.dart';
import 'package:beats_music/screens/privacy.dart';
import 'package:beats_music/screens/settings.dart';
//import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:beats_music/database/favorite_model.dart';
import 'package:beats_music/screens/favorite_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black, // Background color for the entire drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87, // Background color for the header
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,

                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Aadith',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green),
              title: const Text('Home', style: TextStyle(color: Colors.green)),
              onTap: () {
                // Handle the tap event
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap event
                showDefault();
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border, color: Colors.white),
              title: const Text('Favorite', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to favorite page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap event
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainSettings()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.white),
              title: const Text('Privacy & Policy', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap event
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Share', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap event
                showDefault();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle the tap event
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Developed with ❤️ by Aadith',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

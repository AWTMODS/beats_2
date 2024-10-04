import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.green),),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined,color:Colors.white,),
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Last Updated: [31/03/2024]',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.info_outline,color:Colors.white,),
              title: Text(
                'Introduction',
                style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'This Privacy Policy explains how we collect, use, and disclose personal information provided by users of our music app.',
                style: TextStyle(color:Colors.white,fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person_outline,color:Colors.white,),
              title: Text(
                'Information We Collect',
                style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '- Personal information: We may collect personal information such as name, email address, and phone number when you register or use our app.',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  Text(
                    '- Usage information: We may collect information about how you use the app, including songs played, playlists created, and interactions with the app.',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  // Add more points as needed
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.settings,color:Colors.white,),
              title: Text(
                'How We Use Your Information',
                style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We may use the information we collect for various purposes, including:',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  Text(
                    '- Providing and improving our services',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  Text(
                    '- Personalizing your experience',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  // Add more points as needed
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.lock_outline,color:Colors.white,),
              title: Text(
                'Disclosure of Your Information',
                style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We may disclose your information to third parties in the following circumstances:',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  Text(
                    '- With your consent',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  Text(
                    '- To comply with legal obligations',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  // Add more points as needed
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.assignment,color:Colors.white,),
              title: Text(
                'Your Choices',
                style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You have the following choices regarding your information:',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  Text(
                    '- You can update or delete your personal information',
                    style: TextStyle(color:Colors.white,fontSize: 16),
                  ),
                  // Add more points as needed
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.mail_outline,color:Colors.white,),
              title: Text(
                'Contact Us',
                style: TextStyle(color: Colors.green,fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'If you have any questions or concerns about our Privacy Policy, please contact us at [support@muzicapp.com].',
                style: TextStyle(color:Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

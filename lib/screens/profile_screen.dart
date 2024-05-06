import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Function updateLoginStatus;

  ProfileScreen({required this.updateLoginStatus});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with your user's profile picture
            ),
            SizedBox(height: 10),
            Text(
              'User Name: John Doe',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: john.doe@example.com',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                widget.updateLoginStatus(false);
              },
              child: Text('Log Out'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement your change password functionality here
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

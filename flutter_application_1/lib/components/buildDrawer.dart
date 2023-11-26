import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Auth-Provider.dart';
import 'package:flutter_application_1/data%20classes/UserInfo.dart'; 
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

Drawer buildDrawer(BuildContext context) {
  final authProvider = Provider.of<Auth_Provider>(context);
  User? user = authProvider.user;
  UsersInfo? _usersInfo = authProvider.usersInfo;
  String email = user?.email ?? 'No email available'; // Handling null email
  String name = '${_usersInfo?.name} ${_usersInfo?.surname}';
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 200, // Fixed height for DrawerHeader
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/a.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text('Homepage'),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.pushNamed(context, '/'); // Navigate to the home screen
          },
        ),
        ListTile(
          title: const Text('Game Page'),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.pushNamed(context, '/game'); // Navigate to the game screen
          },
        ),
      ],
    ),
  );
}

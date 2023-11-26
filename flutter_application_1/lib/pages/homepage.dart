//homepage.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buildDrawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Railways Cafe'),
      ),
      drawer: buildDrawer(context),
      body: const Center(
        child: Text(
          'Welcome to Railways Cafe!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
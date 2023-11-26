import 'package:flutter/material.dart';
import 'package:flutter_application_1/data%20classes/UserInfo.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/components/Auth-Provider.dart';
import 'package:flutter_application_1/pages/homepage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Auth_Provider auth_Provider = Provider.of<Auth_Provider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                await auth_Provider.registerWithEmailAndPassword(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                  UsersInfo(
                    name: _nameController.text.trim(),
                    surname: _surnameController.text.trim(),
                    phoneNumber: _phoneController.text.trim(),
                    emailAddress: _emailController.text.trim(),
                  ),
                );

                if (auth_Provider.user != null) {                  
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registration failed. Please try again.'),
                    ),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
             SizedBox(height: 12.0), // Adjust spacing as needed
            TextButton(
              onPressed: () {
                // Navigate to the SignUpPage when "Sign Up" is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Have an account? Sign in"),
            ),
          ],
        ),
      ),
    );
  }
}

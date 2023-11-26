import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        // Define your app's theme
        primarySwatch: Colors.blue,
        // Other theme configurations
      ),
      home: CreateUserExample(),
    );
  }
}
class UserDataToDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  
  // Function to create a random user
  Future<void> createRandomUser() async {
    try {
      // Generate random details for the user
      String randomName = generateRandomString(8);
      String randomSurname = generateRandomString(10);
      String randomPhoneNumber = generateRandomPhoneNumber();
      String randomEmail = '$randomName.$randomSurname@example.com';
      String randomPassword = 'randomPassword'; // Provide a random password
      String randomIcon = getRandomIconUrl();
      
      print('user email:${randomEmail} user password ${randomPassword}');
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: randomEmail,
        password: randomPassword,
      );

      if (userCredential.user != null) {
        String? iconDownloadUrl = await uploadIconToStorage(randomIcon,userCredential);
        UserInfo userInfo = UserInfo(
          name: randomName,
          surname: randomSurname,
          phoneNumber: randomPhoneNumber,
          emailAddress: randomEmail,
          iconUrl: iconDownloadUrl,
        );

        // Save user information to Firebase Realtime Database
        await databaseReference.child('users/${userCredential.user!.uid}').set(userInfo.toJson());
        print('Random user created and information saved to database for ${userCredential.user!.uid}');
      }
    } catch (e) {
      print('Error creating random user: $e');
    }
  }
   String getRandomIconUrl() {
    List<String> icons = [
      'icons/h.jpg',
      'icons/a.jpg',  
      'icons/b.jpg',     
    ];

    Random random = Random();
    int index = random.nextInt(icons.length);
    return icons[index];
  }
   Future<String?> uploadIconToStorage(String iconPath, UserCredential userCredential) async {
    // Replace 'your_storage_path' with your desired path in Firebase Storage
    String storagePath = 'users/${userCredential.user!.uid}/$iconPath';

    try {
      await FirebaseStorage.instance.ref().child(storagePath).putData(
            // Replace getImageBytes() with your actual method to get icon bytes
            await getImageBytes(iconPath),
          );

      // Get the download URL of the uploaded image
      String downloadURL =
          await FirebaseStorage.instance.ref(storagePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading icon to Firebase Storage: $e');
      return null;
    }
  }

  Future<Uint8List> getImageBytes(String iconPath) async {
    
    ByteData data = await rootBundle.load(iconPath);
    return data.buffer.asUint8List();
  }

  // Function to generate a random string of given length
  String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Function to generate a random phone number
  String generateRandomPhoneNumber() {
    Random random = Random();
    String number = '+';
    for (int i = 0; i < 10; i++) {
      number += random.nextInt(10).toString();
    }
    return number;
  }
}

class UserInfo {
  final String? name;
  final String? surname;
  final String? phoneNumber;
  final String? emailAddress;
  final String? iconUrl;

  UserInfo({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.emailAddress,
    required this.iconUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
       'iconUrl': iconUrl,
    };
  }
}

class CreateUserExample extends StatelessWidget {
  final UserDataToDatabase userDataToDatabase = UserDataToDatabase();

  CreateUserExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Random User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            userDataToDatabase.createRandomUser();
          },
          child: Text('Create Random User'),
        ),
      ),
    );
  }
}

//main.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/observer/AuthRouteObserver.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:flutter_application_1/pages/gamespage.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/signup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/components/Auth-Provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
 // Create the AuthProvider
  Auth_Provider authProvider = Auth_Provider();

  // Create the AuthRouteObserver
  AuthRouteObserver authRouteObserver = AuthRouteObserver(authProvider);
  runApp(MyApp(authProvider: authProvider,
    authRouteObserver: authRouteObserver,));
}

 class MyApp extends StatelessWidget {
  final Auth_Provider authProvider;
  final AuthRouteObserver authRouteObserver;

  const MyApp({
    Key? key,
    required this.authProvider,
    required this.authRouteObserver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider.value(
      value: authProvider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Removes the debug banner
        title: 'Railways Cafe',
        initialRoute: '/login',
        routes: {
          '/': (context) => HomeScreen(), 
          '/game': (context) => GameScreen(),
          '/login': (context) => LoginPage(), 
          '/signup': (context) => SignUpPage(), 
        },
      ),
   );
  }
}

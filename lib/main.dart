import 'package:lab3_193059/screens/google_map_screen.dart';
import 'package:lab3_193059/screens/home_screen.dart';
import 'package:lab3_193059/screens/signin_screen.dart';
import 'package:lab3_193059/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Application name
        title: 'Laboratoriska 4 - 193059',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          SignInScreen.id: (context) => SignInScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          //GoogleMapPage.id: (context) => GoogleMapPage(),
        });
  }
}

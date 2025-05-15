import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/home_page.dart';

void main() {
  runApp(HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IntroScreen(),
        '/home': (context) => HomePage(userName: '',),
        '/auth': (context) => AuthScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

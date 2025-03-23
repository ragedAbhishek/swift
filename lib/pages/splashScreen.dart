import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift/deltaFiles/appControl.dart';
import 'package:swift/pages/adminSection/adminPages/adminHomePage.dart';
import 'package:swift/pages/loginOptionPage.dart';
import 'package:swift/pages/ordinateSection.dart/pages/ordinateHomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkAndNavigate();
    super.initState();
  }

  void checkAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedUserID = prefs.getString('loggedUserID');
    String? loggedUserType = prefs.getString('loggedUserType');

    if (loggedUserID == null || loggedUserID.isEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginOptionPage()),
          );
        }
      });
    } else {
      if (loggedUserType == "ordinate") {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrdinateHomePage()),
            );
          }
        });
      } else if (loggedUserType == "admin") {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
          }
        });
      } else {
        // Handle other user types here if needed.
      }

      // Common for all user types
      if (mounted) {
        setState(() {
          AppControl.loggedUserID = loggedUserID;
          AppControl.loggedUserType = loggedUserType ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          "assets/images/bus.png",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

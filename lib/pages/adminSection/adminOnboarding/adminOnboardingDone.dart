import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift/deltaFiles/appControl.dart';
import 'package:swift/pages/adminSection/adminPages/adminNav.dart';

class AdminOnboardingDone extends StatefulWidget {
  final String phoneNo;
  final String orgType;
  const AdminOnboardingDone({
    super.key,
    required this.phoneNo,
    required this.orgType,
  });

  @override
  State<AdminOnboardingDone> createState() => _AdminOnboardingDoneState();
}

class _AdminOnboardingDoneState extends State<AdminOnboardingDone> {
  @override
  void initState() {
    super.initState();
    setPreference("CLIENT_${widget.phoneNo}", widget.orgType);
    getPreference();
  }

  Future<void> setPreference(String userID, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedUserID', userID);
    await prefs.setString('loggedUserType', userType);
  }

  Future<void> getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedUserID = prefs.getString('loggedUserID');
    String? loggedUserType = prefs.getString('loggedUserType');

    if (loggedUserID != null && mounted) {
      setState(() {
        AppControl.loggedUserID = loggedUserID;
        AppControl.loggedUserType = loggedUserType ?? ''; // Handle null case
      });
      _navigationtoHome();
    }
  }

  _navigationtoHome() async {
    await Future.delayed(const Duration(seconds: 8), () {});
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => AdminNav()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          "assets/animations/welcome_black.json",
          repeat: false,
          height: 42.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

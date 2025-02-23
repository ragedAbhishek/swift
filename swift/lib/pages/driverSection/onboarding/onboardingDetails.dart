import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingDetails extends StatefulWidget {
  const OnboardingDetails({super.key});

  @override
  State<OnboardingDetails> createState() => _OnboardingDetailsState();
}

class _OnboardingDetailsState extends State<OnboardingDetails> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Work under process"),
      ),
    );
  }
}

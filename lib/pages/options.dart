import 'package:flutter/material.dart';
import 'package:swift/pages/loginPage.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: Text("Continue as driver")),
          ElevatedButton(onPressed: () {}, child: Text("Continue as Admin")),
          ElevatedButton(onPressed: () {}, child: Text("Continue as Moderator"))
        ],
      ),
    );
  }
}

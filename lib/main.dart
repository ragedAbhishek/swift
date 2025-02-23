import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swift/pages/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // fontFamily: GoogleFonts.sofiaSans.toString(),
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/SplashScreen",
      routes: {
        // ***************** D O N ' T   R E M O V E   T H E S E  *******************
        "/SplashScreen": (context) => SplashScreen(),

        // ***************** R E M O V E   T H E S E  *******************
      },
    );
  }
}

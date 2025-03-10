import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swift/firebase_options.dart';
import 'package:swift/pages/driverSection/authtication/phoneAuth.dart';
import 'package:swift/pages/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => MaterialApp(
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: "/splashScreen",
            routes: {
              // ***************** D O N ' T   R E M O V E   T H E S E  *******************
              "/splashScreen": (context) => const SplashScreen(),

              // ***************** R E M O V E   T H E S E  *******************
              "/phoneAuth": (context) => const PhoneAuth(),
            },
          ),
      designSize: const Size(392.72727272727275, 825.4545454545455),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/driverSection/authtication/phoneAuth.dart';

class LoginOptionPage extends StatefulWidget {
  const LoginOptionPage({super.key});

  @override
  State<LoginOptionPage> createState() => _LoginOptionPageState();
}

class _LoginOptionPageState extends State<LoginOptionPage> {
  void showToastMessage(String message) => Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 16.0,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 2,
      gravity: ToastGravity.BOTTOM);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            height: 660.h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/sampleImage.jpg"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r)),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageTransition(
                      type: PageTransitionType.rightToLeftJoined,
                      childCurrent: widget,
                      duration: const Duration(milliseconds: 120),
                      reverseDuration: const Duration(milliseconds: 120),
                      child: const PhoneAuth()),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: Text(
                      "Continue as driver",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: "Montserrat-SemiBold"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          GestureDetector(
            onTap: () {
              showToastMessage("Under Process");
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(16.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: Text(
                      "Continue as moderator",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18.sp,
                          fontFamily: "Montserrat-SemiBold"),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

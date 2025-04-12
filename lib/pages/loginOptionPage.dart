import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/adminSection/adminAuth/adminPhoneAuth.dart';
import 'package:swift/pages/driverSection/driverAuth/phoneAuth.dart';
import 'package:swift/pages/moderatorSection/moderatorAuth/moderatorAuth.dart';
import 'package:swift/pages/clientSelection.dart';

class LoginOptionPage extends StatefulWidget {
  const LoginOptionPage({super.key});

  @override
  State<LoginOptionPage> createState() => _LoginOptionPageState();
}

class _LoginOptionPageState extends State<LoginOptionPage> {
  void showOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeftJoined,
                      childCurrent: widget,
                      duration: const Duration(milliseconds: 120),
                      reverseDuration: const Duration(milliseconds: 120),
                      child: const AdminPhoneAuth(),
                    ),
                  );
                },
                child: Text("Admin"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeftJoined,
                      childCurrent: widget,
                      duration: const Duration(milliseconds: 120),
                      reverseDuration: const Duration(milliseconds: 120),
                      child: ClientSelection(userType: "moderator"),
                    ),
                  );
                },
                child: Text("Moderator"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeftJoined,
                      childCurrent: widget,
                      duration: const Duration(milliseconds: 120),
                      reverseDuration: const Duration(milliseconds: 120),
                      child: const DriverPhoneAuth(),
                    ),
                  );
                },
                child: Text("Driver"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            height: 660.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF266FEF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
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
                    child: const ClientSelection(userType: "ordinate"),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF266FEF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: Text(
                      "Continue as user",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: "Montserrat-SemiBold",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              showOptions();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: Text(
                      "Continue as moderator",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.sp,
                        fontFamily: "Montserrat-SemiBold",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

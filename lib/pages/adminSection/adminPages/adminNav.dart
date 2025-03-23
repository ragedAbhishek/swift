import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:swift/pages/adminSection/adminPages/adminDriversPage.dart';
import 'package:swift/pages/adminSection/adminPages/adminHomePage.dart';
import 'package:swift/pages/adminSection/adminPages/adminOrdinatesPage.dart';
import 'package:swift/pages/adminSection/adminPages/adminVehiclesPage.dart';

class AdminNav extends StatefulWidget {
  const AdminNav({super.key});

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  late StreamSubscription internetSubscription;

  var hasInternet = true;
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    internetSubscription = InternetConnectionChecker.createInstance()
        .onStatusChange
        .listen((status) {
          final hasInternet = status == InternetConnectionStatus.connected;
          setState(() {
            this.hasInternet = hasInternet;
          });
        });
  }

  List<Widget> body = [
    const AdminHomePage(),
    const AdminVehiclesPage(),
    const AdminDriversPage(),
    const AdminOrdinatesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white, // Set the color here
      ),
    );
    return hasInternet
        ? Scaffold(
          body: IndexedStack(index: selectIndex, children: body),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: ScreenUtil().setSp(28),
            enableFeedback: false,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 32,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              fontFamily: "Montserrat-SemiBold",
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              fontFamily: "Montserrat-SemiBold",
            ),
            unselectedItemColor: Colors.black54,
            type: BottomNavigationBarType.fixed,
            onTap: changeTab,
            currentIndex: selectIndex,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  selectIndex == 0
                      ? "assets/images/homeIconFilled.png"
                      : "assets/images/homeIconOutlined.png",
                  width: 26.w,
                  height: 26.h,
                  color: selectIndex == 0 ? Colors.black : Colors.black54,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  selectIndex == 1
                      ? "assets/images/tireFilled.png"
                      : "assets/images/tireOutlined.png",
                  width: 26.w,
                  height: 26.h,
                  color: selectIndex == 1 ? Colors.black : Colors.black54,
                ),
                label: "Vehicles",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  selectIndex == 2
                      ? "assets/images/steeringFilled.png"
                      : "assets/images/steeringOutlined.png",
                  width: 26.w,
                  height: 26.h,
                  color: selectIndex == 2 ? Colors.black : Colors.black54,
                ),
                label: "Drivers",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  selectIndex == 3
                      ? "assets/images/userFilled.png"
                      : "assets/images/userOutlined.png",
                  width: 26.w,
                  height: 26.h,
                  color: selectIndex == 2 ? Colors.black : Colors.black54,
                ),
                label: "Ordinates",
              ),
            ],
          ),
        )
        : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            // title: Image.asset(
            //   "assets/logos/LOGOFullPNG.png",
            //   color: Colors.black,
            //   height: 52.h,
            //   width: 148.w,
            //   fit: BoxFit.cover,
            // ),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/offline.jpg",
                  height: 240.h,
                  width: 392.72.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Something went wrong",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Please check your internet connection and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }

  void changeTab(int index) {
    setState(() {
      selectIndex = index;
    });
  }
}

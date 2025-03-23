import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdinateHomePage extends StatefulWidget {
  const OrdinateHomePage({super.key});

  @override
  State<OrdinateHomePage> createState() => _OrdinateHomePageState();
}

class _OrdinateHomePageState extends State<OrdinateHomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // Set the color here
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 48.h),
              Text(
                "Abhi",
                //"Hey, ${capitalizeFirstLetterOfEachWord(name.toString().split(" ")[0])}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                height: 140.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFDFF6F2),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 6.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/wallet.png",
                        fit: BoxFit.cover,
                        height: 32.h,
                        width: 92,
                        color: Color.fromARGB(255, 32, 74, 33),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Available Balance",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      RichText(
                        text: TextSpan(
                          text: "₹",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                          ),
                          children: [
                            TextSpan(
                              text: "100.00",
                              //'${walletBalance.floor()}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: "100.00",
                              // '.${walletBalance.remainder(1).toStringAsFixed(2).substring(2)}',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              ListTile(
                onTap: () {
                  // Navigator.of(context).push(
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeftJoined,
                  //     childCurrent: widget,
                  //     duration: const Duration(milliseconds: 120),
                  //     reverseDuration:
                  //         const Duration(milliseconds: 120),
                  //     child: OrderPage(
                  //       orders: orders,
                  //     ),
                  //   ),
                  // );
                },
                leading: Image.asset(
                  "assets/images/ordersIcons.png",
                  height: 22.h,
                  width: 22.w,
                  color: Colors.black54,
                ),
                title: Text(
                  "Orders",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(16),
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).push(
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeftJoined,
                  //     childCurrent: widget,
                  //     duration: const Duration(milliseconds: 120),
                  //     reverseDuration:
                  //         const Duration(milliseconds: 120),
                  //     child: const FeedBack(),
                  //   ),
                  // );
                },
                leading: Icon(
                  Icons.feedback_outlined,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(24),
                ),
                title: Text(
                  "Feedback",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(16),
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).push(
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeftJoined,
                  //     childCurrent: widget,
                  //     duration: const Duration(milliseconds: 120),
                  //     reverseDuration:
                  //         const Duration(milliseconds: 120),
                  //     child: const AboutUs(),
                  //   ),
                  // );
                },
                leading: Icon(
                  CupertinoIcons.exclamationmark_circle,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(24),
                ),
                title: Text(
                  "About us",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(16),
                ),
              ),
              ListTile(
                onTap: () {
                  //     Navigator.of(context).push(
                  //       PageTransition(
                  //         type: PageTransitionType.rightToLeftJoined,
                  //         childCurrent: widget,
                  //         duration: const Duration(milliseconds: 120),
                  //         reverseDuration:
                  //             const Duration(milliseconds: 120),
                  //         child: const TermOfService(),
                  //       ),
                  //     );
                },
                // leading: Icon(
                //   Ionicons.document_outline,
                //   color: Colors.black54,
                //   size: ScreenUtil().setSp(24),
                // ),
                title: Text(
                  "Terms",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(16),
                ),
              ),
              Spacer(),
              Image.asset(
                "assets/images/LOGO.png",
                fit: BoxFit.cover,
                height: 36.h,
                width: 128.w,
                color: Colors.black38,
              ),
              Text(
                "Proudly made in Bharat.",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Image.asset(
                  "assets/images/drawer.png",
                  height: 24.h,
                  width: 24.w,
                ),
              ),
        ),
        // title: Image.asset(
        //   "assets/images/LOGO.png",
        //   fit: BoxFit.cover,
        //   height: 40.h,
        //   width: 140.w,
        //   color: Color(0xFF00493E),
        // ),
        centerTitle: true,
      ),
    );
  }
}

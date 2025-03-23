import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/adminSection/adminOnboarding/adminOnboardingOrgPhoto.dart';

class AdminOnboardingOrgType extends StatefulWidget {
  final String phoneNo;
  final String orgName;
  const AdminOnboardingOrgType({
    super.key,
    required this.phoneNo,
    required this.orgName,
  });

  @override
  State<AdminOnboardingOrgType> createState() => _AdminOnboardingOrgTypeState();
}

class _AdminOnboardingOrgTypeState extends State<AdminOnboardingOrgType> {
  void navigateToPage(BuildContext context, Widget page, Widget currentPage) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeftJoined,
        childCurrent: currentPage,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        child: page,
      ),
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.3, end: 0.6),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF2a52be), Color(0xFF007FFF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: LinearProgressIndicator(
                minHeight: 6,
                value: value,
                backgroundColor: Colors.black12,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          },
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/images/back_button.png",
                  height: 42.h,
                  width: 42.w,
                ),
              ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              "What is your organisation type?",
              style: TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 27.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              "Select your organisation type.",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black54,
                fontFamily: 'Montserrat-SemiBold',
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                navigateToPage(
                  context,
                  AdminOnboardingOrgPhoto(
                    phoneNo: widget.phoneNo,
                    orgName: widget.orgName,
                    orgType: "College/University",
                  ),
                  widget,
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    child: Text(
                      "College / University",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                navigateToPage(
                  context,
                  AdminOnboardingOrgPhoto(
                    phoneNo: widget.phoneNo,
                    orgName: widget.orgName,
                    orgType: "School",
                  ),
                  widget,
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    child: Text(
                      "School",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                navigateToPage(
                  context,
                  AdminOnboardingOrgPhoto(
                    phoneNo: widget.phoneNo,
                    orgName: widget.orgName,
                    orgType: "Corporate/Comapny",
                  ),
                  widget,
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    child: Text(
                      "Corporate / Comapny",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                navigateToPage(
                  context,
                  AdminOnboardingOrgPhoto(
                    phoneNo: widget.phoneNo,
                    orgName: widget.orgName,
                    orgType: "Other",
                  ),
                  widget,
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    child: Text(
                      "Others",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminOnboardingTerms extends StatefulWidget {
  final String phoneNo;
  final String orgName;
  final String orgType;
  final String orgProfilePictureURL;
  const AdminOnboardingTerms({
    super.key,
    required this.phoneNo,
    required this.orgName,
    required this.orgType,
    required this.orgProfilePictureURL,
  });

  @override
  State<AdminOnboardingTerms> createState() => _AdminOnboardingTermsState();
}

class _AdminOnboardingTermsState extends State<AdminOnboardingTerms> {
  final Connectivity _connectivity = Connectivity();
  bool isUploading = false;

  void signUp() async {
    setState(() {
      isUploading = true;
    });
    await addClient(
      orgPhoneNo: widget.phoneNo,
      orgName: widget.orgName,
      orgType: widget.orgType,
      orgProfilePictureURL: widget.orgProfilePictureURL,
    );

    setState(() {
      isUploading = false;
    });
    Navigator.pushNamedAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      "/onboardingDone",
      (route) => false,
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
        centerTitle: true,
        title: Text(
          "Terms Of Service",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontFamily: "Montserrat-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 17.h),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "At Swift, your privacy is of paramount importance to us. We are committed to safeguarding your personal information and ensuring that it remains secure and confidential. Our privacy policy outlines our practices regarding the collection, use, and protection of your data. We guarantee that we do not share your personal data with any third parties without your explicit consent. This includes any information related to your account, usage patterns, or other personal details collected through the app. We utilize advanced encryption technologies and robust security measures to ensure that your data is protected from unauthorized access. Your trust in us is crucial, and we continually strive to uphold the highest standards of privacy and security.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.sp,
                      fontFamily: "Montserrat-Medium",
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "App Walkthrough",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "To help you get started, our app offers a comprehensive walkthrough that guides you through its features and functionalities. This includes step-by-step instructions and an interactive demo that allows you to explore the app's capabilities. The demo includes ghost profiles to simulate real interactions, giving you a realistic preview of how the app works. We hope this walkthrough enhances your experience and helps you make the most of our app.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.sp,
                      fontFamily: "Montserrat-Medium",
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Refund Policy",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "We are committed to providing a high-quality experience and appreciate your interest in our app. To ensure the continued enhancement and stability of our services, we have implemented a no-refund policy. This policy is designed to prevent abuse and ensure that our resources are used effectively to improve the app for all users. We encourage you to thoroughly explore the app’s features and benefits before making any purchases or subscriptions. If you have any questions or concerns, please contact our support team for assistance.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.sp,
                      fontFamily: "Montserrat-Medium",
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Subscription",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "You have the flexibility to manage your subscription at any time. You can cancel your subscription directly through the app. Please note that any cancellation will take effect at the end of your current billing cycle. We recommend reviewing the subscription details and terms before making any changes to ensure that you are fully informed about the service period and billing arrangements.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.sp,
                      fontFamily: "Montserrat-Medium",
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Age Policy",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Swift is designed to cater specifically to individuals who are 18 years of age or older. We are dedicated to providing a safe and responsible environment for adult users. By adhering to a strict 18+ policy, we ensure compliance with legal regulations and community guidelines. This policy helps maintain a mature and respectful community within the app. We appreciate your understanding and cooperation in this matter.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.sp,
                      fontFamily: "Montserrat-Medium",
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Location Privacy",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "We collect location data solely to enhance your user experience and improve the functionality of our app. This data helps us provide location-based services and features relevant to you. Rest assured that your location information, along with any other collected data, is never shared with third parties. We are committed to protecting your privacy and ensuring that your location data remains confidential.",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.sp,
                      fontFamily: "Montserrat-Medium",
                    ),
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white60),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.w,
                    vertical: 16.h,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await _connectivity.checkConnectivity();
                      result.toString() == "ConnectivityResult.none"
                          // ignore: use_build_context_synchronously
                          ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              elevation: 0,
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "You are offline!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontFamily: "Montserrat-Bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : signUp();
                    },
                    child:
                        isUploading
                            ? Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 18.h,
                                    width: 18.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.w,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Creating profile, Please wait...",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontFamily: "Montserrat-SemiBold",
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Container(
                              height: 56.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(
                                    0xFF899CB4,
                                  ).withOpacity(0.1),
                                  width: 1.2.w,
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFff512f),
                                    Color(0xFFdd2476),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                color: const Color(0xFFF4F8FB),
                                borderRadius: BorderRadius.circular(99.r),
                              ),
                              child: Center(
                                child: Text(
                                  "I agree",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontFamily: "Montserrat-Bold",
                                  ),
                                ),
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

Future<void> addClient({
  required String orgPhoneNo,
  required String orgName,
  required String orgType,
  required String orgProfilePictureURL,
}) async {
  final docUser = FirebaseFirestore.instance
      .collection("Clients")
      .doc("CLIENT_$orgPhoneNo");
  final json = {
    // U S E R   D A T A
    "ClientID": "CLIENT_$orgPhoneNo",
    "ClientName": orgName,
    "ClientType": orgType,
    "ClientProfilePicture": orgProfilePictureURL,
    "ClientPhoneNo": orgPhoneNo,

    // R E Q U I R E D   D A T A
    "Ordinates": [],

    // S O C I A L   D E T A I L S
    "InstagramId": "",
    "EmailId": "",
  };
  await docUser.set(json);
}

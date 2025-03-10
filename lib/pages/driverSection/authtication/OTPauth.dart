import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:swift/pages/driverSection/Home/homePage.dart';
import 'package:swift/pages/driverSection/authtication/phoneAuth.dart';
import 'package:swift/pages/driverSection/onboarding/onboardingDetails.dart';

class OTPAuth extends StatefulWidget {
  final String phoneNo;

  final String countryCode;

  const OTPAuth({super.key, required this.phoneNo, required this.countryCode});

  @override
  State<OTPAuth> createState() => _OTPAuthState();
}

class _OTPAuthState extends State<OTPAuth> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  var verificationCode;
  bool isVerifyingOTP = false;

  void otpCheck(val) {
    if (val.length == 6) {
      verifyOTPViaFirebase();
      // Navigator.of(context).push(
      //   PageTransition(
      //       type: PageTransitionType.rightToLeftJoined,
      //       childCurrent: widget,
      //       duration: const Duration(milliseconds: 120),
      //       reverseDuration: const Duration(milliseconds: 120),
      //       child: const OnboardingDetails()),
      // );
    }
  }

  Future<List<String>> getAllDocumentNames() async {
    final collectionReference = FirebaseFirestore.instance.collection(
      'DriversData',
    );
    final querySnapshot = await collectionReference.get();

    final documentNames = querySnapshot.docs.map((doc) => doc.id).toList();

    return documentNames;
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  void verifyOTPViaFirebase() async {
    setState(() {
      isVerifyingOTP = true;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: PhoneAuth.verificationId,
        smsCode: verificationCode,
      );

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      List<String> documentNames = await getAllDocumentNames();

      if (documentNames.contains(widget.phoneNo)) {
        setState(() {
          isVerifyingOTP = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );

        // setPreference(widget.phoneNo);
        // getPreference();
      } else {
        // setState(() {
        //   OnboradingData.phone = widget.phoneNo;
        //   OnboradingData.countryCodeInWords =
        //       OnboardingPhonePage.countryCodeVar;
        // });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingDetails()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        isVerifyingOTP = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFc61a09),
          elevation: 0,
          content: Row(
            children: [
              Text(
                "Wrong OTP",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontFamily: "Montserrat-SemiBold",
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
    );
    const borderColor = Colors.black;

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: GoogleFonts.poppins(fontSize: 22.sp, color: Colors.black),
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56.w,
          height: 2.h,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              "Verify your mobile number",
              style: TextStyle(
                color: Colors.black,
                fontSize: 23.5.sp,
                fontFamily: "Montserrat-Bold",
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "You will recieve a SMS with verification OTP on +91 ${widget.phoneNo}.",
              style: TextStyle(
                color: const Color(0xFF8B8B8B),
                fontSize: 17.sp,
                fontFamily: "Montserrat-Medium",
              ),
            ),
            SizedBox(height: 28.h),
            Pinput(
              onChanged: (value) {
                verificationCode = value;
                otpCheck(value);
              },
              length: 6,
              pinAnimationType: PinAnimationType.slide,
              controller: controller,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              showCursor: true,
              cursor: cursor,
              preFilledWidget: preFilledWidget,
            ),
            const Spacer(),
            isVerifyingOTP
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
                        "Verifying OTP, Please wait...",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: "Montserrat-SemiBold",
                        ),
                      ),
                    ],
                  ),
                )
                : const SizedBox.shrink(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

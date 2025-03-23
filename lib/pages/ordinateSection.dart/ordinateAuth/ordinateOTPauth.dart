import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift/deltaFiles/appControl.dart';
import 'package:swift/pages/driverSection/Home/homePage.dart';
import 'package:swift/pages/ordinateSection.dart/pages/ordinateHomePage.dart';
import 'package:swift/pages/ordinateSection.dart/ordinateAuth/ordinatePhoneAuth.dart';

class OrdinateOTPAuth extends StatefulWidget {
  final String phoneNo;
  final String countryCode;
  final String uniqueID;

  const OrdinateOTPAuth({
    super.key,
    required this.phoneNo,
    required this.countryCode,
    required this.uniqueID,
  });

  @override
  State<OrdinateOTPAuth> createState() => _OrdinateOTPAuthState();
}

class _OrdinateOTPAuthState extends State<OrdinateOTPAuth> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool isVerifyingOTP = false;

  Future<void> setPreference(String userID, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedUserID', userID);
    await prefs.setString('loggedUserType', userType);
  }

  Future<void> getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedUserID = prefs.getString('loggedUserID');
    String? loggedUserType = prefs.getString('loggedUserType');

    if (loggedUserID != null && mounted) {
      setState(() {
        AppControl.loggedUserID = loggedUserID;
        AppControl.loggedUserType = loggedUserType ?? ''; // Handle null case
      });
    }
  }

  void otpCheck(val) {
    if (val.length == 6) {
      verifyOTPViaFirebase();
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
        verificationId: OrdinatePhoneAuth.verificationId,
        smsCode: controller.text.trim(),
      );

      // Sign in with credential
      await auth.signInWithCredential(credential);

      bool isPhoneRegistered =
          (await FirebaseFirestore.instance
                  .collection('DriversData')
                  .doc(widget.phoneNo)
                  .get())
              .exists;

      await setPreference(widget.uniqueID, 'ordinate');

      if (isPhoneRegistered) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OrdinateHomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        isVerifyingOTP = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFc61a09),
          content: Text(
            "Wrong OTP",
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white,
              fontFamily: "Montserrat-SemiBold",
            ),
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

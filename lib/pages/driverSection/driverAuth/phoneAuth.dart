import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/driverSection/driverAuth/OTPauth.dart';

class DriverPhoneAuth extends StatefulWidget {
  const DriverPhoneAuth({super.key});
  static var verificationId;

  @override
  State<DriverPhoneAuth> createState() => _DriverPhoneAuthState();
}

class _DriverPhoneAuthState extends State<DriverPhoneAuth> {
  GlobalKey<FormState> onboardingPhoneFormKey = GlobalKey<FormState>();
  var phoneNo;
  bool isTen = false;
  bool isSendingOTP = false;

  void checkPhoneNo(val) {
    if (val.length == 10) {
      setState(() {
        isTen = true;
      });
    } else {
      setState(() {
        isTen = false;
      });
    }
  }

  void sendOTPViaFireBase() async {
    setState(() {
      isSendingOTP = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNo',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isSendingOTP = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            DriverPhoneAuth.verificationId = verificationId;
            isSendingOTP = false;
          });

          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeftJoined,
              childCurrent: widget,
              duration: const Duration(milliseconds: 120),
              reverseDuration: const Duration(milliseconds: 120),
              child: DriverOTPAuth(phoneNo: phoneNo, countryCode: "+91"),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        isSendingOTP = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected Error: $e")));
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
      body: SingleChildScrollView(
        child: Form(
          key: onboardingPhoneFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  "Enter your phone no.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.5.sp,
                    fontFamily: "Montserrat-Bold",
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "We need to send code to verify your phone number.",
                  style: TextStyle(
                    color: const Color(0xFF8B8B8B),
                    fontSize: 17.sp,
                    fontFamily: "Montserrat-Medium",
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flag.fromString(
                          "in",
                          height: 26.h,
                          width: 37.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "+91",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.sp,
                            fontFamily: "Montserrat-Bold",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.h),
                    SizedBox(
                      width: 250.w,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your Phone number";
                          } else if (value.length != 10) {
                            return "Enter valid Phone number";
                          } else {
                            return null;
                          }
                        },
                        cursorColor: Colors.black,
                        style: TextStyle(
                          fontFamily: "Montserrat-SemiBold",
                          color: Colors.black,
                          fontSize: 18.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter Phone no.",
                          hintStyle: TextStyle(
                            fontFamily: "Montserrat-SemiBold",
                            fontSize: 18.sp,
                            color: Colors.black38,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1.2.w,
                            ),
                            borderRadius: BorderRadius.circular(0.r),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.6.w,
                            ),
                            borderRadius: BorderRadius.circular(0.r),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onChanged: (value) {
                          setState(() {
                            phoneNo = value;
                            checkPhoneNo(value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                isSendingOTP
                    ? Center(
                      child: SizedBox(
                        height: 58.h,
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
                              "Sending OTP, Please wait...",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.sp,
                                fontFamily: "Montserrat-SemiBold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () {
                        if (onboardingPhoneFormKey.currentState!.validate()) {
                          sendOTPViaFireBase();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Container(
                          height: 58.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF899CB4).withOpacity(0.1),
                              width: 1.2.w,
                            ),
                            color:
                                isTen ? Colors.black : const Color(0xFFF4F8FB),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                color:
                                    isTen
                                        ? Colors.white
                                        : const Color(0xFF899CB4),
                                fontFamily: "Montserrat-Bold",
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

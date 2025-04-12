import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/moderatorSection/moderatorAuth/moderatorOTPAuth.dart';

class ModeratorPhoneAuth extends StatefulWidget {
  final String clientId;
  final moderatorList;

  const ModeratorPhoneAuth({
    super.key,
    required this.clientId,
    required this.moderatorList,
  });
  static var verificationId;

  @override
  State<ModeratorPhoneAuth> createState() => _ModeratorPhoneAuthState();
}

class _ModeratorPhoneAuthState extends State<ModeratorPhoneAuth> {
  GlobalKey<FormState> onboardingPhoneFormKey = GlobalKey<FormState>();
  var moderatorID;
  bool isTen = false;

  bool isSendingOTP = false;

  void checkmoderatorID(val) {
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

  void getOrdinateData(moderatorID) {
    setState(() {
      isSendingOTP = true;
    });
    FirebaseFirestore.instance
        .collection("Moderators")
        .doc(moderatorID)
        .get()
        .then((docSnapshot) {
          var data = docSnapshot.data();
          var phoneNo = data?["PhoneNo"];
          sendOTPViaFireBase(phoneNo);
        });
  }

  void sendOTPViaFireBase(String phoneNo) async {
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
            ModeratorPhoneAuth.verificationId = verificationId;
            isSendingOTP = false;
          });

          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeftJoined,
              childCurrent: widget,
              duration: const Duration(milliseconds: 120),
              reverseDuration: const Duration(milliseconds: 120),
              child: ModeratorOTPAuth(
                phoneNo: phoneNo,
                countryCode: "+91",
                uniqueID: moderatorID,
              ),
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
                  "Enter your ID",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.5.sp,
                    fontFamily: "Montserrat-Bold",
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Enter your unique id given by your organisation to verify yourself.",
                  style: TextStyle(
                    color: const Color(0xFF8B8B8B),
                    fontSize: 17.sp,
                    fontFamily: "Montserrat-Medium",
                  ),
                ),
                SizedBox(height: 24.h),
                TextFormField(
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
                    hintText: "Enter ID",
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
                      borderSide: BorderSide(color: Colors.black, width: 1.6.w),
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
                      moderatorID = value;
                      checkmoderatorID(value);
                    });
                  },
                ),
                SizedBox(height: 36.h),
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
                          if (widget.moderatorList.contains(moderatorID)) {
                            getOrdinateData(moderatorID);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  151,
                                  101,
                                  0,
                                ),
                                elevation: 0,
                                content: Row(
                                  children: [
                                    Text(
                                      "ID not Found!",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

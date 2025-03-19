import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/driverSection/onboarding/onboardingPhoto.dart';

class OnboardingDetails extends StatefulWidget {
  const OnboardingDetails({super.key});

  @override
  State<OnboardingDetails> createState() => _OnboardingDetailsState();
}

class _OnboardingDetailsState extends State<OnboardingDetails> {
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
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Your Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontFamily: "Montserrat-Medium",
              ),
            ),
            TextFormField(
              // controller: _firstNameFieldController,
              // focusNode: _firstNamefocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your first name ";
                } else if (value.isEmpty ||
                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  return "Enter a valid first name";
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                // check();
                setState(() {
                  // OnboradingData.name = value.trim();
                });
              },
              onFieldSubmitted: (value) {
                // _firstNamefocusNode.unfocus();
              },
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              cursorColor: Colors.black,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontFamily: "Montserrat-SemiBold",
              ),
              decoration: InputDecoration(
                hintText: "Enter your name",
                hintStyle: TextStyle(
                  fontFamily: "Montserrat-SemiBold",
                  fontSize: 17.sp,
                  color: Colors.black12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1.2.w),
                  borderRadius: BorderRadius.circular(0.r),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1.5.w),
                  borderRadius: BorderRadius.circular(0.r),
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeftJoined,
                    childCurrent: widget,
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 200),
                    child: const Onboardingphoto(),
                  ),
                );
                // if (firstnameFormKey.currentState!.validate()) {
                //   setState(() {
                //     OnboradingData.name = _firstNameFieldController.text.trim();
                //   });
                //   Navigator.of(context).push(
                //     PageTransition(
                //       type: PageTransitionType.rightToLeftJoined,
                //       childCurrent: widget,
                //       duration: const Duration(milliseconds: 200),
                //       reverseDuration: const Duration(milliseconds: 200),
                //       child: const OnboardingGender(),
                //     ),
                //   );
                // }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF899CB4).withOpacity(0.1),
                      width: 1.2.w,
                    ),
                    // gradient:
                    //     isFilled
                    //         ? const LinearGradient(
                    //           colors: [Color(0xFFff512f), Color(0xFFdd2476)],
                    //           begin: Alignment.topLeft,
                    //           end: Alignment.bottomRight,
                    //         )
                    //         : null,
                    color: Colors.black,
                    // isFilled ? Colors.black : const Color(0xFFF4F8FB),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.h),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          // isFilled
                          //     ? Colors.white
                          //     : const Color(0xFF899CB4),
                          fontFamily: 'Montserrat-Bold',
                          fontSize: 15.sp,
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

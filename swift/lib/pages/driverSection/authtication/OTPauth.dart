import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:swift/pages/driverSection/onboarding/onboardingDetails.dart';

class OTPAuth extends StatefulWidget {
  final String phoneNo;

  const OTPAuth({
    super.key,
    required this.phoneNo,
  });

  @override
  State<OTPAuth> createState() => _OTPAuthState();
}

class _OTPAuthState extends State<OTPAuth> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  var verificationCode;

  void otpCheck(val) {
    if (val.length == 6) {
      Navigator.of(context).push(
        PageTransition(
            type: PageTransitionType.rightToLeftJoined,
            childCurrent: widget,
            duration: const Duration(milliseconds: 120),
            reverseDuration: const Duration(milliseconds: 120),
            child: const OnboardingDetails()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    const borderColor = Colors.black;

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: GoogleFonts.poppins(
        fontSize: 22.sp,
        color: Colors.black,
      ),
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
            builder: (context) => IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    "assets/images/back_button.png",
                    height: 42.h,
                    width: 42.w,
                  ),
                )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Verify your mobile number",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.5.sp,
                  fontFamily: "Montserrat-Bold",
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                "You will recieve a SMS with verification OTP on +91 ${widget.phoneNo}.",
                style: TextStyle(
                  color: const Color(0xFF8B8B8B),
                  fontSize: 17.sp,
                  fontFamily: "Montserrat-Medium",
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
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
              SizedBox(
                height: 24.h,
              )
            ]),
      ),
    );
  }
}

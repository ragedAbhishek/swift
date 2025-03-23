import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/adminSection/adminOnboarding/adminOnboardingOrgType.dart';

class AdminOnboardName extends StatefulWidget {
  final String phoneNo;
  const AdminOnboardName({super.key, required this.phoneNo});

  @override
  State<AdminOnboardName> createState() => _AdminOnboardNameState();
}

class _AdminOnboardNameState extends State<AdminOnboardName> {
  GlobalKey<FormState> onboardingAdminNameFormKey = GlobalKey<FormState>();
  final TextEditingController onboardingAdminName = TextEditingController();
  bool isFilled = false;
  void check() {
    if (onboardingAdminName.text.trim().isNotEmpty) {
      setState(() {
        isFilled = true;
      });
    } else {
      setState(() {
        isFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Form(
          key: onboardingAdminNameFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 0.3),
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
              Text(
                "What's your organisation\nname ?",
                style: TextStyle(
                  fontFamily: "Montserrat-ExtraBold",
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: onboardingAdminName,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your org name ";
                  } else if (value.isEmpty ||
                      !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                    return "Enter a valid org name";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  check();
                },
                onFieldSubmitted: (value) {},
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: "Montserrat-SemiBold",
                ),
                decoration: InputDecoration(
                  hintText: "Your org name",
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
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  if (onboardingAdminNameFormKey.currentState!.validate()) {
                    Navigator.of(context).push(
                      PageTransition(
                        type: PageTransitionType.rightToLeftJoined,
                        childCurrent: widget,
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(milliseconds: 200),
                        child: AdminOnboardingOrgType(
                          phoneNo: widget.phoneNo,
                          orgName: onboardingAdminName.text.trim(),
                        ),
                      ),
                    );
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
                          isFilled
                              ? Color(0xFF266FEF)
                              : const Color(0xFFF4F8FB),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color:
                              isFilled ? Colors.white : const Color(0xFF899CB4),
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddOrdinate extends StatefulWidget {
  final String organisationID;
  final String organisationName;
  const AddOrdinate({
    super.key,
    required this.organisationID,
    required this.organisationName,
  });

  @override
  State<AddOrdinate> createState() => _AddOrdinateState();
}

class _AddOrdinateState extends State<AddOrdinate> {
  GlobalKey<FormState> ordinatePageFormKey = GlobalKey<FormState>();
  final TextEditingController uniqueIDController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  bool areFilled = false;

  void areDetailsFilled() {
    if (uniqueIDController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        phoneNoController.text.trim().length == 10) {
      setState(() {
        areFilled = true;
      });
    } else {
      setState(() {
        areFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Add Ordinate",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontFamily: "Montserrat-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Form(
            key: ordinatePageFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  "Add a ordinates so that they could use the app on your behalf.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Unique ID",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                ),
                TextFormField(
                  controller: uniqueIDController,
                  onChanged: (value) {
                    areDetailsFilled();
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a unique ID";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Enter a unique ID",
                    hintStyle: TextStyle(
                      fontFamily: "Montserrat-SemiBold",
                      fontSize: 17.sp,
                      color: Colors.black12,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 1.2.w,
                      ),
                      borderRadius: BorderRadius.circular(0.r),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.circular(0.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Ordinate Name",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    areDetailsFilled();
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter ordinate name";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: "Enter a unique ID",
                    hintStyle: TextStyle(
                      fontFamily: "Montserrat-SemiBold",
                      fontSize: 17.sp,
                      color: Colors.black12,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 1.2.w,
                      ),
                      borderRadius: BorderRadius.circular(0.r),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.circular(0.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Phone no.",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                ),
                TextFormField(
                  controller: phoneNoController,
                  onChanged: (value) {
                    areDetailsFilled();
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter a unique ID";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  decoration: InputDecoration(
                    prefix: Text("+91 "),
                    prefixStyle: TextStyle(
                      fontFamily: "Montserrat-SemiBold",
                      fontSize: 17.sp,
                      color: Colors.black,
                    ),
                    hintText: "Enter phone no.",
                    hintStyle: TextStyle(
                      fontFamily: "Montserrat-SemiBold",
                      fontSize: 17.sp,
                      color: Colors.black12,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 1.2.w,
                      ),
                      borderRadius: BorderRadius.circular(0.r),
                    ),

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.circular(0.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    if (ordinatePageFormKey.currentState!.validate()) {
                      addOrdinate(
                        uniqueID: uniqueIDController.text.trim(),
                        ordinateName: nameController.text.trim(),
                        phoneNo: phoneNoController.text.trim(),
                        organisationName: widget.organisationName,
                        organisationID: widget.organisationID,
                      );

                      Navigator.of(context).pop();
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
                            areFilled ? Colors.black : const Color(0xFFF4F8FB),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color:
                                areFilled
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

Future<void> addOrdinate({
  required String uniqueID,
  required String ordinateName,
  required String phoneNo,
  required String organisationName,
  required String organisationID,
}) async {
  final docUser = FirebaseFirestore.instance
      .collection("Ordinates")
      .doc(uniqueID);
  final json = {
    "Name": ordinateName,
    "OrdinateID": uniqueID,
    "OrganisationID": organisationID,
    "OrganisationName": organisationName,
    "PhoneNo": phoneNo,
  };
  await docUser.set(json);
  Fluttertoast.showToast(
    msg: "Details added Successfully!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

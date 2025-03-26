import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
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

  //  final List<SkillEntry> _skills = [];
  // final List<GlobalKey<FormState>> _formKeys = [];

  // void _addNewSkill() {
  //   for (var formKey in _formKeys) {
  //     if (formKey.currentState != null && !formKey.currentState!.validate()) {
  //       return; // If any form is invalid, return without adding a new skill
  //     }
  //   }

  //   if (_skills.length < widget.skillMax) {
  //     setState(() {
  //       _skills.add(SkillEntry());
  //       _formKeys.add(GlobalKey<FormState>());
  //     });
  //   }
  // }

  // void _deleteSkill(int index) {
  //   setState(() {
  //     _skills.removeAt(index);
  //     _formKeys.removeAt(index);
  //   });
  // }

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
          "Add Vehicle",
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
                  "Add a vehicle to your fleet.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat-SemiBold",
                  ),
                ),
                SizedBox(height: 20.h),

                Text(
                  "Route ID",
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
                      return "Enter route ID";
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: "Enter route ID",
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
                        // organisationName: widget.organisationName,
                        // organisationID: widget.organisationID,
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
  // required String organisationName,
  // required String organisationID,
}) async {
  final docUser = FirebaseFirestore.instance
      .collection("Ordinates")
      .doc(uniqueID);
  final json = {
    "Name": ordinateName,
    "OrdinateID": uniqueID,
    // "OrganisationID": organisationID,
    // "OrganisationName": organisationName,
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

class SkillEntry {
  String skillName;
  double expertise;

  SkillEntry({this.skillName = '', this.expertise = 0.2});
}

class SkillTile extends StatefulWidget {
  final SkillEntry skillEntry;
  final VoidCallback onDelete;

  SkillTile({Key? key, required this.skillEntry, required this.onDelete})
    : super(key: key);

  @override
  State<SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<SkillTile> {
  String skill = "";
  double experience = 0;
  Color b_color = const Color(0xFFe7f4ed);
  Color buttonColor = const Color(0xFF48ba75);
  String expertise = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            // tilePadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0.w),
            collapsedBackgroundColor: Colors.black12.withOpacity(0.03),
            backgroundColor: Colors.black12.withOpacity(0.03),
            trailing: IconButton(
              onPressed: widget.onDelete,
              icon: Icon(
                CupertinoIcons.delete,
                color: Colors.black,
                size: ScreenUtil().setSp(26),
              ),
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),

            initiallyExpanded: true,
            maintainState: true,
            title: Text(
              skill == "" ? "Your skill" : skill,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
              ),
            ),
            subtitle: Text(
              expertise == "" ? "Expertise" : expertise,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Skill",
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 17.sp,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    // TextFormField(
                    //   textCapitalization: TextCapitalization.words,
                    //   initialValue: widget.skillEntry.skillName,
                    //   onChanged: (val) {
                    //     widget.skillEntry.skillName = val.trim();
                    //     setState(() {
                    //       skill = val;
                    //     });
                    //   },
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 18.sp,
                    //       fontWeight: FontWeight.w400),
                    //   decoration: InputDecoration(
                    //       hintText: "Enter your skill",
                    //       hintStyle: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 18.sp,
                    //           color: Colors.black12),
                    //       focusedBorder: UnderlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Colors.black, width: 1.6.w),
                    //       )),
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Please enter a skill name';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(height: 24.h),
                    // RichText(
                    //     text: TextSpan(children: [
                    //   TextSpan(
                    //     text: "Level ",
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 17.sp,
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    //   TextSpan(
                    //       text: expertise,
                    //       style: TextStyle(color: buttonColor, fontSize: 16.sp))
                    // ])),
                    // SizedBox(height: 12.h),

                    // AnimatedButtonBar(
                    //     backgroundColor: b_color,
                    //     foregroundColor: buttonColor,
                    //     radius: 8.0,
                    //     // padding: const EdgeInsets.all(16.0),
                    //     invertedSelection: true,
                    //     innerVerticalPadding: 15,
                    //     children: [
                    //       ButtonBarEntry(
                    //           onTap: () {
                    //             widget.skillEntry.expertise = 0.2;
                    //             setState(() {
                    //               buttonColor = const Color(0xFF48ba75);
                    //               experience = 1;
                    //               b_color = const Color(0xFFe7f4ed);
                    //               expertise = "Novice";
                    //             });
                    //           },
                    //           child: const Text('1')),
                    //       ButtonBarEntry(
                    //           onTap: () {
                    //             widget.skillEntry.expertise = 0.4;
                    //             setState(() {
                    //               experience = 2;
                    //               b_color = const Color(0xFFfeebe3);
                    //               expertise = "Beginner";
                    //               buttonColor = const Color(0xFFf68559);
                    //             });
                    //           },
                    //           child: const Text('2')),
                    //       ButtonBarEntry(
                    //           onTap: () {
                    //             widget.skillEntry.expertise = 0.6;
                    //             setState(() {
                    //               experience = 3;
                    //               b_color = const Color(0xFFfff2cc);
                    //               expertise = "Skillful";
                    //               buttonColor = const Color(0xFFec930c);
                    //             });
                    //           },
                    //           child: const Text('3')),
                    //       ButtonBarEntry(
                    //           onTap: () {
                    //             widget.skillEntry.expertise = 0.8;
                    //             setState(() {
                    //               experience = 4;
                    //               b_color = const Color(0xFFffeaec);
                    //               expertise = "Experienced";

                    //               buttonColor = const Color(0xFFfe7d8b);
                    //             });
                    //           },
                    //           child: const Text('4')),
                    //       ButtonBarEntry(
                    //           onTap: () {
                    //             widget.skillEntry.expertise = 1.0;
                    //             setState(() {
                    //               buttonColor = const Color(0xFF9ba1fb);
                    //               experience = 5;
                    //               b_color = const Color(0xFFf1f2ff);
                    //               expertise = "Expert";
                    //             });
                    //           },
                    //           child: const Text('5')),
                    //     ]),
                    // SizedBox(height: 24.h),
                    // // Align(
                    // //   alignment: Alignment.centerRight,
                    // //   child: IconButton(
                    // //     icon: Icon(Icons.delete, color: Colors.red),
                    // //     onPressed: widget.onDelete,
                    // //   ),
                    // // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddOrdinate extends StatefulWidget {
  const AddOrdinate({super.key});

  @override
  State<AddOrdinate> createState() => _AddOrdinateState();
}

class _AddOrdinateState extends State<AddOrdinate> {
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
        centerTitle: false,
        title: Text(
          "Add Ordinate",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontFamily: "Montserrat-SemiBold",
          ),
        ),
      ),
    );
  }
}

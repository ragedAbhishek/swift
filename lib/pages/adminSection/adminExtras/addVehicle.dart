import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
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
          "Add Vehicle",
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/deltaFiles/appControl.dart';
import 'package:swift/pages/adminSection/adminExtras/addVehicle.dart';

class AdminVehiclesPage extends StatefulWidget {
  const AdminVehiclesPage({super.key});

  @override
  State<AdminVehiclesPage> createState() => _AdminVehiclesPageState();
}

class _AdminVehiclesPageState extends State<AdminVehiclesPage> {
  void navigateToPage(BuildContext context, Widget page, Widget currentPage) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeftJoined,
        childCurrent: currentPage,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        child: page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white, // Set the color here
      ),
    );
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance
              .collection('Clients')
              .doc(AppControl.loggedUserID.toString())
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return Scaffold(backgroundColor: Colors.white);
        }

        var data = snapshot.data!.data()!;

        String clientName = data["ClientName"] ?? "";

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$clientName\nVehicle Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 20.sp,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    navigateToPage(context, AddVehicle(), widget);
                  },
                  child: Text("Add Vehicle"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

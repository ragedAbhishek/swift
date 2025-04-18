import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/deltaFiles/appControl.dart';
import 'package:swift/pages/adminSection/adminExtras/addOrdinate.dart';

class AdminOrdinatesPage extends StatefulWidget {
  const AdminOrdinatesPage({super.key});

  @override
  State<AdminOrdinatesPage> createState() => _AdminOrdinatesPageState();
}

class _AdminOrdinatesPageState extends State<AdminOrdinatesPage> {
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
        String clientID = data["ClientID"] ?? "";
        List ordinates = data["Ordinates"] ?? [];

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$clientName\nOrdinate Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 20.sp,
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    navigateToPage(
                      context,
                      AddOrdinate(
                        organisationID: clientID,
                        organisationName: clientName,
                      ),
                      widget,
                    );
                  },
                  child: Text("Add Ordinate"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/studentSection.dart/studentAuth/studentPhoneAuth.dart';

class InstituteSelection extends StatefulWidget {
  const InstituteSelection({super.key});

  @override
  State<InstituteSelection> createState() => _InstituteSelectionState();
}

class _InstituteSelectionState extends State<InstituteSelection> {
  @override
  void initState() {
    // TODO: implement initState
    getAllclients();
    super.initState();
  }

  List<String> clients = [];
  void getAllclients() async {
    final collectionReference = FirebaseFirestore.instance.collection(
      'clients',
    );
    final querySnapshot = await collectionReference.get();

    final documentNames = querySnapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      clients = documentNames;
    });
  }

  Future<Map<String, dynamic>> getClientData(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('clients').doc(id).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() ?? {};
      return data;
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Institute Selection",
          style: TextStyle(fontFamily: "Montserrat-SemiBold", fontSize: 20.sp),
        ),
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
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        itemCount: clients.length, // Ensure itemCount is provided
        itemBuilder: (context, index) {
          return FutureBuilder<Map<String, dynamic>>(
            future: getClientData(clients[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(height: 0);
              } else {
                Map<String, dynamic> userData = snapshot.data ?? {};
                String clientName = userData["ClientName"] ?? '';
                String clientLogo = userData["Logo"] ?? '';
                String clientID = userData["ClientID"] ?? '';
                List ordinatesList = userData["Ordinates"] ?? [];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageTransition(
                        type: PageTransitionType.rightToLeftJoined,
                        childCurrent: widget,
                        duration: const Duration(milliseconds: 120),
                        reverseDuration: const Duration(milliseconds: 120),
                        child: StudentPhoneAuth(
                          clientID: clientID,
                          ordinatesList: ordinatesList,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Container(
                      height: 52.h,
                      width: 52.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(clientLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(clientName),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

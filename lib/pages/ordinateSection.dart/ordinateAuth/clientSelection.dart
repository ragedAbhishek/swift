import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swift/pages/ordinateSection.dart/ordinateAuth/ordinatePhoneAuth.dart';

class ClientSelection extends StatefulWidget {
  const ClientSelection({super.key});

  @override
  State<ClientSelection> createState() => _ClientSelectionState();
}

class _ClientSelectionState extends State<ClientSelection> {
  List<String> clients = [];
  bool isfetchingClients = false;

  @override
  void initState() {
    getAllclients();
    super.initState();
  }

  void getAllclients() async {
    setState(() {
      isfetchingClients = true;
    });
    final collectionReference = FirebaseFirestore.instance.collection(
      'Clients',
    );
    final querySnapshot = await collectionReference.get();
    final documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      clients = documentNames;
      isfetchingClients = false;
    });
  }

  Future<Map<String, dynamic>> getClientData(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Clients').doc(id).get();
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
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Organisations",
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),

            Text(
              "Click on the organisation you wish to avail service.",
              style: TextStyle(
                fontFamily: "Montserrat-SemiBold",
                color: Colors.black45,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            isfetchingClients
                ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: const Color.fromARGB(31, 48, 48, 48),
                      highlightColor: Colors.white10,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Container(
                          width: double.infinity,
                          height: 66.h,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: clients.length, // Ensure itemCount is provided
                  itemBuilder: (context, index) {
                    return FutureBuilder<Map<String, dynamic>>(
                      future: getClientData(clients[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: const Color.fromARGB(31, 48, 48, 48),
                            highlightColor: Colors.white10,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Container(
                                width: double.infinity,
                                height: 66.h,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          );
                        } else {
                          Map<String, dynamic> userData = snapshot.data ?? {};
                          String clientName = userData["ClientName"] ?? '';
                          String clientLogo =
                              userData["ClientProfilePicture"] ?? '';
                          String clientID = userData["ClientID"] ?? '';
                          String clientType = userData["ClientType"] ?? '';
                          List ordinatesList = userData["Ordinates"] ?? [];
                          int ordinateIdLength =
                              userData["OrdinateIdLength"] ?? 0;

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType.rightToLeftJoined,
                                  childCurrent: widget,
                                  duration: const Duration(milliseconds: 120),
                                  reverseDuration: const Duration(
                                    milliseconds: 120,
                                  ),
                                  child: OrdinatePhoneAuth(
                                    clientID: clientID,
                                    ordinatesList: ordinatesList,
                                    ordinateIdLength: ordinateIdLength,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0.w,
                              ),
                              leading: Container(
                                height: 48.h,
                                width: 48.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      clientLogo,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                clientName,
                                style: TextStyle(
                                  fontFamily: "Montserrat-Bold",
                                  fontSize: 18.sp,
                                ),
                              ),
                              subtitle: Text(
                                clientType,
                                style: TextStyle(
                                  fontFamily: "Montserrat-Bold",
                                  color: Colors.black45,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}

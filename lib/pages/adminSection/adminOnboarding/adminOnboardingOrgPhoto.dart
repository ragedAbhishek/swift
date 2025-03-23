import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swift/pages/adminSection/adminOnboarding/adminOnboardingTerms.dart';

class AdminOnboardingOrgPhoto extends StatefulWidget {
  final String phoneNo;
  final String orgName;
  final String orgType;
  const AdminOnboardingOrgPhoto({
    super.key,
    required this.phoneNo,
    required this.orgName,
    required this.orgType,
  });

  @override
  _AdminOnboardingOrgPhotoState createState() =>
      _AdminOnboardingOrgPhotoState();
}

final FirebaseStorage storage = FirebaseStorage.instance;

class _AdminOnboardingOrgPhotoState extends State<AdminOnboardingOrgPhoto> {
  UploadTask? uploadTask;
  String imageDownloadURL = "";
  var croppedFileVar;
  bool showError = false;
  bool isUploading = false;
  Future<void> uploadFile(File file) async {
    setState(() {
      isUploading = true;
    });
    final ref = FirebaseStorage.instance.ref().child(
      "clientProfilePicture/${widget.phoneNo.toString()}.jpg",
    );
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!;

    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      imageDownloadURL = urlDownload;
      // OnboradingData.imageUrl = urlDownload;
      isUploading = false;
    });
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeftJoined,
        childCurrent: widget,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        child: AdminOnboardingTerms(
          phoneNo: widget.phoneNo,
          orgName: widget.orgName,
          orgType: widget.orgType,
          orgProfilePictureURL: urlDownload,
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _cropImage(pickedFile);
        showError = false;
      });
    }
  }

  Future<void> _cropImage(var _pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 40,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            hideBottomControls: true,
            toolbarTitle: 'Edit',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          croppedFileVar = croppedFile;
        });
      }
    }
  }

  Future<void> takePicture() async {
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(
      preferredCameraDevice: CameraDevice.rear,
      source: ImageSource.camera,
    );

    if (imageFile == null) return;
    _cropImage(imageFile);
  }

  void showPhotoOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101010),
      context: context,
      builder: (context) {
        return Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                const Divider(
                  color: Colors.black12,
                  thickness: 3,
                  endIndent: 152,
                  indent: 152,
                ),
                SizedBox(height: 6.h),
                Text(
                  "Choose Option",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontFamily: 'Montserrat-Bold',
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    selectImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Center(
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat-SemiBold',
                            fontSize: 19.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () {
                    takePicture();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Center(
                        child: Text(
                          "Camera",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat-SemiBold',
                            fontSize: 19.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.6, end: 1),
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
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          },
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showPhotoOptions();
              },
              child: Container(
                height: 380.h,
                width: double.infinity,
                decoration:
                    croppedFileVar != null
                        ? BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFFF4F8FB),
                          borderRadius: BorderRadius.circular(24.r),
                          image: DecorationImage(
                            image: FileImage(File(croppedFileVar!.path!)),
                            fit: BoxFit.cover,
                          ),
                        )
                        : BoxDecoration(
                          color: const Color(0xFFF4F8FB),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 160.h),
                      Center(
                        child: Text(
                          "Add your best photo",
                          style: TextStyle(
                            color: Colors.black38,
                            fontFamily: 'Montserrat-SemiBold',
                            fontSize: 19.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${widget.orgName}, ",
                              style: TextStyle(
                                color:
                                    croppedFileVar == null
                                        ? Colors.black
                                        : Colors.white,
                                fontFamily: 'Montserrat-Bold',
                                fontSize: 24.sp,
                              ),
                            ),
                            // TextSpan(
                            //   text: "${widget.orgType}",
                            //   style: TextStyle(
                            //     color:
                            //         croppedFileVar == null
                            //             ? Colors.black
                            //             : Colors.white,
                            //     fontFamily: 'Montserrat-SemiBold',
                            //     fontSize: 20.sp,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Text(
                        widget.orgType,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              croppedFileVar == null
                                  ? Colors.black
                                  : Colors.white,
                          fontFamily: 'Montserrat-Medium',
                          fontSize: 17.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            croppedFileVar == null
                ? const SizedBox.shrink()
                : isUploading
                ? Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 18.h,
                        width: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Uploading Photo , Please wait...",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat-SemiBold',
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                )
                : InkWell(
                  onTap: () {
                    if (croppedFileVar != null) {
                      uploadFile(File(croppedFileVar.path!));
                    } else {
                      setState(() {
                        showError = true;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF899CB4).withOpacity(0.1),
                          width: 1.2.w,
                        ),

                        color:
                            croppedFileVar != null
                                ? Color(0xFF266FEF)
                                : const Color(0xFFF4F8FB),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color:
                                croppedFileVar != null
                                    ? Colors.white
                                    : const Color(0xFF899CB4),
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

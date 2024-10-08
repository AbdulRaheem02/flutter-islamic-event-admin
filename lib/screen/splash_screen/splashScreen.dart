import 'dart:async';

import 'package:islamic_event_admin/binding/InitialControllerBinding.dart';
import 'package:islamic_event_admin/screen/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../core/app_export.dart';
import '../../custom_widgets/InternalStorage.dart';
import '../sign_in_screen/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    init();
    super.initState();
  }

  Future<void> init() async {
    String token = await getAccessToken();

    // clearEveryThing();
    Get.log("token = $token");
    if (token != "") {
      Get.to(() => const HomePage(), binding: IntialBinding());
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      // backgroundColor:
      //     theme.colorScheme.primary, // Choose your desired background color
      body: Center(
        child: CustomImageView(
          imagePath: ImageConstant.logo,

          height: 100.v,
          // width: 190.h,
        ),
      ),
    );
  }
}

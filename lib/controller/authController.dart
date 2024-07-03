import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:islamic_event_admin/api-handler/api-extention.dart';
import 'package:islamic_event_admin/screen/pdf/pdfScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Deo;

import '../api-handler/api-repo.dart';
import '../api-handler/env_constants.dart';
import 'package:path_provider/path_provider.dart';

import '../custom_widgets/InternalStorage.dart';
import '../custom_widgets/toast.dart';
import '../screen/home_page_screen.dart';
import '../screen/sign_in_screen/otpScreen.dart';
import '../screen/sign_in_screen/reset_password_screen.dart';
import '../screen/sign_up_screen/verification_screen.dart';

class AuthController extends GetxController {
  ApiRepository apiRepository;
  AuthController(this.apiRepository);

  void register(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.registeruser(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");

        Get.back();
      }
    });
  }

  void login(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.loginuser(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");
        saveAccessToken(reponse.data['token']);
        Get.to(() => const HomePage());
      }
    });
  }

  Future<void> forgetpassword(Map<String, dynamic> params) async {
    EasyLoading.show();
    print("type ${params.runtimeType}");
    await apiRepository.forgetpassword(params).getResponse((reponse) {
      EasyLoading.dismiss();

      Get.to(() => OtpVerificationScreen(
            email: params['email'],
          ));
      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> resendOtp(Map<String, dynamic> params) async {
    EasyLoading.show();
    print("type ${params.runtimeType}");
    await apiRepository.resendOtp(params).getResponse((reponse) {
      EasyLoading.dismiss();

      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> verifyForgotPasswordOtp(Map<String, dynamic> params) async {
    EasyLoading.show();
    print("type ${params.runtimeType}");
    await apiRepository.verifyForgotPasswordOtp(params).getResponse((reponse) {
      EasyLoading.dismiss();

      Get.to(() => VerificationScreen(
            email: params['email'],
          ));

      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> resetPassword(Map<String, dynamic> params) async {
    EasyLoading.show();
    print("type ${params.runtimeType}");
    await apiRepository.resetPassword(params).getResponse((reponse) {
      EasyLoading.dismiss();

      flutterToast("${reponse.data['message']}");
    });
  }
}

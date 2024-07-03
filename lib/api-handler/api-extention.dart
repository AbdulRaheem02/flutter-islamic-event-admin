// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:islamic_event_admin/custom_widgets/InternalStorage.dart';
import 'api_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as GET;

extension ApiExtension on Future<Response<dynamic>> {
  Future execute<T>(Function(Map<String, dynamic>) model) async {
    try {
      final res = await this;
      return ApiResponse.fromResponse(
        res,
      );
    } on DioException catch (error) {
      _handleError(error);
    }
  }

  void _handleError(DioException error) {
    dynamic errorResponse = error.response?.data;
    dynamic statusCode = error.response?.statusCode;

    // A helper to show error toast
    void showErrorToast(dynamic error) {
      if (error.runtimeType == String) {
        Fluttertoast.showToast(msg: error.toString());
      }
    }

    EasyLoading.dismiss();
    // Error handling logic based on status code
    if (errorResponse.containsKey("errors")) {
      switch (statusCode.toString()) {
        case 'ERROR_AUTH01':
        case 'ERROR_AUTH02':
        case 'ERROR_AUTH03':
        case 'ERROR_OTP01':
        case '404':
        case '500':
        case '400':
        case '409':
        case '401':
        case '403':
          showErrorToast(errorResponse['errors'] ?? "Something went wrong");
          break;
        default:
          Fluttertoast.showToast(msg: errorResponse['message'].toString());
      }
    } else {
      switch (statusCode.toString()) {
        case 'ERROR_AUTH01':
        case 'ERROR_AUTH02':
        case 'ERROR_AUTH03':
        case 'ERROR_OTP01':
        case '404':
        case '500':
        case '400':
        case '409':
        case '401':
        case '403':
          Fluttertoast.showToast(
              msg: errorResponse['message'] ?? "Something went wrong");
          break;
        default:
          Fluttertoast.showToast(msg: "Something went wrong");
      }
    }

    BuildContext context = GET.Get.context!;
    context.loaderOverlay.hide();

    if (statusCode.toString() == '401' &&
        errorResponse['message'].toString() == "Unauthorized") {
      clearEveryThing();
      Fluttertoast.showToast(msg: "Session Expired");
      // GET.Get.offAllNamed(Routes.Splash);
    }
  }
}

extension ControllerResponseExtension on Future<dynamic> {
  Future getResponse<T>(Function(dynamic) responseData) async {
    var response = await this as ApiResponse;
    responseData(response);
  }
}

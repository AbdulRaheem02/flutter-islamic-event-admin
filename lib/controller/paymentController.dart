import 'dart:async';

import 'package:islamic_event_admin/api-handler/api-extention.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/theme/custom_text_style.dart';
import 'package:islamic_event_admin/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../api-handler/api-repo.dart';
import '../screen/home_page_screen.dart';
import '../screen/webviewpayment/webViewPayment.dart';

class PaymentController extends GetxController {
  ApiRepository apiRepository;
  PaymentController(this.apiRepository);

  Future<void> createCustomer(Map<String, dynamic> params, double amount,
      String type, String packageid) async {
    EasyLoading.show();
    await apiRepository.createuser(params).getResponse((reponse) {
      Get.log("response${reponse.statusCode}");

      if (reponse.statusCode == 200) {
        if (reponse.data['success'].toString() == "true") {
          String cusId = reponse.data['data']['id'];
          payment({"amount": amount, "customer_id": cusId}, type, packageid);
          Get.log(cusId);
        }
      }
    });
  }

  Future<void> payment(
      Map<String, dynamic> params, String type, String packageId) async {
    EasyLoading.show();
    await apiRepository.payment(params).getResponse((reponse) {
      Get.log("response$reponse");

      if (reponse.statusCode == 200) {
        Get.back();
        String url = reponse.data['session']['url'];
        Get.log(url);
        EasyLoading.dismiss();
        Get.to(() => WebViewPayment(
              paymentUrl: url,
              paackageId: packageId,
              type: type,
            ));
      }
    });
  }

  Future<void> usergoing(Map<String, dynamic> params) async {
    EasyLoading.show();
    await apiRepository.going(params).getResponse((reponse) {
      Get.log("response$reponse");
      EasyLoading.dismiss();
      if (reponse.statusCode == 200) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(15),
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.success,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Payment Paid Successfully',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your payment is verified and your request is successfully submitted to the admin.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: () {
                        Get.offAll(() => const HomePage());
                      },
                      text: "Submit",
                      width: 200.v,
                      buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }
}

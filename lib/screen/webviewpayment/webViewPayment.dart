import 'dart:async';

import 'package:islamic_event_admin/controller/paymentController.dart';
import 'package:islamic_event_admin/widgets/app_bar/appbar_leading_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class WebViewPayment extends StatefulWidget {
  String paymentUrl, paackageId, type;
  bool? forretailpayment;
  WebViewPayment(
      {required this.paackageId,
      required this.paymentUrl,
      required this.type,
      this.forretailpayment = false,
      super.key});

  @override
  State<WebViewPayment> createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  InAppWebViewController? webViewController;
  bool isLoading = true;
  bool isSuccess = false;

  Future<bool> _onWillPop() async {
    if (webViewController != null) {
      bool canGoBack = await webViewController!.canGoBack();
      if (canGoBack) {
        await webViewController!.goBack();
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  String? finalUrl; // URL extracted from JSON

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url:

                            //  WebUri(widget.paymentUrl.toString())
                            Uri.parse(widget.paymentUrl.toString())),
                    initialOptions: InAppWebViewGroupOptions(
                        ios: IOSInAppWebViewOptions(),
                        crossPlatform: InAppWebViewOptions(
                          userAgent:
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                          javaScriptEnabled: true,
                          applicationNameForUserAgent: "Trade to Trade",
                          useShouldOverrideUrlLoading: true,
                          useOnLoadResource: true,
                          supportZoom: false,
                          cacheEnabled: true,
                        )),
                    // initialUrlRequest:    URLRequest(url: WebUri("https://flutter.dev/")),

                    onLoadStop:
                        (InAppWebViewController controller, Uri? url) async {
                      Get.log("Loading URL: ${url.toString()}");

                      setState(() {
                        isLoading = false;
                      });
                    },
                    onWebViewCreated: (InAppWebViewController controller) {
                      webViewController = controller;
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      Get.log("progress id $progress");

                      if (progress == 100) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    onLoadStart:
                        (InAppWebViewController controller, Uri? url) async {
                      Get.log("Loading URL: ${url.toString()}");
                      if (url.toString() == "https://example.com/success") {
                        setState(() {
                          Get.put(PaymentController(Get.find()));
                          isLoading = true;
                          isSuccess = true;
                          Get.find<PaymentController>().usergoing({
                            "type": "event",
                            "id": widget.paackageId,
                          });
                        });
                      }
                      if (url.toString() == "https://example.com/cancel") {
                        Get.back();
                      }
                    },
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.white.withOpacity(.9),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (isSuccess)
              Container(
                height: double.infinity,
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            //  if (isSuccess)
            // Container(
            //   color: Colors.white.withOpacity(.9),

            // ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> paymentsuccess() {
    return showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(scaffoldBackgroundColor: Colors.white),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                content: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust width as needed
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 5.h),
                        // CustomImageView(
                        //   imagePath: ImageConstant.,
                        //   height: 60.h,
                        //   alignment: Alignment.center,
                        // ),
                        SizedBox(height: 15.h),

                        Text(
                          "Payment Success",
                          style: theme.textTheme.titleLarge!.copyWith(
                              color: appTheme.gray500,
                              fontSize: 15.h,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Your money has been successfully sent",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: appTheme.gray600,
                            fontWeight: FontWeight.normal,
                            fontSize: 11.h,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Text(
                        //   "Amount",
                        //   textAlign: TextAlign.center,
                        //   style: theme.textTheme.titleLarge!.copyWith(
                        //     color: appTheme.gray600,
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 11.h,
                        //   ),
                        // ),
                        // SizedBox(height: 3.h),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Icon(
                        //       Icons.currency_pound,
                        //       color: appTheme.yellow900,
                        //       size: 20.h,
                        //     ),
                        //     Text(
                        //       "1200",
                        //       textAlign: TextAlign.center,
                        //       style: theme.textTheme.titleLarge!.copyWith(
                        //           color: appTheme.yellow900, fontSize: 18.h),
                        //     )
                        //   ],
                        // ),

                        Text(
                          "-----------------------------------------------------------",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: appTheme.gray600,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.h,
                          ),
                        ),
                        SizedBox(height: 22.h),
                        SizedBox(
                          height: 40.v,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme
                                  .primary, // Change this color to your desired background color
                            ),
                            onPressed: () async {
                              Get.back();
                              Get.back();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Ok",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.back,
        onTap: () {
          Get.back();
        },
        margin: EdgeInsets.only(
          left: 21.h,
          top: 14.v,
          bottom: 14.v,
        ),
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "Payment",
      ),
    );
  }
}

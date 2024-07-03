import 'dart:async';

import 'package:islamic_event_admin/core/app_export.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../../controller/authController.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  String email;
  OtpVerificationScreen({required this.email, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final AuthController _authController = Get.find<AuthController>();
  TextEditingController Controller = TextEditingController();

  late Timer _timer;
  int _seconds = 90;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_seconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 24.v, horizontal: 20.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verification",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 5.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We’ve send you the verification \ncode on ${widget.email}",
                  style: theme.textTheme.bodySmall!
                      .copyWith(color: appTheme.black900),
                ),
              ),
              SizedBox(height: height * 0.028),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 2.h),
                  child: Text(
                    "OTP Code",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              PinCodeTextField(
                appContext: context,
                controller: Controller,
                length: 6,
                keyboardType: TextInputType.number,
                textStyle: theme.textTheme.bodySmall,
                hintStyle: theme.textTheme.bodySmall,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],

                // showCursor: false,
                pinTheme: PinTheme(
                  fieldHeight: 40.h,
                  fieldWidth: 40.h,
                  borderRadius: BorderRadius.circular(10),
                  shape: PinCodeFieldShape.box,
                  inactiveColor: theme.colorScheme.primary,
                  activeColor: theme.colorScheme.primary,
                  selectedColor: Colors.transparent,
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: height * 0.02),
              CustomElevatedButton(
                onPressed: () {
                  _authController.verifyForgotPasswordOtp({
                    "email": widget.email,
                    "forgotPasswordOtp": Controller.text,
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => CreateNewPasswordScreen()),
                  // );
                },
                text: "CONTINUE",
                buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
              ),
              SizedBox(height: height * 0.03),
              _buildResendCodeSection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildResendCodeSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Resend code in",
            style: theme.textTheme.bodySmall,
          ),
          _seconds == 0
              ? InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _authController.resendOtp({
                      "email": widget.email,
                    });
                  },
                  child: Text(
                    "Resend otp",
                    style: CustomTextStyles.bodySmallPrimary,
                  ),
                )
              : Text(
                  "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}",
                  style: CustomTextStyles.bodySmallPrimary,
                ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomImageView(
          onTap: () {
            Navigator.pop(context);
          },
          imagePath: ImageConstant.back,
          height: 10.h,
          width: 10.h,
        ),
      ),
      centerTitle: true,
    );
  }
}

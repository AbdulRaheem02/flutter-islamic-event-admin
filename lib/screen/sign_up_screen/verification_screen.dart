import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class VerificationScreen extends StatelessWidget {
  String email;
  VerificationScreen({required this.email, super.key});

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 24.v),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.v),
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Reset Password",
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        // SizedBox(height: 5.v),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "We’ve send you the verification \ncode on +1 2620 0323 7631",
                        //     style: theme.textTheme.bodySmall!
                        //         .copyWith(color: appTheme.black900),
                        //   ),
                        // ),
                        SizedBox(height: 13.v),
                        _buildPasswordSection(context),
                        SizedBox(height: 15.v),
                        _buildConfirmPasswordSection(context),
                        SizedBox(height: 30.v),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _authController.resetPassword({
                                "email": email,
                                "password": passwordController.text,
                                "confirmPassword":
                                    confirmpasswordController.text,
                              });
                            }
                          },
                          text: "CONTINUE",
                          width: 200.v,
                          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                        ),
                        SizedBox(height: 20.v),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Re-send code in ",
                                style: theme.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: "0:20",
                                style: CustomTextStyles.bodySmallPrimary,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle sign up tap here
                                    Navigator.pop(context);
                                  },
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 21.v),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  /// Section Widget
  Widget _buildPasswordSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: passwordController,
            hintText: "Enter your password",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputType: TextInputType.visiblePassword,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(30.h, 13.v, 12.h, 12.v),
              child: CustomImageView(
                imagePath: ImageConstant.eye,
                height: 15.v,
                width: 19.h,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            prefix: Container(
              margin: EdgeInsets.fromLTRB(0.h, 10.v, 0.h, 10.v),
              child: CustomImageView(
                imagePath: ImageConstant.lock,
                height: 15.v,
                width: 19.h,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 40.v,
            ),
            obscureText: true,
            contentPadding: EdgeInsets.only(
              left: 14.h,
              top: 13.v,
              bottom: 13.v,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmPasswordSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: confirmpasswordController,
            hintText: "Enter confirm password",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(30.h, 13.v, 12.h, 12.v),
              child: CustomImageView(
                imagePath: ImageConstant.eye,
                height: 15.v,
                width: 19.h,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your confirm password';
              }
              return null;
            },
            prefix: Container(
              margin: EdgeInsets.fromLTRB(0.h, 10.v, 0.h, 10.v),
              child: CustomImageView(
                imagePath: ImageConstant.lock,
                height: 15.v,
                width: 19.h,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 40.v,
            ),
            obscureText: true,
            contentPadding: EdgeInsets.only(
              left: 14.h,
              top: 13.v,
              bottom: 13.v,
            ),
          )
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

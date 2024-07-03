import 'package:islamic_event_admin/controller/authController.dart';
import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:islamic_event_admin/screen/sign_up_screen/verification_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();

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
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: Text(
                              "Sign Up",
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(height: 13.v),
                        _buildUsernameSection(context),
                        SizedBox(height: 15.v),
                        _buildEmailSection(context),
                        SizedBox(height: 15.v),
                        _buildPasswordSection(context),
                        SizedBox(height: 15.v),
                        _buildConfirmPasswordSection(context),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () {
                            // Get.to(() => VerificationScreen());
                            if (_formKey.currentState!.validate()) {
                              _authController.register({
                                "fullname": userNameController.text,
                                "email": emailController.text,
                                "password": passwordController.text,
                                "confirmPassword":
                                    confirmpasswordController.text
                              });
                            }
                          },
                          text: "SIGN UP",
                          width: 200.v,
                          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                        ),
                        SizedBox(height: 100.v),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already ",
                                style: theme.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: "have an account? ",
                                style: theme.textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: "Sign In",
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
  Widget _buildUsernameSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            prefix: Container(
              margin: EdgeInsets.fromLTRB(0.h, 10.v, 0.h, 10.v),
              child: CustomImageView(
                imagePath: ImageConstant.email,
                height: 15.v,
                width: 19.h,
              ),
            ),
            controller: userNameController,
            hintText: "Full name",
            hintStyle: CustomTextStyles.bodySmall10,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmailSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            prefix: Container(
              margin: EdgeInsets.fromLTRB(0.h, 10.v, 0.h, 10.v),
              child: CustomImageView(
                imagePath: ImageConstant.message,
                height: 15.v,
                width: 19.h,
              ),
            ),
            controller: emailController,
            hintText: "abc@email.com",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

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

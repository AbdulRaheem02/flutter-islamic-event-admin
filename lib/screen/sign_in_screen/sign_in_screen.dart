import 'package:islamic_event_admin/controller/authController.dart';
import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:islamic_event_admin/screen/sign_in_screen/reset_password_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../home_page/home_page.dart';
import '../home_page_screen.dart';
import '../sign_up_screen/sign_up_screen.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 20.v),
          child: Column(
            children: [
              SizedBox(height: 55.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.v),
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: Column(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.logo,
                          // height: 72.v,
                          width: 102.h,
                        ),
                        // SizedBox(height: 4.h),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: Text(
                              "Prophetic \nPath Danmark",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  color: appTheme.black900,
                                  fontSize: 30.fSize,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.v),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: Text(
                              "Sign in",
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.v),
                        _buildEmailSection(context),
                        SizedBox(height: 15.v),
                        _buildPasswordSection(context),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.7, // Adjust the scale as needed
                                  child: Switch(
                                    value: isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitched = value;
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  "Remember Me",
                                  style: theme.textTheme.bodySmall!
                                      .copyWith(color: appTheme.black900),
                                ),
                              ],
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.to(() => ResetPasswordScreen());
                            //   },
                            //   child: Text(
                            //     "Forgot Password?",
                            //     style: theme.textTheme.bodySmall!
                            //         .copyWith(color: appTheme.black900),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _authController.login({
                                "email": emailController.text,
                                "password": passwordController.text,
                              });
                            }
                          },
                          width: 200.v,
                          text: "SIGN IN",
                          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                        ),
                        // SizedBox(height: 100.v),
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text: "Don’t ",
                        //         style: theme.textTheme.bodySmall!
                        //             .copyWith(color: appTheme.black900),
                        //       ),
                        //       TextSpan(
                        //         text: "have an account? ",
                        //         style: theme.textTheme.bodySmall!
                        //             .copyWith(color: appTheme.black900),
                        //       ),
                        //       TextSpan(
                        //         text: "Sign Up",
                        //         style: CustomTextStyles.bodySmallPrimary,
                        //         recognizer: TapGestureRecognizer()
                        //           ..onTap = () {
                        //             // Handle sign up tap here
                        //             Navigator.of(context).push(
                        //               MaterialPageRoute(
                        //                   builder: (context) => SignUpScreen()),
                        //             );
                        //           },
                        //       )
                        //     ],
                        //   ),
                        //   textAlign: TextAlign.left,
                        // ),

                        // SizedBox(height: 21.v),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
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
            hintText: "Your password",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputType: TextInputType.visiblePassword,
            suffix: Container(
              margin: EdgeInsets.fromLTRB(30.h, 0.v, 12.h, 0.v),
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
}
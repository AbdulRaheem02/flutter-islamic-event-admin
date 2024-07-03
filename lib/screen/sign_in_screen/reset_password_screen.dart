import 'package:islamic_event_admin/core/utils/size_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
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
class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  TextEditingController emailController = TextEditingController();
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
                        SizedBox(height: 5.v),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Please enter your email address \nto request a password reset",
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: appTheme.black900),
                          ),
                        ),
                        SizedBox(height: 13.v),
                        _buildEmailSection(context),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _authController.forgetpassword({
                                "email": emailController.text,
                              });
                            }
                          },
                          text: "SEND",
                          width: 200.v,
                          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
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

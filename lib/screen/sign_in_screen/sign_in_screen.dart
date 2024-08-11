import 'package:islamic_event_admin/controller/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_event_admin/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

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
  bool absure = true;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      isSwitched = prefs.getBool('remember_me') ?? false;
    });
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isSwitched) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
    await prefs.setBool('remember_me', isSwitched);
  }

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
                          width: 102.h,
                        ),
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
                                  scale: 0.7,
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
                          ],
                        ),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () async {
                            NotificationServices notificationServices =
                                NotificationServices();

                            String token =
                                await notificationServices.getDeviceToken();

                            if (_formKey.currentState!.validate()) {
                              _saveCredentials();
                              _authController.login({
                                "email": emailController.text,
                                "password": passwordController.text,
                                // "role": "Admin",
                                "deviceToken": token
                              });
                            }
                          },
                          width: 200.v,
                          text: "SIGN IN",
                          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                        ),
                        SizedBox(height: 100.v),
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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    absure = !absure;
                  });
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.h, 10.v, 0.h, 10.v),
                  child: Icon(absure ? Icons.visibility : Icons.visibility_off),
                ),
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
            obscureText: absure,
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

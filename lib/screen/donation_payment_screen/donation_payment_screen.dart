import 'dart:ui';

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
import '../../widgets/custom_text_form_field.dart';
import '../payment_screen/event_payment_screen.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class DonationPaymentScreen extends StatelessWidget {
  DonationPaymentScreen({super.key});

  TextEditingController AddPhoneController = TextEditingController();

  TextEditingController amountController = TextEditingController();

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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.2), // Shadow color
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                            ),
                            ClipOval(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .white, // Adjust the opacity to control the darkness of the overlay
                                ),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: CustomImageView(
                                        imagePath: ImageConstant.payment,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13.v),
                        _buildPhoneSection(context),
                        SizedBox(height: 15.v),
                        _buildAmountSection(context),
                        SizedBox(height: 15.v),
                        Row(
                          children: [
                            SizedBox(
                              width: 280.v,
                              child: Text(
                                "Please add your number and enter your amount to donate.",
                                style: TextStyle(
                                  letterSpacing: 0.5.h,
                                  fontSize: 12.v,
                                  fontFamily: "Poppins",
                                  color: appTheme.blackText,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.v, vertical: 60.h),
        child: CustomElevatedButton(
          onPressed: () {
            // Get.to(() => EventPaymentScreen());
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomDialog();
              },
            );
          },
          text: "Submit",
          width: 200.v,
          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
        ),
      ),
    );
  }

  Widget _buildPhoneSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Phone Number",
            style: TextStyle(
              fontSize: 16.v,
              fontFamily: "Poppins",
              color: appTheme.gray500,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          CustomTextFormField(
            controller: AddPhoneController,
            hintText: "Add Number",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Trip Payment",
            style: TextStyle(
              fontSize: 16.v,
              fontFamily: "Poppins",
              color: appTheme.blackText,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          CustomTextFormField(
            controller: amountController,
            hintText: "Amount",
            hintStyle: TextStyle(
              fontSize: 30.v,
              fontFamily: "Poppins",
              color: appTheme.gray600,
              fontWeight: FontWeight.w600,
            ),
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.number,
            fillColor: const Color(0XFFF2F5FF),
            filled: true,
            textStyle: TextStyle(
              fontSize: 30.v,
              fontFamily: "Poppins",
              color: appTheme.gray600,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: EdgeInsets.only(
              left: 14.h,
              top: 15.v,
              bottom: 0.v,
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
      title: AppbarTitle(
        text: "Donation",
      ),
    );
  }
}

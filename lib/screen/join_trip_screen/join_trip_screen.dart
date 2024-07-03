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
import '../payment_screen/trip_payment_screen.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class JoinTripScreen extends StatelessWidget {
  JoinTripScreen({super.key});

  TextEditingController userNameController = TextEditingController();

  TextEditingController AddPhoneController = TextEditingController();

  TextEditingController noOfPersonController = TextEditingController();

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
                        Text(
                          "Lorem ipsum dolor sit amet consectetur. Iaculis diam nec arcu ultricies. ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.v,
                            color: appTheme.gray500,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: Text(
                              "Add Details",
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(height: 13.v),
                        _buildUsernameSection(context),
                        SizedBox(height: 15.v),
                        _buildPhoneSection(context),
                        SizedBox(height: 15.v),
                        _buildNoPersonSection(context),
                        SizedBox(height: 15.v),
                        _buildAmountSection(context),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () {
                            Get.to(() => TripPaymentScreen());
                          },
                          text: "Next",
                          width: 200.v,
                          buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                        ),
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
          Text(
            "Name",
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
            controller: userNameController,
            hintText: "Add Name",
            hintStyle: CustomTextStyles.bodySmall10,
          )
        ],
      ),
    );
  }

  /// Section Widget
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

  /// Section Widget
  Widget _buildNoPersonSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No of Persons",
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
            controller: noOfPersonController,
            hintText: "Add No of Persons",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            contentPadding: EdgeInsets.only(
              left: 14.h,
              top: 15.v,
              bottom: 15.v,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildAmountSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount",
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
            controller: amountController,
            hintText: "Amount",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            contentPadding: EdgeInsets.only(
              left: 14.h,
              top: 15.v,
              bottom: 15.v,
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
        text: "Join Trip",
      ),
    );
  }
}

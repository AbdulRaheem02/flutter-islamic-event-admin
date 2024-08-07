import 'dart:ui';
import 'package:dio/dio.dart' as Deo;
import 'package:get/get.dart';
import 'package:islamic_event_admin/controller/initialStatuaController.dart';

import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/custom_widgets/toast.dart';
import 'package:islamic_event_admin/theme/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:islamic_event_admin/widgets/app_bar/appbar_leading_image.dart';
import 'package:islamic_event_admin/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import '../home_page/home_page.dart';

class AddMentor extends StatefulWidget {
  const AddMentor({super.key});

  @override
  State<AddMentor> createState() => _AddMentorState();
}

class _AddMentorState extends State<AddMentor> {
  TextEditingController userNameController = TextEditingController();
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  TextEditingController emailController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<bool> _selections = [false, false, false, false];
  TextEditingController phoneController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
                        // const MentorTile(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: Text(
                              "Enter Detail",
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.v),
                        _image == null
                            ? const Text('No image selected.')
                            : Image.file(
                                _image!,
                                height: 100.h,
                                width: 200,
                              ),
                        SizedBox(height: 5.h),
                        TextButton(
                            onPressed: () {
                              _pickImage();
                            },
                            child: const Text("Select Profile Picture")),
                        SizedBox(height: 5.v),
                        _buildUsernameSection(context),
                        SizedBox(height: 15.v),
                        _buildEmailSection(context),
                        SizedBox(height: 15.v),
                        CustomTextFormField(
                            controller: phoneController,
                            hintText: "Phone Number",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            hintStyle: CustomTextStyles.bodySmall10,
                            textInputType: TextInputType.number),
                        SizedBox(height: 15.v),
                        _buildDescriptionSection(context),
                        CheckboxListTile(
                          title: const Text('Sunnah Healing'),
                          value: _selections[0],
                          onChanged: (bool? value) {
                            setState(() {
                              _selections[0] = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Appointment'),
                          value: _selections[1],
                          onChanged: (bool? value) {
                            setState(() {
                              _selections[1] = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Nikkah'),
                          value: _selections[2],
                          onChanged: (bool? value) {
                            setState(() {
                              _selections[2] = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Speech'),
                          value: _selections[3],
                          onChanged: (bool? value) {
                            setState(() {
                              _selections[3] = value ?? false;
                            });
                          },
                        ),
                        SizedBox(height: 30.v),
                        CustomElevatedButton(
                          onPressed: () async {
                            if (_image != null) {
                              var fileName = _image!.path.split('/').last;
                              var file = await Deo.MultipartFile.fromFile(
                                _image!.path,
                                filename: fileName,
                              );
                              List<String> select = [];
                              if (_selections[0] == true) {
                                select.addAll(["Sunnah Healing"]);
                              }
                              print(select);
                              if (_selections[1] == true) {
                                select.addAll(["Appointment"]);
                              }
                              print(select);

                              if (_selections[2] == true) {
                                select.addAll(["Nikkah"]);
                              }
                              print(select);

                              if (_selections[3] == true) {
                                select.addAll(["Speech"]);
                              }
                              print(select);

                              if (_formKey.currentState!.validate()) {
                                print(select);

                                _initialStatusController.addMentor({
                                  "fullname": userNameController.text,
                                  "email": emailController.text,
                                  "phone": phoneController.text,
                                  "about": descriptionController.text,
                                  "offers": select,
                                  "image": file
                                });
                              }
                            } else {
                              flutterToast("Please Upload Pdf");
                            }
                          },
                          text: "Add Mentor",
                          width: 200.v,
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

      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       const SizedBox(
      //         height: 5,
      //       ),
      //       ListView.builder(
      //         shrinkWrap: true,
      //         physics: const NeverScrollableScrollPhysics(),
      //         itemCount: 3,
      //         itemBuilder: (context, index) {
      //           return const MentorTile();
      //         },
      //       ),
      //       // ClipRect(
      //       //   child: BackdropFilter(
      //       //     // filter: ImageFilter.blur(sigmaX: -3.0, sigmaY: 1.0),
      //       //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      //       //     child: Container(
      //       //       height: 100.0, // Adjust the height as needed
      //       //       color: Colors.black.withOpacity(
      //       //           0.2), // Adjust the opacity and color as needed
      //       //     ),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter full name';
              }
              return null;
            },
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
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
  Widget _buildDescriptionSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            maxLines: 7,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              return null;
            },
            controller: descriptionController,
            hintText: "Enter About",
            hintStyle: CustomTextStyles.bodySmall10,
            textInputType: TextInputType.emailAddress,
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      centerTitle: true,
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
      title: AppbarTitle(
        text: "Mentor",
      ),
      styleType: Style.bgFill,
    );
  }
}

class MentorTile extends StatefulWidget {
  const MentorTile({
    super.key,
  });

  @override
  _MentorTileState createState() => _MentorTileState();
}

class _MentorTileState extends State<MentorTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.h,
            // vertical: 11.v,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.only(right: 5.v),
                  initiallyExpanded: _isExpanded,
                  trailing: Container(
                    // color: Colors.amberAccent,
                    child: Icon(
                      _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: appTheme.gray500,
                      size: 30.h,
                    ),
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _isExpanded = expanded;
                    });
                  },
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 5.v,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.profile,
                                height: 70.h,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 5.v,
                              ),
                              SizedBox(
                                // color: Colors.amber,
                                width: 210.v,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mazbi Scholars",
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              color: appTheme.gray400,
                                              fontSize: 12.h,
                                              fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Molana Arif Shabeer Mushai Qadri",
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              color: appTheme.blackheading,
                                              fontSize: 14.h,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    if (_isExpanded)
                                      SizedBox(
                                        // color: Colors.amber,
                                        width: 300.v,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 100.v,
                                                  // height: 28.h,
                                                  padding: EdgeInsets.all(4.v),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.v),
                                                      color: theme
                                                          .colorScheme.primary),
                                                  child: Center(
                                                    child: Text(
                                                      "Send Message",
                                                      style: TextStyle(
                                                        fontSize: 10.v,
                                                        color: appTheme.white,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    Divider(
                      thickness: 1,
                      height: 2.v,
                      color: appTheme.lightbackground,
                    ),
                    SizedBox(
                      height: 5.v,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        featurewidget(
                          title: 'Sunnah Healing',
                        ),
                        featurewidget(
                          title: 'Appointment',
                        ),
                        featurewidget(
                          width: 55.v,
                          title: 'Nikkah',
                        ),
                        featurewidget(
                          width: 55.v,
                          title: 'Speech',
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.v, vertical: 5.v),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Mentor",
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: appTheme.blackheading,
                                fontSize: 14.h,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            """Lorem ipsum dolor sit amet consectetur. Blandit morbi nunc eleifend leo quam nulla dapibus tincidunt egestas. Iaculis pulvinar etiam dignissim sit aenean pretium feugiat. Semper non sagittis erat neque. Tincidunt blandit cum mi imperdiet neque tristique risus. Nunc lorem vitae pharetra in lorem et vitae.
          Id sit tortor posuere ut augue. Et diam quis aliquet vestibulum nullam faucibus ipsum tincidunt.""",
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: appTheme.gray400,
                                fontSize: 12.h,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class featurewidget extends StatelessWidget {
  String title;
  double? height;

  double? width;
  BoxDecoration? decoration;
  featurewidget({
    required this.title,
    this.decoration,
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 20.v,
      width: width ?? 95.v,
      decoration: decoration ??
          BoxDecoration(
              borderRadius: BorderRadius.circular(15.v),
              color: theme.colorScheme.primary.withOpacity(0.4)),
      child: Center(
        child: Text(
          title,
          style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.primary,
              fontSize: 10.h,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

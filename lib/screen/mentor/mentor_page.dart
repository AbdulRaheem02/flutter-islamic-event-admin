import 'dart:ui';

import 'package:islamic_event_admin/controller/initialStatuaController.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/model/MemberModel.dart';
import 'package:islamic_event_admin/screen/home_page/project_page.dart';
import 'package:islamic_event_admin/theme/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../api-handler/env_constants.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/circleimage.dart';
import '../home_page/home_page.dart';

class MentorListPage extends StatefulWidget {
  const MentorListPage({super.key});

  @override
  State<MentorListPage> createState() => _MentorListPageState();
}

class _MentorListPageState extends State<MentorListPage> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  @override
  void initState() {
    // TODO: implement initState
    _initialStatusController.allmemberlist.clear();
    _initialStatusController.getallmentor();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => _initialStatusController.membernf.value == true &&
                      _initialStatusController.allmemberlist.isEmpty
                  ? const Center(
                      child: Text("Not Available"),
                    )
                  : _initialStatusController.allmemberlist.isEmpty
                      ? buildShimmerEffectColumn(height: 100.h, length: 5)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              _initialStatusController.allmemberlist.length,
                          itemBuilder: (context, index) {
                            MemberModel memberdetail =
                                _initialStatusController.allmemberlist[index];
                            return MentorTile(
                              memberdetail: memberdetail,
                            );
                          },
                        ),
            )
            // ClipRect(
            //   child: BackdropFilter(
            //     // filter: ImageFilter.blur(sigmaX: -3.0, sigmaY: 1.0),
            //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            //     child: Container(
            //       height: 100.0, // Adjust the height as needed
            //       color: Colors.black.withOpacity(
            //           0.2), // Adjust the opacity and color as needed
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      centerTitle: true,
      title: AppbarTitle(
        text: "Members",
      ),
      styleType: Style.bgFill,
    );
  }
}

class MentorTile extends StatefulWidget {
  MemberModel memberdetail;
  MentorTile({
    required this.memberdetail,
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
                              // CustomImageView(
                              //   imagePath:
                              //       "${EnvironmentConstants.baseUrlforimage}${widget.memberdetail.image}",
                              //   // ImageConstant.profile,
                              //   height: 70.h,
                              //   width: 70.v,

                              //   fit: BoxFit.fill,
                              // ),

                              CircleAvatar(
                                child: Circleimage(
                                  onTap: () {
                                    Get.log("omnta");
                                  },
                                  imagePath:
                                      "${EnvironmentConstants.baseUrlforimage}${widget.memberdetail.image}",
                                  height: 70.adaptSize,
                                  width: 70.adaptSize,
                                  margin: EdgeInsets.only(
                                    top: 2.v,
                                    bottom: 2.v,
                                  ),
                                ),
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
                                      widget.memberdetail.fullname,
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
                                                GestureDetector(
                                                  onTap: () async {
                                                    final Email email = Email(
                                                      body:
                                                          'Download Islamic Event',
                                                      subject: 'Download',
                                                      recipients: [
                                                        widget
                                                            .memberdetail.email
                                                      ],
                                                      cc: ['cc@example.com'],
                                                      bcc: ['bcc@example.com'],
                                                      // attachmentPaths: ['/path/to/attachment.zip'],
                                                      // isHTML: false,
                                                    );

                                                    try {
                                                      await FlutterEmailSender
                                                          .send(email);
                                                    } catch (error) {
                                                      print(error);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 100.v,
                                                    // height: 28.h,
                                                    padding:
                                                        EdgeInsets.all(4.v),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.v),
                                                        color: theme.colorScheme
                                                            .primary),
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
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    final Uri launchUri = Uri(
                                                      scheme: 'tel',
                                                      path: widget
                                                          .memberdetail.phone,
                                                    );
                                                    await launchUrl(launchUri);
                                                  },
                                                  child: appbarItemicon(
                                                    height: 25.v,
                                                    width: 25.v,
                                                    icon: ImageConstant.call,
                                                  ),
                                                ),
                                                SizedBox(width: 4.v),
                                                InkWell(
                                                  onTap: () {},
                                                  child: appbarItemicon(
                                                    height: 25.v,
                                                    width: 25.v,
                                                    icon: ImageConstant.share,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Mentor'),
                                                          content: const Text(
                                                              'Are you sure you want to delete?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                Get.back();
                                                                Get.find<
                                                                        InitialStatusController>()
                                                                    .deleteMentor(
                                                                        widget
                                                                            .memberdetail
                                                                            .id);
                                                              },
                                                              child: const Text(
                                                                  'Delete'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
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
                    SizedBox(
                      height: 20.v,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.memberdetail.offers.length,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: featurewidget(
                                title: widget.memberdetail.offers[index]
                                    .toString(),
                              ),
                            );
                          }),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     featurewidget(
                    //       title: 'Sunnah Healing',
                    //     ),
                    //     featurewidget(
                    //       title: 'Appointment',
                    //     ),
                    //     featurewidget(
                    //       width: 55.v,
                    //       title: 'Nikkah',
                    //     ),
                    //     featurewidget(
                    //       width: 55.v,
                    //       title: 'Speech',
                    //     ),
                    //   ],
                    // ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.v, vertical: 5.v),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "About Mentor",
                                textAlign: TextAlign.start,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    color: appTheme.blackheading,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Text(
                            widget.memberdetail.about,
                            textAlign: TextAlign.start,
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

import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:islamic_event_admin/controller/initialStatuaController.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/model/MemberModel.dart';
import 'package:islamic_event_admin/screen/home_page/project_page.dart';
import 'package:islamic_event_admin/theme/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
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
  final ScrollController _scrollController = ScrollController();

  // List<bool> _initialStatusController.isExpandedList = [];
  @override
  void initState() {
    super.initState();
    _initialStatusController.allmemberlist.clear();
    _initialStatusController.getallmentor();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        // print("You have reached the end of the list");

        if (_initialStatusController.isMoreDataAvailableMentor.value &&
            !_initialStatusController.isLoadingMentor.value) {
          EasyLoading.show();
          _initialStatusController.getallmentor(
              page: _initialStatusController.currentPageMenotr.value + 1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => _initialStatusController.membernf.value == true &&
                      _initialStatusController.allmemberlist.isEmpty
                  ? SizedBox(
                      height: 500.h,
                      child: const Center(
                        child: Text("Not Available"),
                      ),
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
                            return _initialStatusController
                                    .isExpandedList.isNotEmpty
                                ? MentorTile(
                                    memberdetail: memberdetail,
                                    isExpanded: _initialStatusController
                                        .isExpandedList[index],
                                    onExpansionChanged: (bool expanded) {
                                      setState(() {
                                        _initialStatusController
                                                .isExpandedList.value =
                                            List.filled(
                                                _initialStatusController
                                                    .isExpandedList.length,
                                                false);
                                        _initialStatusController
                                            .isExpandedList[index] = expanded;
                                      });
                                    },
                                  )
                                : Container();
                          },
                        ),
            )
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
  final MemberModel memberdetail;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const MentorTile({
    required this.memberdetail,
    required this.isExpanded,
    required this.onExpansionChanged,
    super.key,
  });
  @override
  _MentorTileState createState() => _MentorTileState();
}

class _MentorTileState extends State<MentorTile> {
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
                    side: BorderSide(
                      color: widget.isExpanded
                          ? theme.colorScheme.primary.withOpacity(0.6)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.only(right: 5.v),
                  initiallyExpanded: widget.isExpanded,
                  trailing: Container(
                    // color: Colors.amberAccent,
                    child: Icon(
                      widget.isExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: appTheme.gray500,
                      size: 30.h,
                    ),
                  ),
                  onExpansionChanged: widget.onExpansionChanged,
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
                                  height: 90.adaptSize,
                                  width: 90.adaptSize,
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
                                              fontSize: 15.h,
                                              fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      widget.memberdetail.fullname,
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              color: appTheme.blackheading,
                                              fontSize: 17.h,
                                              fontWeight: FontWeight.w700),
                                    ),
                                    if (widget.isExpanded)
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
                                                    // final Email email = Email(
                                                    //   body:
                                                    //       'Download Islamic Event',
                                                    //   subject: 'Download',
                                                    //   recipients: [
                                                    //     widget
                                                    //         .memberdetail.email
                                                    //   ],
                                                    //   // cc: ['cc@example.com'],
                                                    //   // bcc: ['bcc@example.com'],
                                                    // );

                                                    // try {
                                                    //   await FlutterEmailSender
                                                    //       .send(email);
                                                    // } catch (error) {
                                                    //   print(error);
                                                    // }
                                                    Get.find<
                                                            InitialStatusController>()
                                                        .sendSms(
                                                            widget.memberdetail
                                                                .phone,
                                                            "");
                                                  },
                                                  child: Container(
                                                    // width: 100.v,
                                                    // height: 28.h,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.v,
                                                            vertical: 4),
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
                                                    Get.find<
                                                            InitialStatusController>()
                                                        .whatsappLaunchURL(
                                                            widget.memberdetail
                                                                .phone);
                                                  },
                                                  child: appbarItemicon(
                                                    height: 25.v,
                                                    width: 25.v,
                                                    icon:
                                                        ImageConstant.whatsapp,
                                                  ),
                                                ),
                                                SizedBox(width: 4.v),
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
                                                  onTap: () {
                                                    Share.share(widget
                                                        .memberdetail.about);
                                                  },
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
                                                )
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
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Text(
                            widget.memberdetail.about,
                            textAlign: TextAlign.start,
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: appTheme.gray500,
                                fontSize: 14.h,
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
              fontSize: 13.h,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

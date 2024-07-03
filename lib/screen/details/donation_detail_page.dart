import 'dart:io';

import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/theme/theme_helper.dart';
import 'package:islamic_event_admin/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../controller/initialStatuaController.dart';
import '../../model/ProjectModel.dart';
import '../VideoPlayer/video_player_screen.dart';
import '../home_page/home_page.dart';
import 'package:path_provider/path_provider.dart';

class DonationDetailScreen extends StatefulWidget {
  ProjectModel project;
  DonationDetailScreen({required this.project, super.key});

  @override
  State<DonationDetailScreen> createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  String thumbnail = "";

  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  Future<void> generateThumbnail(String videourl) async {
    final directory = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videourl,
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 50,
    );
    thumbnail = thumbnailPath.toString();
    setState(() {});
  }

  @override
  void initState() {
    generateThumbnail(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 274.h,
          // color: Colors.amber,
          child: SizedBox(
            width: double.maxFinite,
            height: 244.h,
            // decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Stack(
              children: [
                // SizedBox(
                //   height: 244.h,
                //   child: CustomImageView(
                //     imagePath: ImageConstant.event,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                thumbnail != ""
                    ? GestureDetector(
                        onTap: () {
                          print("asdf");
                          Get.to(() => const VideoPlay(
                                link:
                                    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                              ));
                        },
                        child: Container(
                          height: 244.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            image: DecorationImage(
                              image:
                                  FileImage(File(thumbnail)), // Use FileImage
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                              child: Container(
                            decoration: BoxDecoration(
                                color: appTheme.white.withOpacity(0.5),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.play_arrow,
                              color: theme.colorScheme.primary,
                              size: 40.h,
                            ),
                          )),
                        ))
                    : const Center(child: CircularProgressIndicator()),
                GestureDetector(
                  onTap: () {
                    print("asdf");
                    Get.to(() => const VideoPlay(
                          link:
                              "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                        ));
                  },
                  child: Container(
                    height: 244.h,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black
                              .withOpacity(0.3), // Adjust opacity as needed
                        ],
                      ),
                    ), // Adjust opacity as needed
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: appTheme.white,
                      )),
                ),

                Positioned(
                    bottom: 0,
                    left: 40,
                    right: 40,
                    child: Container(
                      width: 295.v,
                      height: 60.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45.v),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 80.v,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        left: 0,
                                        child: CustomImageView(
                                          height: 34.h,
                                          imagePath: ImageConstant.profile,
                                        )),
                                    Positioned(
                                        left: 20,
                                        child: CustomImageView(
                                          height: 34.h,
                                          imagePath: ImageConstant.profile,
                                        )),
                                    Positioned(
                                        left: 40,
                                        child: CustomImageView(
                                          height: 34.h,
                                          imagePath: ImageConstant.profile,
                                        )),
                                  ],
                                ),
                              ),
                              Text(
                                '+20 Going',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30.v),
                          Container(
                            width: 65.v,
                            height: 28.h,
                            padding: EdgeInsets.all(6.v),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.v),
                                color: theme.colorScheme.primary),
                            child: Center(
                              child: Text(
                                "Invite",
                                style: TextStyle(
                                  fontSize: 12.v,
                                  color: appTheme.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          // width: 320.v,
          padding: EdgeInsets.symmetric(
            horizontal: 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 320.v,
                    child: Text(
                      widget.project.title,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 30.v,
                        color: appTheme.blackText,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              // EventDetailWidget(
              //   icon: ImageConstant.calendaricon,
              // title: _initialStatusController
              //       .formatDate(DateTime.parse(widget. project.startTime)),
              //   des:
              //       "${DateFormat('EEEE').format(DateTime.parse(eventdetail.startTime))}  ${DateFormat.jm().format(DateTime.parse(eventdetail.startTime))} - ${DateFormat.jm().format(DateTime.parse(eventdetail.endTime))}",

              // ),
              SizedBox(height: 15.h),
              EventDetailWidget(
                icon: ImageConstant.location,
                title: 'Gala Convention Center',
                des: '36 Guild Street London, UK ',
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Container(
                    height: 40.v,
                    width: 40.v,
                    padding: EdgeInsets.all(6.v),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.v),
                        color: theme.colorScheme.primary.withOpacity(0.2)),
                    child: CustomImageView(
                      imagePath: ImageConstant.profile,
                      // height: 30.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.v),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ashfak",
                        style: TextStyle(
                          fontSize: 16.v,
                          color: appTheme.blackText,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(height: 7.v),
                      Text(
                        "Organizer",
                        style: TextStyle(
                          fontSize: 12.v,
                          color: appTheme.gray500,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Text(
                "About Event",
                style: TextStyle(
                  fontSize: 16.v,
                  color: appTheme.blackText,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 330.v,
                child: Text(
                  "Lorem ipsum dolor sit amet consectetur. Dictum mauris.",
                  style: TextStyle(
                    fontSize: 14.v,
                    color: appTheme.black900.withOpacity(0.6),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class EventDetailWidget extends StatelessWidget {
  String icon;
  String title;
  String des;

  double? height;
  double? iconsize;

  double? width;
  BoxDecoration? decoration;
  EventDetailWidget({
    required this.icon,
    required this.title,
    required this.des,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40.v,
          width: 40.v,
          padding: EdgeInsets.all(6.v),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.v),
              color: theme.colorScheme.primary.withOpacity(0.2)),
          child: CustomImageView(
            imagePath: icon,
            height: 30.h,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 10.v),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.v,
                color: appTheme.blackText,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: 7.v),
            Text(
              des,
              style: TextStyle(
                fontSize: 12.v,
                color: appTheme.gray500,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

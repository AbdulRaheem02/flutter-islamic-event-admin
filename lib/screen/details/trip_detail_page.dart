import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/screen/VideoPlayer/video_player_screen.dart';
import 'package:islamic_event_admin/theme/theme_helper.dart';
import 'package:islamic_event_admin/widgets/app_bar/appbar_leading_image.dart';
import 'package:islamic_event_admin/widgets/app_bar/custom_app_bar.dart';
import 'package:islamic_event_admin/widgets/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

import '../../api-handler/env_constants.dart';
import '../../controller/initialStatuaController.dart';
import '../../model/EventModel.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/custom_elevated_button.dart';
import '../home_page/home_page.dart';

class TripDetailScreen extends StatefulWidget {
  EventModel tripdetail;
  TripDetailScreen({required this.tripdetail, super.key});

  @override
  State<TripDetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<TripDetailScreen> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  late List<dynamic> mediaItems;

  @override
  void initState() {
    super.initState();
    // Combine images and videos into a single list
    mediaItems = [...widget.tripdetail.images, ...widget.tripdetail.videos!];
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
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
      centerTitle: true,
      title: AppbarTitle(
        text: "Details",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 244.h,
                  // color: Colors.amber,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      // aspectRatio:   25 / 12,

                      // Other options...
                    ),
                    items: mediaItems.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          Get.log(imagePath);
                          // Determine if the current item is a video
                          bool isVideo = imagePath.endsWith(".mp4") ||
                              imagePath.endsWith(".mkv") ||
                              imagePath.endsWith(".webm") ||
                              imagePath.endsWith(".MOV");
                          Get.log("is video $isVideo");
                          if (isVideo) {
                            _initialStatusController
                                .generateThumbnail(
                                    "${EnvironmentConstants.baseUrlforimage}$imagePath")
                                .then((value) {});
                            Get.log(
                                "thumbnial ${_initialStatusController.thumbnail}");

                            return Obx(() => GestureDetector(
                                onTap: () {
                                  Get.log("tap");
                                  Get.to(() => VideoPlay(
                                        link:
                                            "${EnvironmentConstants.baseUrlforimage}$imagePath",
                                      ));
                                },
                                child: Container(
                                  height: 200.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: appTheme.blueGray400,
                                    image: DecorationImage(
                                      image: FileImage(File(
                                          _initialStatusController.thumbnail
                                              .value)), // Use FileImage
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.play_arrow,
                                    color: theme.colorScheme.primary,
                                    size: 40.h,
                                  )),
                                )));
                          } else {
                            // If it's not a video, display the image as before
                            return CustomImageView(
                              onTap: () {
                                Get.log(
                                    "${EnvironmentConstants.baseUrlforimage}$imagePath");
                                // Get.to(() => ImageViewer(
                                //     imageUrl:
                                //         "${EnvironmentConstants.baseUrlforimage}${imagePath}"));
                              },
                              imagePath:
                                  "${EnvironmentConstants.baseUrlforimage}$imagePath",
                              height: 182.v,
                              fit: BoxFit.cover,
                              width: 319.h,
                              radius: BorderRadius.circular(5.h),
                            );
                          }
                        },
                      );
                    }).toList(),
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
                              // "International Band Music Concert",
                              widget.tripdetail.title,
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
                      EventDetailWidget(
                          icon: ImageConstant.calendaricon,
                          title: _initialStatusController.parseAndFormatDate(
                              widget.tripdetail.startTime.toString()),
                          des: _initialStatusController.formatDateTime(
                              _initialStatusController
                                  .parseDateTime(widget.tripdetail.startTime),
                              _initialStatusController
                                  .parseDateTime(widget.tripdetail.endTime))

                          // "${DateFormat('EEEE').format(DateTime.parse(tripdetail.startTime))}  ${DateFormat.jm().format(DateTime.parse(tripdetail.startTime))} - ${DateFormat.jm().format(DateTime.parse(tripdetail.endTime))}",
                          ),
                      SizedBox(height: 15.h),
                      EventDetailWidget(
                        icon: ImageConstant.location,
                        title: widget.tripdetail.location,
                        des: '',
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
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2)),
                            child: CustomImageView(
                              imagePath:
                                  "${EnvironmentConstants.baseUrlforimage}${widget.tripdetail.organiserPic}",
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
                                // widget.tripdetail.organiserId.fullname,
                                widget.tripdetail.organiserName ?? "Admin",
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
                        "About",
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
                          widget.tripdetail.about,
                          style: TextStyle(
                            fontSize: 14.v,
                            color: appTheme.black900.withOpacity(0.6),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      if (widget.tripdetail.userGoing.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            top: 5,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appTheme.blueGray400.withOpacity(0.4)),
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                'PAYMENT',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontSize: 7,
                                    ),
                              )),
                              DataColumn(
                                  label: Text(
                                'AMOUNT',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontSize: 7),
                              )),
                              DataColumn(
                                  label: Text(
                                'PERSON',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontSize: 7),
                              )),
                              DataColumn(
                                  label: Text(
                                'PHONE',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontSize: 7),
                              )),
                            ],
                            rows: widget.tripdetail
                                .userGoing // Loops through dataColumnText, each iteration assigning the value to element
                                .map(
                                  ((element) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(
                                            element.userId.fullname
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  fontSize: 7,
                                                ),
                                          )), //Extracting from Map element the value

                                          DataCell(Text(
                                            " \$ ${element.amount}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  fontSize: 7,
                                                ),
                                          )),
                                          DataCell(Text(
                                            "${element.totalPerson}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  fontSize: 7,
                                                ),
                                          )),
                                          DataCell(Text(
                                            "${element.phone}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                                  fontSize: 7,
                                                ),
                                          )),
                                        ],
                                      )),
                                )
                                .toList(),
                          ),
                        ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
            SizedBox(
              width: 280.v,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.v,
                  color: appTheme.blackText,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
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

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as Deo;

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:islamic_event_admin/api-handler/env_constants.dart';
import 'package:islamic_event_admin/model/EventModel.dart';
import 'package:islamic_event_admin/screen/details/detail_page.dart';
import 'package:islamic_event_admin/screen/home_page/search_location_screen.dart';
import 'package:islamic_event_admin/screen/notification/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:islamic_event_admin/widgets/app_bar/appbar_title.dart';
import 'package:islamic_event_admin/widgets/app_bar/custom_app_bar.dart';
import 'package:islamic_event_admin/widgets/custom_elevated_button.dart';
import 'package:islamic_event_admin/widgets/custom_text_form_field.dart';
import 'package:video_player/video_player.dart';
import '../../controller/initialStatuaController.dart';
import '../../core/app_export.dart';
import '../join_trip_screen/join_trip_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final List<File> _images = [];
  var images = [];
  final picker = ImagePicker();
  File? _video;

  Future getImage(ImageSource source, bool isvideo) async {
    if (isvideo) {
      final pickedFile = await picker.pickVideo(source: source);
      Get.back();

      print("video");
      if (pickedFile.toString() != "null") {
        final videoFile = File(pickedFile!.path);
        final videoController = VideoPlayerController.file(videoFile);

        final Duration videoDuration = videoController.value.duration;
        final int videoSizeInBytes = videoFile.lengthSync();
        final double videoSizeInMB = videoSizeInBytes / (1024 * 1024);

        // Define the maximum allowed file size in MB
        const double maxFileSizeInMB = 10.0;
        // print("size ${videoController.value.size.}");
        if (videoDuration.inSeconds > 30) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Please select a video of at least 30 seconds duration.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (videoSizeInMB > maxFileSizeInMB) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Please select a video smaller than $maxFileSizeInMB MB.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Video meets the duration requirement, proceed with setting the video
          setState(() {
            _video = videoFile;
            if (_images.isNotEmpty) {
              if (_images.first.path.toString().contains(".mp4") ||
                  _images.first.path.toString().contains(".mkv") ||
                  _images.first.path.toString().contains(".webm") ||
                  _images.first.path.toString().contains(".MOV")) {
                _images.first = File(pickedFile.path);
              } else {
                _images.insert(0, File(pickedFile.path));
              }
            } else {
              _images.add(File(pickedFile.path));
            }
            // _initializeVideoPlayer(); // Initialize the video player with the new video
          });
        }
      }
    } else {
      Get.back();

      List<XFile> pickimage = await picker.pickMultiImage();
      if (pickimage.length + _images.length <= 15) {
        for (int i = 0; i < pickimage.length; i++) {
          _images.add(File(pickimage[i].path));
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Maximum media limit is reached'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {});
  }

  void removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = DateTime(picked.year, picked.month, picked.day);

          startDateController.text = _formatDate(_startDate);
        } else {
          _endDate = DateTime(picked.year, picked.month, picked.day);
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      // initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          startTimeController.text = _formatTime(_startTime!);
        } else {
          _endTime = picked;
          endTimeController.text = _formatTime(_endTime!);
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // This is the format for AM/PM
    return format.format(dt);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 1.h, top: 7, bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_images.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Upload Media'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.image,
                                            color: theme.colorScheme.primary,
                                          ),
                                          title: const Text('Upload Image'),
                                          onTap: () {
                                            getImage(
                                                ImageSource.gallery, false);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.videocam,
                                            color: theme.colorScheme.primary,
                                          ),
                                          title: const Text('Upload Video'),
                                          onTap: () {
                                            getImage(ImageSource.gallery, true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              // getImage(ImageSource.gallery);
                            },
                            child: Row(
                              children: [
                                Text("Add Image and Video",
                                    style: theme.textTheme.bodySmall!.copyWith(
                                        color: theme.colorScheme.primary)),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: theme.colorScheme.primary,
                                  size: 13.h,
                                ),
                              ],
                            ),
                          )
                      ],
                    )),
                _addImage(context),
                SizedBox(height: 15.v),
                CustomTextFormField(
                    controller: titleController,
                    hintText: "Title",
                    hintStyle: CustomTextStyles.bodySmall10,
                    textInputType: TextInputType.text),
                SizedBox(height: 15.v),
                InkWell(
                  onTap: () {
                    _selectDate(context, true);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomTextFormField(
                        controller: startDateController,
                        hintText: "Start Date",
                        hintStyle: CustomTextStyles.bodySmall10,
                        textInputType: TextInputType.number),
                  ),
                ),
                SizedBox(height: 15.v),
                InkWell(
                  onTap: () {
                    _selectTime(context, true);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomTextFormField(
                        controller: startTimeController,
                        hintText: "Start Time",
                        hintStyle: CustomTextStyles.bodySmall10,
                        textInputType: TextInputType.number),
                  ),
                ),
                SizedBox(height: 15.v),
                InkWell(
                  onTap: () {
                    _selectTime(context, false);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomTextFormField(
                        controller: endTimeController,
                        hintText: "End Time",
                        hintStyle: CustomTextStyles.bodySmall10,
                        textInputType: TextInputType.number),
                  ),
                ),
                SizedBox(height: 15.v),
                InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => const PlacesSearchScreen());
                    },
                    child: IgnorePointer(
                        ignoring: true,
                        child: CustomTextFormField(
                          // readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please add location';
                            }
                            return null;
                          },
                          suffix: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: appTheme.gray400,
                            size: 15.h,
                          ),

                          controller: _initialStatusController
                              .locationEditTextController,
                          textInputType: TextInputType.number,
                          hintText: "Choose Location",
                        ))),
                SizedBox(height: 15.v),
                CustomTextFormField(
                  maxLines: 7,
                  controller: descriptionController,
                  hintText: "Enter Detail About Event",
                  hintStyle: CustomTextStyles.bodySmall10,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15.v),
                _buildPost(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> ImagesLIst() async {
    images.clear();
    for (int i = 0; i < _images.length; i++) {
      if (_images[i].path.toString().endsWith(".png") ||
          _images[i].path.toString().endsWith(".jpg") ||
          _images[i].path.toString().endsWith(".jpeg")) {
        print("ifcall");
        String fileName = _images[i].path.split('/').last;

        var file = await Deo.MultipartFile.fromFile(_images[i].path,
            filename: fileName);
        images.add(file);
      }
    }
  }

  Widget _buildPost(BuildContext context) {
    return CustomElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            showDialog(
              context: Get.context!,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text(
                      'Please confirm that you have described this vehicle to the best of your knowledge and ability… Also that you have read and understood the groups terms and conditions.'),
                  actions: <Widget>[
                    InkWell(
                      onTap: () async {
                        EasyLoading.show();
                        dynamic videos;
                        await ImagesLIst();
                        // await _getCurrentLocation();
                        if (_video != null) {
                          String fileName = _video!.path.split('/').last;

                          var video = await Deo.MultipartFile.fromFile(
                              _video!.path,
                              filename: fileName);
                          videos = [video];
                        }
                        if (images.isNotEmpty) {
                          _initialStatusController.addProject({
                            "title": titleController.text,
                            "date": startDateController.text,
                            "startTime": startTimeController.text,
                            "endTime": endTimeController.text,
                            "lat": _initialStatusController.latitude,
                            "long": _initialStatusController.longitude,
                            "location": _initialStatusController
                                .locationEditTextController.text,
                            "about": descriptionController.text,
                            "pictures": images,
                            "videos": videos,
                          });
                        } else {
                          Fluttertoast.showToast(msg: "AtLeast add one image");
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Set border radius to 0
                  ),
                );
              },
            );
          }
        },
        text: "Add Project",
        buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
        margin: EdgeInsets.only(left: 21.h, right: 20.h, bottom: 21.v));
  }

  Widget _addImage(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 1.h),
        decoration: AppDecoration.outlinePrimary
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _images.isEmpty
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Upload Media'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.image,
                                color: theme.colorScheme.primary,
                              ),
                              title: const Text('Upload Image'),
                              onTap: () {
                                getImage(ImageSource.gallery, false);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.videocam,
                                color: theme.colorScheme.primary,
                              ),
                              title: const Text('Upload Video'),
                              onTap: () {
                                getImage(ImageSource.gallery, true);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : null;
            // _images.isEmpty ? getImage(ImageSource.gallery,true)
            //  : null;
          },
          child: DottedBorder(
            color: theme.colorScheme.primary,
            padding:
                EdgeInsets.only(left: 1.h, top: 1.v, right: 1.h, bottom: 1.v),
            strokeWidth: 1.h,
            radius: const Radius.circular(5),
            borderType: BorderType.RRect,
            dashPattern: const [6, 6],
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _images.isEmpty ? 80.h : 5.h,
                  vertical: _images.isEmpty ? 44.v : 10.v),
              child: _images.isEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      // CustomImageView(
                      //     imagePath: ImageConstant.,
                      //     height: 15.adaptSize,
                      //     width: 15.adaptSize,
                      //     margin: EdgeInsets.only(bottom: 3.v),
                      //     onTap: () {
                      //       // onTapImgClose(context);
                      //     }),
                      Text("Add Images and Video",
                          style: theme.textTheme.bodyMedium)
                    ])
                  : Column(
                      children: [
                        SizedBox(
                          height: 110.h,
                          width: double.infinity,
                          child: ReorderableListView.builder(
                            itemCount: _images.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                key: Key(
                                    '$index'), // Add a unique key for reordering
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(2.v),
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 80.h,
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          removeImage(index);
                                                          Get.back();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 8),
                                                          child: Row(
                                                            children: [
                                                              Text("Remove",
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodyLarge),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 8),
                                                          child: Row(
                                                            children: [
                                                              Text("Cancel",
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodyLarge),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          //  removeImage(index);
                                        },
                                        child: (_images[index]
                                                    .path
                                                    .endsWith('.mp4') ||
                                                _images[index]
                                                    .path
                                                    .endsWith('.mkv') ||
                                                _images[index]
                                                    .path
                                                    .endsWith('.webm') ||
                                                _images[index].path.endsWith(
                                                    '.MOV')) // Check if the file is a video
                                            ? Container(
                                                color: appTheme.blueGray400,
                                                width: 80.v,
                                                height: 100.h,
                                                child: const Center(
                                                  child: Icon(Icons.play_arrow),
                                                ),
                                              )
                                            : Image.file(
                                                _images[index],
                                                width: 80.v,
                                                height: 100.h,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    // Positioned(
                                    //   top: 0,
                                    //   right: 0,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       removeImage(index);
                                    //     },
                                    //     child: Icon(Icons.cancel,
                                    //         color: Colors.red),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final image = _images.removeAt(oldIndex);
                                _images.insert(newIndex, image);
                              });
                            },
                          ),
                        ),
                        Text(
                            "Tap on images to edit them, or press, hold and move for reordering. ",
                            style: theme.textTheme.labelSmall!.copyWith(
                                color: appTheme.blueGray400, fontSize: 11.h))
                      ],
                    ),
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      centerTitle: true,
      title: AppbarTitle(
        text: "Project",
      ),
      styleType: Style.bgFill,
    );
  }
}

class CustomEvent extends StatelessWidget {
  EventModel eventData;
  CustomEvent({
    required this.eventData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(
      eventData.createdAt,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.v),

      width: 348.v,
      // height: 180.h,
      child: Column(
        children: [
          Container(
            width: 348.v,
            height: 157.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.v),
                color: theme.colorScheme.primary),
            child: CustomImageView(
              fit: BoxFit.fill,
              onTap: () {
                print(
                    "${EnvironmentConstants.baseUrlforimage}${eventData.images.first}");
              },
              imagePath: eventData.images.isEmpty
                  ? ImageConstant.event
                  : "${EnvironmentConstants.baseUrlforimage}${eventData.images.first}",
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 244.v,
                    child: Text(
                      eventData.title,
                      style: TextStyle(
                        fontSize: 16.v,
                        color: appTheme.blackText,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<InitialStatusController>()
                          .getEventById(eventId: eventData.id)
                          .then((value) async {
                        Get.to(() => DetailScreen(
                              eventdetail: Get.find<InitialStatusController>()
                                  .eventbyId
                                  .first,
                            ));
                      });
                    },
                    child: Container(
                      width: 80.v,
                      height: 28.h,
                      padding: EdgeInsets.all(6.v),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.v),
                          color: theme.colorScheme.primary),
                      child: Center(
                        child: Text(
                          "View Detail",
                          style: TextStyle(
                            fontSize: 12.v,
                            color: appTheme.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.calendartime,
                    color: appTheme.blackText,
                  ),
                  SizedBox(width: 4.v),
                  Text(
                    // "November 15 2024",
                    Get.find<InitialStatusController>()
                        .formatDate(DateTime.parse(eventData.createdAt)),
                    style: TextStyle(
                      fontSize: 12.v,
                      color: appTheme.blackText,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}





// import 'package:islamic_event_admin/core/app_export.dart';
// import 'package:islamic_event_admin/model/ProjectModel.dart';
// import 'package:islamic_event_admin/screen/details/donation_detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/instance_manager.dart';
// import 'package:get/route_manager.dart';

// import '../../api-handler/env_constants.dart';
// import '../../controller/initialStatuaController.dart';
// import '../../widgets/app_bar/appbar_title.dart';
// import '../../widgets/app_bar/custom_app_bar.dart';
// import '../donation_payment_screen/donation_payment_screen.dart';

// class ProjectsScreen extends StatefulWidget {
//   const ProjectsScreen({
//     super.key,
//   });

//   @override
//   State<ProjectsScreen> createState() => _ProjectsScreenState();
// }

// class _ProjectsScreenState extends State<ProjectsScreen> {
//   final InitialStatusController _initialStatusController =
//       Get.find<InitialStatusController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Container(
//         width: double.maxFinite,
//         padding: const EdgeInsets.symmetric(
//             // horizontal: 20.h,
//             ),
//         child: ListView.builder(
//             itemCount: _initialStatusController.allprojectlist.length,
//             shrinkWrap: true,
//             // physics: const NeverScrollableScrollPhysics(),
//             padding: EdgeInsets.symmetric(
//               horizontal: 20.h,
//             ),
//             itemBuilder: (context, index) {
//               ProjectModel project =
//                   _initialStatusController.allprojectlist[index];
//               return Column(
//                 children: [
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   SizedBox(
//                     width: 348.v,
//                     child: Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Get.find<InitialStatusController>()
//                                 .getProjectById(projectId: project.id)
//                                 .then((value) async {
//                               Get.to(() => DonationDetailScreen(
//                                     project: Get.find<InitialStatusController>()
//                                         .groupbyId
//                                         .first,
//                                   ));
//                             });
//                             // Get.to(() => const DonationDetailScreen());
//                           },
//                           child: Container(
//                             width: 348.v,
//                             height: 157.h,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.v),
//                                 color: theme.colorScheme.surfaceBright),
//                             child: CustomImageView(
//                               fit: BoxFit.fill,
//                               imagePath: project.images.isEmpty
//                                   ? ImageConstant.event
//                                   : "${EnvironmentConstants.baseUrlforimage}${project.images.first}",
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5.h,
//                         ),
//                         Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: 244.v,
//                                   child: Text(
//                                     project.title,
//                                     style: TextStyle(
//                                       fontSize: 16.v,
//                                       color: appTheme.blackText,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     Get.to(() => DonationPaymentScreen());
//                                   },
//                                   child: Container(
//                                     width: 80.v,
//                                     height: 28.h,
//                                     padding: EdgeInsets.all(6.v),
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(5.v),
//                                         color: theme.colorScheme.primary),
//                                     child: Center(
//                                       child: Text(
//                                         "Donate",
//                                         style: TextStyle(
//                                           fontSize: 12.v,
//                                           color: appTheme.white,
//                                           fontFamily: 'Inter',
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 CustomImageView(
//                                   imagePath: ImageConstant.calendartime,
//                                   color: appTheme.blackText,
//                                 ),
//                                 SizedBox(width: 4.v),
//                                 Text(
//                                   // "November 15 2024",
//                                   Get.find<InitialStatusController>()
//                                       .formatDate(
//                                           DateTime.parse(project.createdAt)),

//                                   style: TextStyle(
//                                     fontSize: 12.v,
//                                     color: appTheme.blackText,
//                                     fontFamily: 'Inter',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 7.h,
//                   )
//                 ],
//               );
//             }),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return CustomAppBar(
//       leadingWidth: 40.h,
//       centerTitle: true,
//       title: AppbarTitle(
//         text: "Projects",
//       ),
//       styleType: Style.bgFill,
//     );
//   }
// }




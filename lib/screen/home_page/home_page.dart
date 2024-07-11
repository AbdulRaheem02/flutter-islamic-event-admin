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

class EventPageScreen extends StatefulWidget {
  const EventPageScreen({super.key});

  @override
  State<EventPageScreen> createState() => _EventPageScreenState();
}

class _EventPageScreenState extends State<EventPageScreen> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController organizerNameController = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final List<File> _images = [];
  var images = [];
  final picker = ImagePicker();
  File? _video;
  File? _image;

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
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Future<void> _selectDate(BuildContext context, bool isStart) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStart) {
  //         _startDate = DateTime(picked.year, picked.month, picked.day);

  //         startDateController.text = _formatDate(_startDate);
  //       } else {
  //         _endDate = DateTime(picked.year, picked.month, picked.day);
  //       }
  //     });
  //   }
  // }
  Future<String> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    String? selectdate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);

        selectdate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
    return selectdate!;
  }

  Future<String> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    String? selectTime;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      print(selectedTime);

      selectTime = selectedTime.format(context);
    }
    return selectTime ?? ''; // Return an empty string if no time is selected
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

  bool isEvent = true;
  bool isTrip = false;
  bool isProject = false;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.v),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40.v,
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.v),
                          border: Border.all(
                              color: isEvent
                                  ? theme.colorScheme.primary
                                  : appTheme.black900)),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isEvent = true;
                            isProject = false;
                            isTrip = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Event",
                              style: isEvent
                                  ? CustomTextStyles.bodySmallIndigo900
                                  : CustomTextStyles.bodySmallYellow900,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40.v,
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.v),
                          border: Border.all(
                              color: isProject
                                  ? theme.colorScheme.primary
                                  : appTheme.black900)),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isEvent = false;
                            isProject = true;
                            isTrip = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Project",
                              style: isProject
                                  ? CustomTextStyles.bodySmallIndigo900
                                  : CustomTextStyles.bodySmallYellow900,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40.v,
                      width: MediaQuery.of(context).size.width * 0.28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.v),
                          border: Border.all(
                              color: isTrip
                                  ? theme.colorScheme.primary
                                  : appTheme.black900)),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isEvent = false;
                            isProject = false;
                            isTrip = true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Trip",
                              style: isTrip
                                  ? CustomTextStyles.bodySmallIndigo900
                                  : CustomTextStyles.bodySmallYellow900,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                  controller: organizerNameController,
                  hintText: "Enter Organizer Name",
                  hintStyle: CustomTextStyles.bodySmall10,
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organizer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.v),

                Row(
                  children: [
                    _image == null
                        ? Container(
                            width: 140.v,
                            height: 100.h,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.v),
                                color: appTheme.lightbackground),
                          )
                        : Container(
                            width: 140.v,
                            height: 190.h,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.v),
                                color: appTheme.lightbackground),
                            child: Image.file(
                              _image!,
                              height: 100.h,
                              width: 200,
                            ),
                          ),
                    TextButton(
                        onPressed: () {
                          _pickImage();
                        },
                        child: const Text("Add Organizer Image")),
                  ],
                ),
                SizedBox(height: 15.v),

                CustomTextFormField(
                  controller: titleController,
                  hintText: "Title",
                  hintStyle: CustomTextStyles.bodySmall10,
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.v),
                if (isEvent || isTrip)
                  Column(
                    children: [
                      CustomTextFormField(
                        controller: priceController,
                        hintText: "Price",
                        hintStyle: CustomTextStyles.bodySmall10,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.v),
                    ],
                  ),
                InkWell(
                  onTap: () async {
                    // _selectDate(context, true);
                    startDateController.text = await _selectDate(context);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomTextFormField(
                      controller: startDateController,
                      hintText: "Start Date",
                      hintStyle: CustomTextStyles.bodySmall10,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select start date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15.v),
                InkWell(
                  onTap: () async {
                    // _selectTime(context, true);
                    startTimeController.text = await _selectTime(context);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomTextFormField(
                      controller: startTimeController,
                      hintText: "Start Time",
                      hintStyle: CustomTextStyles.bodySmall10,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select start time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15.v),
                InkWell(
                  onTap: () async {
                    // _selectTime(context, false);
                    endTimeController.text = await _selectTime(context);
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomTextFormField(
                      controller: endTimeController,
                      hintText: "End Time",
                      hintStyle: CustomTextStyles.bodySmall10,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select end time';
                        }
                        return null;
                      },
                    ),
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
                  hintText: "Enter Detail About",
                  hintStyle: CustomTextStyles.bodySmall10,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please add about detail';
                    }
                    return null;
                  },
                ),
                // Expanded(
                //   child: ListView.builder(
                //       padding: EdgeInsets.symmetric(horizontal: 15.h),
                //       itemCount: _initialStatusController.alleventlist.length,
                //       itemBuilder: (context, index) {
                //         EventModel event =
                //             _initialStatusController.alleventlist[index];
                //         return CustomEvent(eventData: event);
                //       }),
                // )
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
            EasyLoading.show();
            dynamic videos;
            await ImagesLIst();
            // await _getCurrentLocation();
            if (_video != null) {
              String fileName = _video!.path.split('/').last;

              var video = await Deo.MultipartFile.fromFile(_video!.path,
                  filename: fileName);
              videos = [video];
            }
            if (images.isNotEmpty) {
              if (_image != null) {
                var fileBookImage = _image!.path.split('/').last;
                var fileimage = await Deo.MultipartFile.fromFile(
                  _image!.path,
                  filename: fileBookImage,
                );
                Map<String, dynamic> params = {
                  "title": titleController.text,
                  "date": startDateController.text,
                  "startTime":
                      // startTimeController.text,
                      "${startDateController.text} ${startTimeController.text}",
                  "endTime":
                      // endTimeController.text,
                      "${startDateController.text} ${endTimeController.text}",
                  "lat": _initialStatusController.latitude,
                  "long": _initialStatusController.longitude,
                  "location":
                      _initialStatusController.locationEditTextController.text,
                  "about": descriptionController.text,
                  "pictures": images,
                  "videos": videos,
                  "organiserName": organizerNameController.text,
                  "organiserPic": fileimage,
                  "price": priceController.text
                };
                if (isEvent) {
                  _initialStatusController.addEvent(params);
                } else if (isProject) {
                  _initialStatusController.addProject(params);
                } else if (isTrip) {
                  _initialStatusController.addTrip(params);
                }
              } else {
                Fluttertoast.showToast(msg: "Add Organizer image");
              }
            } else {
              Fluttertoast.showToast(msg: "AtLeast add one image");
            }
          }
        },
        text: isEvent
            ? "Add Event"
            : isProject
                ? "Add Project"
                : "Add Trip",
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
        text: isEvent ? "Event" : "Project",
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

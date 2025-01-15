import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:islamic_event_admin/api-handler/env_constants.dart';
import 'package:islamic_event_admin/custom_widgets/InternalStorage.dart';
import 'package:islamic_event_admin/custom_widgets/toast.dart';
import 'package:islamic_event_admin/model/EventModel.dart';
import 'package:islamic_event_admin/screen/details/detail_page.dart';
import 'package:islamic_event_admin/screen/details/trip_detail_page.dart';
import 'package:islamic_event_admin/screen/home_page/project_page.dart';
import 'package:islamic_event_admin/screen/info.dart';
import 'package:islamic_event_admin/screen/notification/notification_screen.dart';
import 'package:islamic_event_admin/screen/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import '../../controller/initialStatuaController.dart';
import '../../core/app_export.dart';
import '../../widgets/eventNotFound.dart';

class EventPageScreen extends StatefulWidget {
  const EventPageScreen({super.key});

  @override
  State<EventPageScreen> createState() => _EventPageScreenState();
}

class _EventPageScreenState extends State<EventPageScreen> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _initialStatusController.getallevent();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        print(
            "selected $selectedIndex = ${_initialStatusController.isLoading.value}");
        // print("You have reached the end of the list");
        if (selectedIndex == 0) {
          if (_initialStatusController.isMoreDataAvailable.value &&
              !_initialStatusController.isLoading.value) {
            EasyLoading.show();
            _initialStatusController.getallevent(
                page: _initialStatusController.currentPage.value + 1);
          }
        } else {
          if (_initialStatusController.isMoreDataAvailableTrip.value) {
            EasyLoading.show();
            _initialStatusController.getalltrip(
                page: _initialStatusController.currentPageTrip.value + 1);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
            // horizontal: 20.h,
            // vertical: 11.v,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: theme.colorScheme.primary.withOpacity(0.05),
              padding: EdgeInsets.symmetric(
                horizontal: 10.h,
                vertical: 11.v,
              ),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Prophetic path",
                            style: TextStyle(
                                fontSize: 26.v,
                                color: appTheme.black900,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600),
                          ),
//                           SizedBox(width: 7.v),
                          // Obx(() => Text(
                          //       _initialStatusController.userProfile.isNotEmpty
                          //           ? _initialStatusController
                          //               .userProfile.first.data.firstName
                          //           : "",
                          //       style: theme.textTheme.bodyLarge!.copyWith(
                          //           color: appTheme.black900,
                          //           fontSize: 15.fSize,
                          //           fontWeight: FontWeight.bold),
                          //     ))
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              // Get.offAll(() => const SignInScreen());
                              await showModalBottomSheet(
                                  context: Get.context!,
                                  builder: (context) {
                                    return const infoPage();
                                  });
                            },
                            child: appbarItemicon(
                              icon: ImageConstant.info,
                            ),
                          ),
                          SizedBox(width: 4.v),
                          InkWell(
                            onTap: () {
                              _initialStatusController
                                  .getallnotifications()
                                  .then((val) {
                                Get.to(() => NotificationScreen());
                              });
                            },
                            child: appbarItemicon(
                              icon: ImageConstant.notification,
                            ),
                          ),
                          SizedBox(width: 4.v),
                          InkWell(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                        'Are you sure you want to logout?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          clearEveryThing();
                                          Get.offAll(
                                              () => const SignInScreen());
                                        },
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              // height: 30.v,
                              // width: 30.v,
                              padding: EdgeInsets.all(6.v),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.v),
                                  color: theme.colorScheme.surfaceBright),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _initialStatusController.alleventlist.clear();
                              _initialStatusController.getallevent();

                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              height: 45.v,
                              width: 150.v,
                              padding: EdgeInsets.all(6.v),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.v),
                                  color: appTheme.white),
                              child: Center(
                                child: Text(
                                  "Events",
                                  style: TextStyle(
                                    fontSize: selectedIndex == 0 ? 16.v : 13.v,
                                    color: selectedIndex == 0
                                        ? appTheme.black900
                                        : appTheme.gray400,
                                    fontFamily: 'Inter',
                                    fontWeight: selectedIndex == 0
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 25.v,
                            right: 25.v,
                            child: Container(
                              height: 5.v,
                              width: 55.v,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.v),
                                  color: selectedIndex == 0
                                      ? theme.colorScheme.primary
                                      : Colors.transparent),
                            ),
                          )
                        ],
                      ),
                      // Stack(
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           selectedIndex = 1;
                      //         });
                      //       },
                      //       child: Container(
                      //         height: 45.v,
                      //         width: 108.v,
                      //         padding: EdgeInsets.all(6.v),
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(30.v),
                      //             color: appTheme.white),
                      //         child: Center(
                      //           child: Text(
                      //             "Past Events",
                      //             style: TextStyle(
                      //               fontSize: selectedIndex == 1 ? 12.v : 11.v,
                      //               color: selectedIndex == 1
                      //                   ? appTheme.black900
                      //                   : appTheme.gray400,
                      //               fontFamily: 'Inter',
                      //               fontWeight: selectedIndex == 1
                      //                   ? FontWeight.w600
                      //                   : FontWeight.w400,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Positioned(
                      //       bottom: 0,
                      //       left: 25.v,
                      //       right: 25.v,
                      //       child: Container(
                      //         height: 5.v,
                      //         width: 55.v,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(30.v),
                      //             color: selectedIndex == 1
                      //                 ? theme.colorScheme.primary
                      //                 : Colors.transparent),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _initialStatusController.alltriplist.clear();
                              _initialStatusController.getalltrip();
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                            child: Container(
                              height: 45.v,
                              width: 150.v,
                              padding: EdgeInsets.all(6.v),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.v),
                                  color: appTheme.white),
                              child: Center(
                                child: Text(
                                  "Ture",
                                  // +"(${_initialStatusController.alltriplist.length})",
                                  style: TextStyle(
                                    fontSize: selectedIndex == 2 ? 16.v : 13.v,
                                    color: selectedIndex == 2
                                        ? appTheme.black900
                                        : appTheme.gray400,
                                    fontFamily: 'Inter',
                                    fontWeight: selectedIndex == 2
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 25.v,
                            right: 25.v,
                            child: Container(
                              height: 5.v,
                              width: 55.v,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.v),
                                  color: selectedIndex == 2
                                      ? theme.colorScheme.primary
                                      : Colors.transparent),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
            Obx(() => selectedIndex == 0
                ? _initialStatusController.eventnf.value == true &&
                        _initialStatusController.alleventlist.isEmpty
                    ? const Center(
                        child: EventNotFound(),
                      )
                    : _initialStatusController.alleventlist.isEmpty
                        ? buildShimmerEffectColumn(height: 190.h, length: 2)
                        : Expanded(
                            child: ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(horizontal: 15.h),
                                itemCount: _initialStatusController
                                    .alleventlist.length,
                                itemBuilder: (context, index) {
                                  EventModel event = _initialStatusController
                                      .alleventlist[index];
                                  return CustomEvent(eventData: event);
                                }),
                          )
                : selectedIndex == 1
                    ? const EventNotFound()
                    : _initialStatusController.tripnf.value == true &&
                            _initialStatusController.alltriplist.isEmpty
                        ? SizedBox(
                            height: 500.h,
                            child: const Center(
                              child: Text("Not Available"),
                            ),
                          )
                        : _initialStatusController.alltriplist.isEmpty
                            ? buildShimmerEffectColumn(height: 190.h, length: 2)
                            : Expanded(
                                child: ListView.builder(
                                    controller: _scrollController,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.h),
                                    itemCount: _initialStatusController
                                        .alltriplist.length,
                                    itemBuilder: (context, index) {
                                      EventModel trip = _initialStatusController
                                          .alltriplist[index];
                                      return CustomTripCard(tripData: trip);
                                    }),
                              )),
          ],
        ),
      ),
    );
  }
}

class CustomTripCard extends StatelessWidget {
  EventModel tripData;
  CustomTripCard({
    required this.tripData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.v),

      width: MediaQuery.of(context).size.width * 0.95,

      // height: 180.h,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 157.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.v),
                    color: theme.colorScheme.primary),
                child: CustomImageView(
                  fit: BoxFit.fill,
                  onTap: () {
                    Get.find<InitialStatusController>()
                        .getTripById(tripId: tripData.id)
                        .then((value) async {
                      Get.to(() => TripDetailScreen(
                            tripdetail: Get.find<InitialStatusController>()
                                .tripbyId
                                .first,
                          ));
                    });
                  },
                  imagePath: tripData.images.isEmpty
                      ? ImageConstant.event
                      : "${EnvironmentConstants.baseUrlforimage}${tripData.images.last}",
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Trip'),
                        content: const Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.back();
                              Get.find<InitialStatusController>()
                                  .deleteTrip(tripData.id);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
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
                      tripData.title,
                      style: TextStyle(
                        fontSize: 16.v,
                        color: appTheme.blackText,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                        .formatDate(DateTime.parse(tripData.createdAt)),
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

class appbarItemicon extends StatelessWidget {
  String icon;
  double? height;
  double? iconsize;

  double? width;
  BoxDecoration? decoration;
  appbarItemicon({
    required this.icon,
    this.decoration,
    this.height,
    this.width,
    this.iconsize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 30.v,
      width: width ?? 30.v,
      padding: EdgeInsets.all(6.v),
      decoration: decoration ??
          BoxDecoration(
              borderRadius: BorderRadius.circular(8.v),
              color: theme.colorScheme.primary),
      child: CustomImageView(
        imagePath: icon,
        height: iconsize,
      ),
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
    Get.log(
      eventData.createdAt,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.v),

      width: MediaQuery.of(context).size.width * 0.95,

      // height: 180.h,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 157.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.v),
                    color: theme.colorScheme.primary),
                child: CustomImageView(
                  fit: BoxFit.fill,
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
                  imagePath: eventData.images.isEmpty
                      ? ImageConstant.event
                      : "${EnvironmentConstants.baseUrlforimage}${eventData.images.last}",
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Event'),
                        content: const Text('Are you sure you want to delete?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.back();

                              Get.find<InitialStatusController>()
                                  .deleteEvent(eventData.id);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
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
                      height: 28.h,
                      padding: EdgeInsets.all(6.v),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.v),
                          color: theme.colorScheme.primary),
                      child: Center(
                        child: Text(
                          "Se detaljer",
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

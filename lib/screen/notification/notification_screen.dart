import 'package:islamic_event_admin/controller/initialStatuaController.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/model/NotificationModel.dart';
import 'package:islamic_event_admin/screen/details/detail_page.dart';
import 'package:islamic_event_admin/screen/details/donation_detail_page.dart';
import 'package:islamic_event_admin/screen/details/trip_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:islamic_event_admin/screen/home_page/project_page.dart';

import '../../api-handler/env_constants.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({
    super.key,
  });
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
        ),
        child: Column(
          children: [
            Obx(() => _initialStatusController.notificationnf.value == true &&
                    _initialStatusController.allnotificationlist.isEmpty
                ? SizedBox(
                    height: 500.h,
                    child: const Center(
                      child: Text("Not Available"),
                    ),
                  )
                : _initialStatusController.allnotificationlist.isEmpty
                    ? buildShimmerEffectColumn(height: 100.h, length: 5)
                    : Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: _initialStatusController
                                .allnotificationlist.length,
                            itemBuilder: (context, index) {
                              NotificationModel notificationdetail =
                                  _initialStatusController
                                      .allnotificationlist[index];
                              return notificationdetail.type
                                          .toString()
                                          .toLowerCase() ==
                                      "payment"
                                  ? GestureDetector(
                                      onTap: () {
                                        if (notificationdetail.type == "book") {
                                          _initialStatusController
                                              .getBookById(
                                                  bookId:
                                                      notificationdetail.id!)
                                              .then((val) {
                                            _initialStatusController.getPdfPath(
                                                "${EnvironmentConstants.baseUrlforimage}${_initialStatusController.bookbyId.first.book}");
                                          });
                                        } else if (notificationdetail.type ==
                                            "project") {
                                          Get.find<InitialStatusController>()
                                              .getProjectById(
                                                  projectId:
                                                      notificationdetail.id!)
                                              .then((value) async {
                                            Get.to(() => ProjectDetailScreen(
                                                  projectdetail: Get.find<
                                                          InitialStatusController>()
                                                      .groupbyId
                                                      .first,
                                                ));
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 7),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: appTheme.gray400),
                                            borderRadius:
                                                BorderRadius.circular(10.h)),
                                        width: 348.v,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.end,
                                            //   children: [
                                            //     Container(
                                            //       width: 8.v,
                                            //       height: 8.h,
                                            //       decoration: const BoxDecoration(
                                            //           shape: BoxShape.circle,
                                            //           color: Colors.green),
                                            //     ),
                                            //   ],
                                            // ),
                                            SizedBox(
                                              width: 244.v,
                                              child: Text(
                                                notificationdetail.title,
                                                style: TextStyle(
                                                  fontSize: 14.v,
                                                  color: appTheme.blackText,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  // "December 23, 2019 at 6:00 pm",
                                                  // notificationdetail.createdAt,
                                                  DateFormat(
                                                          'MMMM d, yyyy \'at\' h:mm a')
                                                      .format(DateTime.parse(
                                                              notificationdetail
                                                                  .createdAt)
                                                          .toLocal()),
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
                                      ),
                                    )
                                  : Container();
                            }),
                      ))
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      centerTitle: true,
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
      title: AppbarTitle(
        text: "Notifications",
      ),
      styleType: Style.bgFill,
    );
  }
}







// import 'package:islamic_event_admin/controller/initialStatuaController.dart';
// import 'package:islamic_event_admin/core/app_export.dart';
// import 'package:islamic_event_admin/model/NotificationModel.dart';
// import 'package:islamic_event_admin/screen/details/detail_page.dart';
// import 'package:islamic_event_admin/screen/details/donation_detail_page.dart';
// import 'package:islamic_event_admin/screen/details/trip_detail_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:get/route_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:islamic_event_admin/screen/home_page/project_page.dart';

// import '../../api-handler/env_constants.dart';
// import '../../widgets/app_bar/appbar_title.dart';
// import '../../widgets/app_bar/custom_app_bar.dart';

// class NotificationScreen extends StatelessWidget {
//   NotificationScreen({
//     super.key,
//   });
//   final InitialStatusController _initialStatusController =
//       Get.find<InitialStatusController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Container(
//         width: double.maxFinite,
//         padding: EdgeInsets.symmetric(
//           horizontal: 20.h,
//         ),
//         child: Column(
//           children: [
//             Obx(() => _initialStatusController.notificationnf.value == true &&
//                     _initialStatusController.allnotificationlist.isEmpty
//                 ? SizedBox(
//                     height: 500.h,
//                     child: const Center(
//                       child: Text("Not Available"),
//                     ),
//                   )
//                 : _initialStatusController.allnotificationlist.isEmpty
//                     ? buildShimmerEffectColumn(height: 100.h, length: 5)
//                     : Expanded(
//                         child: ListView.builder(
//                             padding: const EdgeInsets.only(top: 10),
//                             itemCount: _initialStatusController
//                                 .allnotificationlist.length,
//                             itemBuilder: (context, index) {
//                               NotificationModel notificationdetail =
//                                   _initialStatusController
//                                       .allnotificationlist[index];
//                               return notificationdetail.type
//                                               .toString()
//                                               .toLowerCase() ==
//                                           "trips" ||
//                                       notificationdetail.type
//                                               .toString()
//                                               .toLowerCase() ==
//                                           "events"
//                                   ? Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 7),
//                                       margin: const EdgeInsets.only(bottom: 10),
//                                       decoration: BoxDecoration(
//                                           color: theme.colorScheme.primary
//                                               .withOpacity(0.6),
//                                           borderRadius:
//                                               BorderRadius.circular(10.h)),
//                                       width: 348.v,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // Row(
//                                           //   mainAxisAlignment: MainAxisAlignment.end,
//                                           //   children: [
//                                           //     Container(
//                                           //       width: 8.v,
//                                           //       height: 8.h,
//                                           //       decoration: const BoxDecoration(
//                                           //           shape: BoxShape.circle,
//                                           //           color: Colors.green),
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                           SizedBox(
//                                             width: 244.v,
//                                             child: Text(
//                                               notificationdetail.title,
//                                               // notificationdetail.type,
//                                               style: TextStyle(
//                                                 fontSize: 12.v,
//                                                 color: appTheme.white,
//                                                 fontFamily: 'Inter',
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 5.h,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 notificationdetail.body,
//                                                 style: TextStyle(
//                                                   fontSize: 14.v,
//                                                   color: appTheme.white,
//                                                   fontFamily: 'Inter',
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 15.h,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   if (notificationdetail.type
//                                                           .toString()
//                                                           .toLowerCase() ==
//                                                       "events") {
//                                                     Get.find<
//                                                             InitialStatusController>()
//                                                         .getEventById(
//                                                             eventId:
//                                                                 notificationdetail
//                                                                     .id!)
//                                                         .then((value) async {
//                                                       Get.to(() => DetailScreen(
//                                                             eventdetail: Get.find<
//                                                                     InitialStatusController>()
//                                                                 .eventbyId
//                                                                 .first,
//                                                           ));
//                                                     });
//                                                   } else if (notificationdetail
//                                                           .type
//                                                           .toString()
//                                                           .toLowerCase() ==
//                                                       "trips") {
//                                                     Get.find<
//                                                             InitialStatusController>()
//                                                         .getTripById(
//                                                             tripId:
//                                                                 notificationdetail
//                                                                     .id!)
//                                                         .then((value) async {
//                                                       Get.to(() =>
//                                                           TripDetailScreen(
//                                                             tripdetail: Get.find<
//                                                                     InitialStatusController>()
//                                                                 .tripbyId
//                                                                 .first,
//                                                           ));
//                                                     });
//                                                   }
//                                                 },
//                                                 child: Text(
//                                                   "Yes",
//                                                   style: TextStyle(
//                                                     fontSize: 14.v,
//                                                     color: appTheme.white,
//                                                     fontFamily: 'Inter',
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 15.h,
//                                               ),
//                                               Text(
//                                                 "No",
//                                                 style: TextStyle(
//                                                   fontSize: 14.v,
//                                                   color: appTheme.white
//                                                       .withOpacity(0.8),
//                                                   fontFamily: 'Inter',
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   : GestureDetector(
//                                       onTap: () {
//                                         if (notificationdetail.type == "book") {
//                                           _initialStatusController
//                                               .getBookById(
//                                                   bookId:
//                                                       notificationdetail.id!)
//                                               .then((val) {
//                                             _initialStatusController.getPdfPath(
//                                                 "${EnvironmentConstants.baseUrlforimage}${_initialStatusController.bookbyId.first.book}");
//                                           });
//                                         } else if (notificationdetail.type ==
//                                             "project") {
//                                           Get.find<InitialStatusController>()
//                                               .getProjectById(
//                                                   projectId:
//                                                       notificationdetail.id!)
//                                               .then((value) async {
//                                             Get.to(() => ProjectDetailScreen(
//                                                   projectdetail: Get.find<
//                                                           InitialStatusController>()
//                                                       .groupbyId
//                                                       .first,
//                                                 ));
//                                           });
//                                         }
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 7),
//                                         margin:
//                                             const EdgeInsets.only(bottom: 10),
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: appTheme.gray400),
//                                             borderRadius:
//                                                 BorderRadius.circular(10.h)),
//                                         width: 348.v,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             // Row(
//                                             //   mainAxisAlignment:
//                                             //       MainAxisAlignment.end,
//                                             //   children: [
//                                             //     Container(
//                                             //       width: 8.v,
//                                             //       height: 8.h,
//                                             //       decoration: const BoxDecoration(
//                                             //           shape: BoxShape.circle,
//                                             //           color: Colors.green),
//                                             //     ),
//                                             //   ],
//                                             // ),
//                                             SizedBox(
//                                               width: 244.v,
//                                               child: Text(
//                                                 notificationdetail.title,
//                                                 style: TextStyle(
//                                                   fontSize: 14.v,
//                                                   color: appTheme.blackText,
//                                                   fontFamily: 'Inter',
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 5.h,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   // "December 23, 2019 at 6:00 pm",
//                                                   // notificationdetail.createdAt,
//                                                   DateFormat(
//                                                           'MMMM d, yyyy \'at\' h:mm a')
//                                                       .format(DateTime.parse(
//                                                               notificationdetail
//                                                                   .createdAt)
//                                                           .toLocal()),
//                                                   style: TextStyle(
//                                                     fontSize: 12.v,
//                                                     color: appTheme.blackText,
//                                                     fontFamily: 'Inter',
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                             }),
//                       ))
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return CustomAppBar(
//       leadingWidth: 40.h,
//       centerTitle: true,
//       leading: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: CustomImageView(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           imagePath: ImageConstant.back,
//           height: 10.h,
//           width: 10.h,
//         ),
//       ),
//       title: AppbarTitle(
//         text: "Notifications",
//       ),
//       styleType: Style.bgFill,
//     );
//   }
// }


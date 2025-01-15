import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/model/ProjectModel.dart';
import 'package:islamic_event_admin/screen/details/donation_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../../api-handler/env_constants.dart';
import '../../controller/initialStatuaController.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({
    super.key,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _initialStatusController.allprojectlist.clear();
    _initialStatusController.getallproject();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        // print("You have reached the end of the list");

        if (_initialStatusController.isMoreDataAvailableProject.value &&
            !_initialStatusController.isLoadingProject.value) {
          EasyLoading.show();
          _initialStatusController.getallproject(
              page: _initialStatusController.currentPageProject.value + 1);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
            // horizontal: 20.h,
            ),
        child: Obx(
          () => _initialStatusController.projectnf.value == true &&
                  _initialStatusController.allprojectlist.isEmpty
              ? SizedBox(
                  height: 500.h,
                  child: const Center(
                    child: Text("Not Available"),
                  ),
                )
              : _initialStatusController.allprojectlist.isEmpty
                  ? buildShimmerEffectColumn(height: 190.h, length: 3)
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _initialStatusController.allprojectlist.length,
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.h,
                      ),
                      itemBuilder: (context, index) {
                        ProjectModel project =
                            _initialStatusController.allprojectlist[index];
                        return Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.find<InitialStatusController>()
                                          .getProjectById(projectId: project.id)
                                          .then((value) async {
                                        Get.to(() => ProjectDetailScreen(
                                              projectdetail: Get.find<
                                                      InitialStatusController>()
                                                  .groupbyId
                                                  .first,
                                            ));
                                      });
                                      // Get.to(() => const DonationDetailScreen());
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      height: 157.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.v),
                                          color:
                                              theme.colorScheme.surfaceBright),
                                      child: CustomImageView(
                                        fit: BoxFit.fill,
                                        imagePath: project.images.isEmpty
                                            ? ImageConstant.event
                                            : "${EnvironmentConstants.baseUrlforimage}${project.images.first}",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 244.v,
                                                child: Text(
                                                  project.title,
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
                                                imagePath:
                                                    ImageConstant.calendartime,
                                                color: appTheme.blackText,
                                              ),
                                              SizedBox(width: 4.v),
                                              Text(
                                                // "November 15 2024",
                                                Get.find<
                                                        InitialStatusController>()
                                                    .formatDate(DateTime.parse(
                                                        project.createdAt)),

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
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Project'),
                                                content: const Text(
                                                    'Are you sure you want to delete?'),
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
                                                      Get.back();
                                                      _initialStatusController
                                                          .deleteProject(
                                                              project.id);
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            )
                          ],
                        );
                      }),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      centerTitle: true,
      title: AppbarTitle(
        text: "Projekter",
      ),
      styleType: Style.bgFill,
    );
  }
}

Widget buildShimmerEffectColumn({required double height, required int length}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      shrinkWrap: true,

      itemCount: length, // Number of shimmering items
      itemBuilder: (context, index) {
        return Container(
          height: height,
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder5,
              color: appTheme.gray100),
        );
      },
    ),
  );
}

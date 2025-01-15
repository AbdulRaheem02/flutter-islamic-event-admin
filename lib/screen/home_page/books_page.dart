import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:islamic_event_admin/api-handler/env_constants.dart';
import 'package:islamic_event_admin/controller/initialStatuaController.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:islamic_event_admin/custom_widgets/toast.dart';
import 'package:islamic_event_admin/model/BookModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path_provider/path_provider.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    super.key,
  });

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _initialStatusController.allbooklist.clear();
    // TODO: implement initState
    _initialStatusController.getallbook();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (!isTop) {
        // print("You have reached the end of the list");

        if (_initialStatusController.isMoreDataAvailableBook.value &&
            !_initialStatusController.isLoadingBook.value) {
          EasyLoading.show();
          _initialStatusController.getallbook(
              page: _initialStatusController.currentPageBook.value + 1);
        }
      }
    }
  }

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
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Text(
                  "Islamic Bøger",
                  style: TextStyle(
                    fontSize: 15.v,
                    color: appTheme.blackheading,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Obx(() => _initialStatusController.booknf.value == true &&
                    _initialStatusController.allbooklist.isEmpty
                ? SizedBox(
                    height: 500.h,
                    child: const Center(
                      child: Text("Not Available"),
                    ),
                  )
                : _initialStatusController.allbooklist.isEmpty
                    ? _buildShimmerEffectleaderboard()
                    : Expanded(
                        child: GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.h,
                              crossAxisSpacing: 10.v,
                              childAspectRatio:
                                  0.7, // Adjust this to fit your design
                            ),
                            itemCount: _initialStatusController.allbooklist
                                .length, // Replace with the number of items you want
                            itemBuilder: (context, index) {
                              BookModel book =
                                  _initialStatusController.allbooklist[index];
                              return SizedBox(
                                width: 348.v,
                                child: GestureDetector(
                                  onTap: () {
                                    _initialStatusController.getPdfPath(
                                        "${EnvironmentConstants.baseUrlforimage}${book.book}",
                                        book.title);
                                  },
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          Container(
                                            width: 140.v,
                                            height: 190.h,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.v),
                                                color:
                                                    appTheme.lightbackground),
                                            child: CustomImageView(
                                              imagePath: book.bookImage == null
                                                  ? ImageConstant.book
                                                  : "${EnvironmentConstants.baseUrlforimage}${book.bookImage}",
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Book'),
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
                                                          onPressed: () async {
                                                            Get.back();
                                                            _initialStatusController
                                                                .deleteBook(
                                                                    book.id);
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
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
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
                                          Text(
                                            book.title,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 13.v,
                                              color: appTheme.blackheading,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
      title: AppbarTitle(
        text: "Bøger",
      ),
      styleType: Style.bgFill,
    );
  }

  Widget _buildShimmerEffectleaderboard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.v,
          childAspectRatio: 0.7, // Adjust this to fit your design
        ),
        itemCount: 4, // Number of shimmering items
        itemBuilder: (context, index) {
          return Container(
            height: 90.h,
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
            padding: EdgeInsets.symmetric(
              // horizontal: 34.h,
              vertical: 15.v,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusStyle.roundedBorder5,
                color: appTheme.gray100),
          );
        },
      ),
    );
  }
}

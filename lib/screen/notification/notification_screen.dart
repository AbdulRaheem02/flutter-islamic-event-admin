import 'package:islamic_event_admin/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';

import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10.h)),
              width: 348.v,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 8.v,
                        height: 8.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 244.v,
                    child: Text(
                      "Will you attend this event?",
                      style: TextStyle(
                        fontSize: 12.v,
                        color: appTheme.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Event Name",
                        style: TextStyle(
                          fontSize: 14.v,
                          color: appTheme.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: 14.v,
                          color: appTheme.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 15.h,
                      ),
                      Text(
                        "No",
                        style: TextStyle(
                          fontSize: 14.v,
                          color: appTheme.white.withOpacity(0.8),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: appTheme.gray400),
                          borderRadius: BorderRadius.circular(10.h)),
                      width: 348.v,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 8.v,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 244.v,
                            child: Text(
                              """Your trip has been booked
successfully""",
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
                                "December 23, 2019 at 6:00 pm",
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
                    );
                  }),
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

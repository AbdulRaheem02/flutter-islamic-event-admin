import 'package:islamic_event_admin/core/app_export.dart';
import 'package:flutter/material.dart';

class EventNotFound extends StatelessWidget {
  const EventNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Center(
          child: CustomImageView(
            imagePath: ImageConstant.eventNotFound,
          ),
        ),
        Text(
          "No Upcoming Event",
          style: TextStyle(
            fontSize: 22.v,
            color: appTheme.blackText,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "No Result Show ",
          style: TextStyle(
            fontSize: 15.v,
            color: appTheme.gray500,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

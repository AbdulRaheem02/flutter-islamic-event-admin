import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:islamic_event_admin/screen/home_page/addBook.dart';
import 'package:islamic_event_admin/screen/home_page/add_event_trips_project.dart';
import 'package:islamic_event_admin/screen/home_page/addmentor.dart';
import 'package:islamic_event_admin/widgets/app_bar/appbar_title.dart';

import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white,
      appBar: _buildAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.v),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.to(() => AddEvent(
                      isEvent: true,
                    ));
              },
              title: Text(
                "Add Events",
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: appTheme.black900,
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.add),
            ),
            const Divider(
              color: Color.fromARGB(255, 160, 162, 165),
            ),
            ListTile(
              onTap: () {
                Get.to(() => AddEvent(
                      isTrip: true,
                    ));
              },
              title: Text(
                "Add Ture",
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: appTheme.black900,
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.add),
            ),
            const Divider(
              color: Color.fromARGB(255, 160, 162, 165),
            ),
            ListTile(
              onTap: () {
                Get.to(() => AddEvent(isProject: true));
              },
              title: Text(
                "Add Projekter",
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: appTheme.black900,
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.add),
            ),
            const Divider(
              color: Color.fromARGB(255, 160, 162, 165),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const AddMentor());
              },
              title: Text(
                "Add Mentor",
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: appTheme.black900,
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.add),
            ),
            const Divider(
              color: Color.fromARGB(255, 160, 162, 165),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const AddBook());
              },
              title: Text(
                "Add Bøger",
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: appTheme.black900,
                    fontSize: 15.fSize,
                    fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.add),
            ),
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
        text: "More",
      ),
      styleType: Style.bgFill,
    );
  }
}

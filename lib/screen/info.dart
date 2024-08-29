// ignore_for_file: avoid_unnecessary_containers, unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart' hide Trans;

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../core/app_export.dart';

class infoPage extends StatefulWidget {
  const infoPage({super.key});

  @override
  State<infoPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<infoPage> {
  String message = 'Check out this cool content!';

  void _shareToYoutube(String message) async {
    // YouTube also doesn't have a direct URL scheme for sharing. Use general sharing.
    Share.share(message);
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: 'https://example.com'))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Link copied to clipboard'),
      ));
    });
  }

  final String loremText =
      " Prophetic Path er en international organisation, der formidler budskabet om Islam igennem Koranen og Profeten Muhammad ﷺ Sunnah. ";
  bool isExpanded = false;

  void _toggleReadMore() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _openLink(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.v),
      width: double.infinity,
      // height: 400.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 5.h,
          ),
          Container(
            height: 5.h,
            width: 30.v,
            decoration: BoxDecoration(
                color: appTheme.gray100,
                borderRadius: BorderRadius.circular(10.h)),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            """About PROPHETIC PATH
            DANMARK""",
            style: TextStyle(
              fontSize: 20.v,
              color: appTheme.black900,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            // isExpanded ?
            loremText,
            // : '${loremText.substring(0, 150)}...',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 15.v,
              color: appTheme.blackText,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          // TextButton(
          //   onPressed: _toggleReadMore,
          //   child: Text(isExpanded ? 'Read Less' : 'Read More'),
          // ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CustomImageView(
                    onTap: () => _openLink(
                        "https://www.facebook.com/propheticpathdanmark"),
                    imagePath: ImageConstant.facebook,
                    height: 60.h,
                  ),
                ],
              ),
              Column(
                children: [
                  CustomImageView(
                    onTap: () => _openLink(
                        "https://www.instagram.com/propheticpath_dk?igsh=MXJ2c2sycXg1aGdwbQ%3D%3D&utm_source=qr"),
                    imagePath: ImageConstant.instagram,
                    height: 60.h,
                  ),
                ],
              ),
              Column(
                children: [
                  CustomImageView(
                    onTap: () => _openLink(
                        "https://youtube.com/@propheticpathdanmark?si=NUDU33wqswAV7qyx"),
                    imagePath: ImageConstant.youtube,
                    height: 40.h,
                  ),
                ],
              ),
              Column(
                children: [
                  CustomImageView(
                    onTap: () => _openLink(
                        "https://www.tiktok.com/@propheticpath?_t=8pByV34EiTw&_r=1"),
                    imagePath: ImageConstant.tiktok,
                    height: 40.h,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Text(
                """Share with friends""",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.v,
                  color: appTheme.black900,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),

          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () => _copyLink(context),
                    icon: const Icon(Icons.copy),
                  ),
                  Text(
                    "Copy Link",
                    style: TextStyle(
                      fontSize: 13.v,
                      color: appTheme.black900,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10.v,
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () => _shareToYoutube(message),
                    icon: const Icon(Icons.share),
                  ),
                  Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 13.v,
                      color: appTheme.black900,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    ));
  }
}

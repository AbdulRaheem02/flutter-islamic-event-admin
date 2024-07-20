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
  void _shareToFacebook(String message) async {
    final url =
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(message)}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareToWhatsapp(String message) async {
    final url = 'whatsapp://send?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareToMessenger(String message) async {
    final url = 'fb-messenger://share?link=${Uri.encodeComponent(message)}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareToTwitter(String message) async {
    final url =
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareToInstagram(String message) async {
    // Instagram sharing might need an image or video
    final url = 'instagram://share?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      // Fallback to general sharing if the scheme doesn't work
      Share.share(message);
    }
  }

  void _shareToTiktok(String message) async {
    // TikTok doesn't have a direct URL scheme for sharing. Use general sharing.
    Share.share(message);
  }

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
      "Lorem ipsum dolor sit amet consectetur. Iaculis diam nec arcu ultricies. Lorem ipsum dolor sit amet consectetur. Iaculis diam nec arcu ultricies. Lorem ipsum dolor sit amet consectetur. Iaculis diam nec arcu ultricies. Lorem ipsum dolor sit amet consectetur. Iaculis diam nec arcu ultricies. ";
  bool isExpanded = false;

  void _toggleReadMore() {
    setState(() {
      isExpanded = !isExpanded;
    });
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
            isExpanded ? loremText : '${loremText.substring(0, 150)}...',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16.v,
              color: appTheme.blackText,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),

          TextButton(
            onPressed: _toggleReadMore,
            child: Text(isExpanded ? 'Read Less' : 'Read More'),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Column(
          //       children: [
          //         CustomImageView(
          //           onTap: () => _shareToFacebook(message),
          //           imagePath: ImageConstant.facebook,
          //         ),
          //   Text(
          //     "Facebook",
          //     style: TextStyle(
          //       fontSize: 13.v,
          //       color: appTheme.black900,
          //       fontFamily: 'Inter',
          //       fontWeight: FontWeight.w400,
          //     ),
          //   ),
          // ],
          //     ),
          //     Column(
          //       children: [
          //         Column(
          //           children: [
          //             CustomImageView(
          //               onTap: () => _shareToWhatsapp(message),
          //               imagePath: ImageConstant.whatsapp,
          //             ),
          //             Text(
          //               "Whatsapp",
          //               style: TextStyle(
          //                 fontSize: 13.v,
          //                 color: appTheme.black900,
          //                 fontFamily: 'Inter',
          //                 fontWeight: FontWeight.w400,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         CustomImageView(
          //           onTap: () => _shareToMessenger(message),
          //           imagePath: ImageConstant.messenger,
          //         ),
          //         Text(
          //           "Messenger",
          //           style: TextStyle(
          //             fontSize: 13.v,
          //             color: appTheme.black900,
          //             fontFamily: 'Inter',
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Column(
          //       children: [
          //         CustomImageView(
          //           onTap: () => _shareToTwitter(message),
          //           imagePath: ImageConstant.twitter,
          //         ),
          //         Text(
          //           "Twitter",
          //           style: TextStyle(
          //             fontSize: 13.v,
          //             color: appTheme.black900,
          //             fontFamily: 'Inter',
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         CustomImageView(
          //           onTap: () => _shareToInstagram(message),
          //           imagePath: ImageConstant.instagram,
          //         ),
          //         Text(
          //           "Instagram",
          //           style: TextStyle(
          //             fontSize: 13.v,
          //             color: appTheme.black900,
          //             fontFamily: 'Inter',
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Container(
          //           child: CustomImageView(
          //             onTap: () => _shareToTiktok(message),
          //             imagePath: ImageConstant.tiktok,
          //             height: 40.h,
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(top: 10.v),
          //           child: Text(
          //             "Tiktok",
          //             style: TextStyle(
          //               fontSize: 13.v,
          //               color: appTheme.black900,
          //               fontFamily: 'Inter',
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         CustomImageView(
          //           onTap: () => _shareToYoutube(message),
          //           imagePath: ImageConstant.youtube,
          //         ),
          //         Text(
          //           "Youtube",
          //           style: TextStyle(
          //             fontSize: 13.v,
          //             color: appTheme.black900,
          //             fontFamily: 'Inter',
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // )
        ],
      ),
    ));
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:islamic_event_admin/api-handler/api-extention.dart';
import 'package:islamic_event_admin/custom_widgets/InternalStorage.dart';
import 'package:islamic_event_admin/model/BookModel.dart';
import 'package:islamic_event_admin/model/MemberModel.dart';
import 'package:islamic_event_admin/model/NotificationModel.dart';
import 'package:islamic_event_admin/model/ProjectModel.dart';
import 'package:islamic_event_admin/model/UserProfileModel.dart';
import 'package:islamic_event_admin/screen/pdf/pdfScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Deo;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../api-handler/api-repo.dart';
import '../api-handler/env_constants.dart';
import 'package:path_provider/path_provider.dart';

import '../custom_widgets/toast.dart';
import '../model/EventModel.dart';

class InitialStatusController extends GetxController {
  ApiRepository apiRepository;
  InitialStatusController(this.apiRepository);
  var alleventlist = List<EventModel>.empty(growable: true).obs;
  var alltriplist = List<EventModel>.empty(growable: true).obs;

  var eventbyId = List<EventModel>.empty(growable: true).obs;
  var bookbyId = List<BookModel>.empty(growable: true).obs;

  var tripbyId = List<EventModel>.empty(growable: true).obs;

  var allprojectlist = List<ProjectModel>.empty(growable: true).obs;
  var groupbyId = List<ProjectModel>.empty(growable: true).obs;
  var allbooklist = List<BookModel>.empty(growable: true).obs;
  var allmemberlist = List<MemberModel>.empty(growable: true).obs;
  var allnotificationlist = List<NotificationModel>.empty(growable: true).obs;
  var booknf = false.obs;
  var projectnf = false.obs;
  var eventnf = false.obs;
  var tripnf = false.obs;
  var membernf = false.obs;
  var notificationnf = false.obs;
  TextEditingController locationEditTextController = TextEditingController();

  String latitude = "", longitude = "";
  @override
  Future<void> onInit() async {
    init();

    // getallproject();
    // getallbook();
    super.onInit();
  }

  Future<void> init() async {
    String token = await getAccessToken();

    // clearEveryThing();
    Get.log("token = $token");
    if (token != "") {
      await getprofiledetail();
      getallevent();
      getalltrip();
    }
  }

  var userProfile = List<UserProfile>.empty(growable: true).obs;
  void addEvent(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.addevent(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");
      }
    });
  }

  void addTrip(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.addtrip(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");
      }
    });
  }

  void addProject(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.addproject(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");
      }
    });
  }

  void addBook(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.addbook(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");
      }
    });
  }

  void addMentor(Map<String, dynamic> params) {
    EasyLoading.show();

    apiRepository.addMentor(params).getResponse((reponse) {
      EasyLoading.dismiss();

      print("response${reponse.statusCode}");
      if (reponse.statusCode == 200) {
        flutterToast("${reponse.data['message']}");
      }
    });
  }

  Future<void> getprofiledetail() async {
    userProfile.clear();
    Get.log("++++++++++ get api call");
    UserProfile? userProfiledata;

    await apiRepository.getprofiledetail().getResponse((response) async {
      if (response.statusCode == 200) {
        Get.log("save user profile = ${response.data}");
        userProfiledata = UserProfile.fromJson(response.data);
        Get.log("save user asds = $userProfiledata");

        Get.log("user profile = 2${userProfiledata!.data.toJson()}");
        userProfile.add(userProfiledata!);

        update();
      }
      update();
    });
  }

  Future<void> getallnotifications() async {
    allnotificationlist.clear();

    Get.log("++++++++++ get api call");
    notificationnf(false);
    apiRepository.getallnotification().getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");

        List listData = response.data['data'];
        var parsingList =
            listData.map((m) => NotificationModel.fromJson(m)).toList();
        allnotificationlist.clear();
        allnotificationlist.addAll(parsingList);
        notificationnf(true);
        update();
      }
    });
  }

  var currentPageBook = 1.obs;
  var isMoreDataAvailableBook = true.obs;
  var isLoadingBook = false.obs;
  Future<void> getallbook({int page = 1, int limit = 8}) async {
    if (page == 1) {
      currentPageBook = 1.obs;
      isMoreDataAvailableBook = true.obs;
      isLoadingBook = false.obs;
      booknf(false);
    } else {
      EasyLoading.show();
    }
    isLoadingBook.value = true;

    Get.log("++++++++++ get api call");

    apiRepository
        .getallbooks(page.toString(), limit.toString())
        .getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");

        List listData = response.data['data'];
        var parsingList = listData.map((m) => BookModel.fromJson(m)).toList();
        if (page == 1) {
          allbooklist.clear();
        }

        if (parsingList.isNotEmpty) {
          allbooklist.addAll(parsingList);
          currentPageBook.value = page;
        } else {
          isMoreDataAvailableBook(false);
        }

        EasyLoading.dismiss();

        booknf(true);
        isLoadingBook.value = false;

        update();
      }
    });
  }

  Future<void> getBookById({required String bookId}) async {
    EasyLoading.show();
    bookbyId.clear();
    BookModel book;
    await apiRepository.getbookById(bookId: bookId).getResponse((response) {
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        book = BookModel.fromJson(response.data["data"]);

        bookbyId.addAll([book]);

        update();
      }
    });
  }

  var currentPageMenotr = 1.obs;
  var isMoreDataAvailableMentor = true.obs;
  var isLoadingMentor = false.obs;

  var isExpandedList = List<bool>.empty(growable: true).obs;

  Future<void> getallmentor({int page = 1, int limit = 10}) async {
    if (page == 1) {
      currentPageMenotr = 1.obs;
      isMoreDataAvailableMentor = true.obs;
      isLoadingMentor = false.obs;
      membernf(false);
    } else {
      EasyLoading.show();
    }
    isLoadingMentor.value = true;
    Get.log("++++++++++ get api call");

    await apiRepository
        .getallmentors(page.toString(), limit.toString())
        .getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");

        List listData = response.data['data'];
        var parsingList = listData.map((m) => MemberModel.fromJson(m)).toList();
        if (page == 1) {
          allmemberlist.clear();
        }

        if (parsingList.isNotEmpty) {
          allmemberlist.addAll(parsingList);
          currentPageMenotr.value = page;
        } else {
          isMoreDataAvailableMentor(false);
        }

        EasyLoading.dismiss();

        membernf(true);
        isLoadingMentor.value = false;
        updateIsExpandedList();
        update();
      }
    });
  }

  void updateIsExpandedList() {
    isExpandedList.value = List.filled(allmemberlist.length, false);
  }

  whatsappLaunchURL(String phoneNumber) async {
    var url =
        'https://api.whatsapp.com/send/?phone=$phoneNumber&text&type=phone_number&app_absent=0';
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendSms(String phoneNumber, String message) async {
    // Android
    String url;
    //  'sms:+39 348 060 888?body=hello%20there';
    if (Platform.isAndroid) {
      //FOR Android
      url = 'sms:$phoneNumber?body=$message';
      await launch(url);
    } else if (Platform.isIOS) {
      //FOR IOS
      url = 'sms:$phoneNumber&body=$message';
    }
  }

  var currentPage = 1.obs;
  var isMoreDataAvailable = true.obs;
  var isLoading = false.obs;
  Future<void> getallevent({int page = 1, int limit = 5}) async {
    Get.log("++++++++++ get api call");
    if (page == 1) {
      currentPage = 1.obs;
      isMoreDataAvailable = true.obs;
      isLoading = false.obs;
      eventnf(false);
    } else {
      EasyLoading.show();
    }
    isLoading.value = true;
    apiRepository
        .getallevent(page.toString(), limit.toString())
        .getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        //  var resData = AllUser.fromJson(response.data);
        EasyLoading.dismiss();
        List listData = response.data['data'];
        var parsingList = listData.map((m) => EventModel.fromJson(m)).toList();
        if (page == 1) {
          alleventlist.clear();
        }

        if (parsingList.isNotEmpty) {
          alleventlist.addAll(parsingList);
          currentPage.value = page;
        } else {
          isMoreDataAvailable(false);
        }
        // alleventlist.clear();
        // alleventlist.addAll(parsingList);
        EasyLoading.dismiss();

        eventnf(true);
        update();
        isLoading.value = false;
      }
    });
  }

  var currentPageTrip = 1.obs;
  var isMoreDataAvailableTrip = true.obs;
  var isLoadingTrip = false.obs;

  Future<void> getalltrip({int page = 1, int limit = 5}) async {
    Get.log("++++++++++ get api call");
    if (page == 1) {
      currentPageTrip = 1.obs;
      isMoreDataAvailableTrip = true.obs;
      isLoadingTrip = false.obs;
      tripnf(false);
    } else {
      EasyLoading.show();
    }
    isLoadingTrip.value = true;
    apiRepository
        .getalltrip(page.toString(), limit.toString())
        .getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        //  var resData = AllUser.fromJson(response.data);
        List listData = response.data['data'];
        var parsingList = listData.map((m) => EventModel.fromJson(m)).toList();
        if (page == 1) {
          alltriplist.clear();
        }

        if (parsingList.isNotEmpty) {
          alltriplist.addAll(parsingList);
          currentPageTrip.value = page;
        } else {
          isMoreDataAvailableTrip(false);
        }
        EasyLoading.dismiss();

        tripnf(true);

        update();
      }
      isLoadingTrip.value = false;
    });
  }

  Future<void> getEventById({required String eventId}) async {
    EasyLoading.show();
    eventbyId.clear();
    EventModel event;
    await apiRepository.geteventById(eventId: eventId).getResponse((response) {
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        event = EventModel.fromJson(response.data["data"]);

        eventbyId.addAll([event]);

        update();
      }
    });
  }

  Future<void> getTripById({required String tripId}) async {
    EasyLoading.show();
    tripbyId.clear();
    EventModel event;
    await apiRepository.gettripById(tripId: tripId).getResponse((response) {
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        event = EventModel.fromJson(response.data["data"]);

        tripbyId.addAll([event]);

        update();
      }
    });
  }

  var currentPageProject = 1.obs;
  var isMoreDataAvailableProject = true.obs;
  var isLoadingProject = false.obs;
  Future<void> getallproject({int page = 1, int limit = 5}) async {
    Get.log("++++++++++ get api call");

    if (page == 1) {
      currentPageProject = 1.obs;
      isMoreDataAvailableProject = true.obs;
      isLoadingProject = false.obs;
      projectnf(false);
    } else {
      EasyLoading.show();
    }
    // isLoadingProject.value = true;
    apiRepository
        .getallproject(page.toString(), limit.toString())
        .getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        List listData = response.data['data'];
        var parsingList =
            listData.map((m) => ProjectModel.fromJson(m)).toList();
        if (page == 1) {
          allprojectlist.clear();
        }

        if (parsingList.isNotEmpty) {
          allprojectlist.addAll(parsingList);
          currentPageProject.value = page;
        } else {
          isMoreDataAvailableProject(false);
        }
        EasyLoading.dismiss();

        projectnf(true);
        update();
      }
    });
  }

  Future<void> getProjectById({required String projectId}) async {
    EasyLoading.show();
    groupbyId.clear();
    ProjectModel event;
    await apiRepository
        .getprojectById(projectId: projectId)
        .getResponse((response) {
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        event = ProjectModel.fromJson(response.data["data"]);

        groupbyId.addAll([event]);

        update();
      }
    });
  }

  Future<String> getPdfPath(String filepath) async {
    EasyLoading.show();
    Completer<File> completer = Completer();
    final url = filepath.toString();
    Get.log(url);
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    Get.log("Download files");
    Get.log("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    EasyLoading.dismiss();
    Get.to(() => PDFScreen(
          path: file.path,
        ));

    completer.complete(file);
    return file.path;
  }

  // String formatDate(DateTime date) {
  //   // Create a DateFormat instance with the desired format
  //   final DateFormat formatter = DateFormat('MMM dd yyyy');

  //   // Format the date using the DateFormat instance
  //   return formatter.format(date);
  // }
  String formatDate(DateTime date) {
    // Create a DateFormat instance with the desired format
    final DateFormat formatter = DateFormat('MMM dd yyyy');

    // Format the date using the DateFormat instance
    return formatter.format(date);
  }

  String parseAndFormatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime date = DateFormat('yyyy-MM-dd hh:mm a').parse(dateString);

    // Format the date using the formatDate function
    return formatDate(date);
  }

  String formatDateTime(DateTime startTime, DateTime endTime) {
    final startDateFormat = DateFormat('EEEE, h:mma');
    final endDateFormat = DateFormat('h:mma');

    final startDay = startDateFormat.format(startTime);
    final endTimeFormatted = endDateFormat.format(endTime);

    return '$startDay - $endTimeFormatted';
  }

  DateTime parseDateTime(String dateTimeString) {
    final DateFormat format = DateFormat("yyyy-MM-dd h:mm a");
    return format.parse(dateTimeString);
  }

  var thumbnail = "".obs;
  Future<void> generateThumbnail(String videourl) async {
    final directory = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videourl,
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 50,
    );
    // setState(() {
    thumbnail(thumbnailPath);
    // });
  }

  Future<void> deleteEvent(String id) async {
    EasyLoading.show();
    await apiRepository.deleteEvent(id).getResponse((reponse) {
      getallevent();
      EasyLoading.dismiss();
      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> deleteTrip(String id) async {
    EasyLoading.show();

    await apiRepository.deleteTrip(id).getResponse((reponse) {
      getalltrip();
      EasyLoading.dismiss();

      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> deleteProject(String id) async {
    EasyLoading.show();

    await apiRepository.deleteProject(id).getResponse((reponse) {
      getallproject();
      EasyLoading.dismiss();

      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> deleteMentor(String id) async {
    EasyLoading.show();

    await apiRepository.deleteMentor(id).getResponse((reponse) {
      getallmentor();
      EasyLoading.dismiss();

      flutterToast("${reponse.data['message']}");
    });
  }

  Future<void> deleteBook(String id) async {
    EasyLoading.show();

    await apiRepository.deleteBook(id).getResponse((reponse) {
      getallbook();
      EasyLoading.dismiss();

      flutterToast("${reponse.data['message']}");
    });
  }
}

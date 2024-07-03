import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:islamic_event_admin/api-handler/api-extention.dart';
import 'package:islamic_event_admin/custom_widgets/toast.dart';
import 'package:islamic_event_admin/model/ProjectModel.dart';
import 'package:islamic_event_admin/screen/pdf/pdfScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as Deo;
import 'package:intl/intl.dart';

import '../api-handler/api-repo.dart';
import '../api-handler/env_constants.dart';
import 'package:path_provider/path_provider.dart';

import '../model/EventModel.dart';

class InitialStatusController extends GetxController {
  ApiRepository apiRepository;
  InitialStatusController(this.apiRepository);
  var alleventlist = List<EventModel>.empty(growable: true).obs;
  var eventbyId = List<EventModel>.empty(growable: true).obs;

  var allprojectlist = List<ProjectModel>.empty(growable: true).obs;
  var groupbyId = List<ProjectModel>.empty(growable: true).obs;
  TextEditingController locationEditTextController = TextEditingController();

  String latitude = "", longitude = "";
  @override
  void onInit() {
    // getallevent();
    // getallproject();

    super.onInit();
  }

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

  Future<void> getallevent() async {
    Get.log("++++++++++ get api call");

    apiRepository.getallevent().getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        //  var resData = AllUser.fromJson(response.data);
        List listData = response.data['data'];
        var parsingList = listData.map((m) => EventModel.fromJson(m)).toList();
        alleventlist.clear();
        alleventlist.addAll(parsingList);
        update();
      }
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
        print(event);

        eventbyId.addAll([event]);

        update();
      }
    });
  }

  Future<void> getallproject() async {
    Get.log("++++++++++ get api call");

    apiRepository.getallproject().getResponse((response) {
      if (response.statusCode == 200) {
        Get.log("++++++++++ ${response.data}");
        List listData = response.data['data'];
        var parsingList =
            listData.map((m) => ProjectModel.fromJson(m)).toList();
        allprojectlist.clear();
        allprojectlist.addAll(parsingList);
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
        print(event);

        groupbyId.addAll([event]);

        update();
      }
    });
  }

  Future<String> getPdfPath(String filepath) async {
    EasyLoading.show();
    Completer<File> completer = Completer();
    final url = filepath.toString();
    print(url);
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    print("Download files");
    print("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    EasyLoading.dismiss();
    Get.to(() => PDFScreen(
          path: file.path,
        ));

    completer.complete(file);
    return file.path;
  }

  String formatDate(DateTime date) {
    // Create a DateFormat instance with the desired format
    final DateFormat formatter = DateFormat('MMM dd yyyy');

    // Format the date using the DateFormat instance
    return formatter.format(date);
  }
}

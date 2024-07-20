import 'package:islamic_event_admin/controller/authController.dart';
import 'package:get/get.dart';
import 'package:islamic_event_admin/api-handler/api-handler.dart';
import 'package:islamic_event_admin/api-handler/api-repo.dart';

import '../controller/initialStatuaController.dart';

void setIntialSetup() {
  Get.put(ApiBaseHelper());
  Get.put(ApiRepository(Get.find()));
  // Get.put(InitialStatusController(Get.find()));

  Get.put(AuthController(Get.find()));
}

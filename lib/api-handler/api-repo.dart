import 'package:islamic_event_admin/api-handler/api-extention.dart';
import 'package:islamic_event_admin/custom_widgets/InternalStorage.dart';

import '../constant/api_constants.dart';
import 'api-handler.dart';

class ApiRepository {
  ApiRepository(this._apiHelper);

  final ApiBaseHelper _apiHelper;

  ///// Get user Data
  ///
  Future getUserData() async {
    return _apiHelper
        .get(
          ApiConstant.getuserlist,
        )
        .execute((response) => response);
  }

  Future getallevent() async {
    return _apiHelper
        .get(ApiConstant.getAllEvents)
        .execute((response) => response);
  }

  Future geteventById({required String eventId}) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getEventById, "/$eventId")
        .execute((response) => response);
  }

  Future getallproject() async {
    return _apiHelper
        .get(ApiConstant.getAllProjects)
        .execute((response) => response);
  }

  Future getprojectById({required String projectId}) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getProjectById, "/$projectId")
        .execute((response) => response);
  }

  Future registeruser(Map<String, dynamic> params) async {
    return _apiHelper
        .post(ApiConstant.registeruser, params)
        .execute((response) => response);
  }

  Future loginuser(Map<String, dynamic> params) async {
    return _apiHelper
        .post(ApiConstant.loginuser, params)
        .execute((response) => response);
  }

  Future forgetpassword(Map<String, dynamic> params) async {
    return _apiHelper
        .patchWithParams(ApiConstant.forgetPassword, params)
        .execute((response) => response);
  }

  Future resendOtp(Map<String, dynamic> params) async {
    return _apiHelper
        .patchWithParams(ApiConstant.resendOtp, params)
        .execute((response) => response);
  }

  Future verifyForgotPasswordOtp(Map<String, dynamic> params) async {
    return _apiHelper
        .patchWithParams(ApiConstant.verifyForgotPasswordOtp, params)
        .execute((response) => response);
  }

  Future resetPassword(Map<String, dynamic> params) async {
    return _apiHelper
        .patchWithParams(ApiConstant.resetPassword, params)
        .execute((response) => response);
  }

  //admin
  Future addbook(Map<String, dynamic> params) async {
    return _apiHelper
        .post(ApiConstant.createBook, params)
        .execute((response) => response);
  }

  Future addMentor(Map<String, dynamic> params) async {
    return _apiHelper
        .post(ApiConstant.createMember, params)
        .execute((response) => response);
  }

  // Future addevent(Map<String, dynamic> params) async {
  //   return _apiHelper
  //       .post(ApiConstant.createEvent, params)
  //       .execute((response) => response);
  // }

  Future addevent(Map<String, dynamic> params) async {
    String token = await getAccessToken();
    return _apiHelper
        .postWithparamAndauth(ApiConstant.createEvent, params, token)
        .execute((response) => response);
  }

  Future addtrip(Map<String, dynamic> params) async {
    String token = await getAccessToken();
    return _apiHelper
        .postWithparamAndauth(ApiConstant.createTrip, params, token)
        .execute((response) => response);
  }

  Future addproject(Map<String, dynamic> params) async {
    String token = await getAccessToken();
    return _apiHelper
        .postWithparamAndauth(ApiConstant.createProject, params, token)
        .execute((response) => response);
  }
}

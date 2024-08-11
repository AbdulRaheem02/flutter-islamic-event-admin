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

  Future getallevent(String page, String limit) async {
    return _apiHelper
        // .get(ApiConstant.getAllEvents)
        .getWithParamUrl(ApiConstant.getAllEvents, "?page=$page&limit=$limit")
        .execute((response) => response);
  }

  Future getalltrip(String page, String limit) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getAllTrips, "?page=$page&limit=$limit")
        .execute((response) => response);
  }

  Future getallbooks(String page, String limit) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getAllBooks, "?page=$page&limit=$limit")
        .execute((response) => response);
  }

  Future getallnotification() async {
    String token = await getAccessToken();
    return _apiHelper
        .getWithauthParamUrl(ApiConstant.getAllNotifications, token)
        .execute((response) => response);
  }

  Future getallmentors(String page, String limit) async {
    return _apiHelper
        // .get(ApiConstant.getAllMentor)
        .getWithParamUrl(ApiConstant.getAllMentor, "?page=$page&limit=$limit")
        .execute((response) => response);
  }

  Future geteventById({required String eventId}) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getEventById, "/$eventId")
        .execute((response) => response);
  }

  Future getbookById({required String bookId}) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getBookById, "/$bookId")
        .execute((response) => response);
  }

  Future gettripById({required String tripId}) async {
    return _apiHelper
        .getWithParamUrl(ApiConstant.getTripById, "/$tripId")
        .execute((response) => response);
  }

  Future getallproject(String page, String limit) async {
    return _apiHelper
        // .get(ApiConstant.getAllProjects)
        .getWithParamUrl(ApiConstant.getAllProjects, "?page=$page&limit=$limit")
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

  Future getprofiledetail() async {
    String token = await getAccessToken();
    return _apiHelper
        .getwithauthwithoutparam(ApiConstant.getprofiledetail, token)
        .execute((response) => response);
  }

  Future createuser(Map<String, dynamic> params) async {
    return _apiHelper
        .post(
          ApiConstant.createCustomer,
          params,
        )
        .execute((response) => response);
  }

  Future payment(Map<String, dynamic> params) async {
    return _apiHelper
        .post(
          ApiConstant.payment,
          params,
        )
        .execute((response) => response);
  }

  Future going(Map<String, dynamic> params) async {
    String token = await getAccessToken();
    return _apiHelper
        .postWithparamAndauth(ApiConstant.userGoing, params, token)
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

  Future deleteEvent(String id) async {
    return _apiHelper
        .patchWithAdditionalUrl(ApiConstant.deleteEvent, "/$id")
        .execute((response) => response);
  }

  Future deleteTrip(String id) async {
    return _apiHelper
        .patchWithAdditionalUrl(ApiConstant.deleteTrip, "/$id")
        .execute((response) => response);
  }

  Future deleteProject(String id) async {
    return _apiHelper
        .patchWithAdditionalUrl(ApiConstant.deleteProject, "/$id")
        .execute((response) => response);
  }

  Future deleteMentor(String id) async {
    return _apiHelper
        .patchWithAdditionalUrl(ApiConstant.deleteMentor, "/$id")
        .execute((response) => response);
  }

  Future deleteBook(String id) async {
    return _apiHelper
        .patchWithAdditionalUrl(ApiConstant.deleteBook, "/$id")
        .execute((response) => response);
  }
}

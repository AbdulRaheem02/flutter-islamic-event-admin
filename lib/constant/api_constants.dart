/// This class defines all Api EndPoints
library;
// ignore_for_file: constant_identifier_names

class ApiConstant {
  //Api Time out
  static const int TIMEOUT = 1000000;

  static const getuserlist = "users";
  static const registeruser = "register";
  static const loginuser = "login";
  static const forgetPassword = "forgetPasswordOtp";
  static const resendOtp = "resendOtp";
  static const verifyForgotPasswordOtp = "verifyForgotPasswordOtp";
  static const resetPassword = "resetPassword";
  static const getAllEvents = "getAllEvents";
  static const getEventById = "getEventById";
  static const getAllProjects = "getAllProjects";
  static const getProjectById = "getEventById";

  //Admin
  static const createBook = "createBook";
  static const createEvent = "createEvent";
  static const createProject = "createProject";
  static const createTrip = "createTrip";

  static const createMember = "createMember";
}

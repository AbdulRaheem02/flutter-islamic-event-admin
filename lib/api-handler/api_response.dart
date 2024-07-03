// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import '../constant/string_constants.dart';

enum ApiStatus { LOADING, COMPLETED, ERROR }

/// Wrapper class for API response
class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final int? statusCode;
  final ApiError? error;

  ApiResponse({required this.status, this.data, this.statusCode, this.error});

  factory ApiResponse.loading() => ApiResponse(status: ApiStatus.LOADING);

  factory ApiResponse.success(T data, [int? statusCode]) => ApiResponse(
        status: ApiStatus.COMPLETED,
        data: data,
        statusCode: statusCode,
      );

  factory ApiResponse.error(ApiError error) => ApiResponse(
        status: ApiStatus.ERROR,
        error: error,
      );

  factory ApiResponse.fromResponse(Response response) {
    if (response.statusCode == ApiResponseCode.INTERNET_UNAVAILABLE) {
      return ApiResponse.error(ApiError(
        code: response.statusCode,
        message: StringConstants.NO_INTERNET_CONNECTION,
      ));
    } else if (response.statusCode == ApiResponseCode.SUCCESS_201 ||
        response.statusCode == ApiResponseCode.SUCCESS_200) {
      return ApiResponse.success(response.data, response.statusCode);
    } else {
      return ApiResponse.error(ApiError(
        code: response.statusCode,
        message: response.statusMessage ?? StringConstants.SOMETHING_WENT_WRONG,
        body: response.data,
      ));
    }
  }

  @override
  String toString() {
    return "Status : $status \n Message : ${error?.message} \n Data : $data";
  }
}

/// Class to store API error details
class ApiError {
  final int? code;
  final String? message;
  final dynamic body;

  ApiError({this.code, this.message, this.body});
}

class ApiResponseCode {
  static const int INTERNET_UNAVAILABLE = 503; // Service Unavailable
  static const int SUCCESS_200 = 200; // OK
  static const int SUCCESS_201 = 201; // Created
  static const int ERROR_400 = 400; // Bad Request
  static const int ERROR_499 = 499; // Client Closed Request (used for range)
  static const int ERROR_500 = 500; // Internal Server Error
}

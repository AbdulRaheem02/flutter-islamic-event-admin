// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, constant_identifier_names, library_prefixes, depend_on_referenced_packages

import 'dart:async';
// import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:islamic_event_admin/constant/api_constants.dart';
import 'env_constants.dart';
import 'logging_interceptor.dart';

// ... [Other imports]

class ApiBaseHelper {
  Dio? _dio;
  ApiBaseHelper() {
    debugPrint('apibase helper created');
    var options = BaseOptions(
      receiveTimeout: const Duration(seconds: ApiConstant.TIMEOUT),
      connectTimeout: const Duration(seconds: ApiConstant.TIMEOUT),
      baseUrl: EnvironmentConstants.setEnvironment(Environment.DEV),
      responseType: ResponseType.json,
    );
    _dio = Dio(options);
    _dio?.interceptors.add(LoggingInterceptors());
  }

  Future<Response> _request(String method, String url,
      {Map<String, dynamic>? data,
      bool? formdata,
      Map<String, dynamic>? params,
      String? auth}) async {
    if (auth != null) {
      _dio?.options.headers["Authorization"] = "Bearer $auth";
    }
    print("params ${params}");
    switch (method) {
      case 'GET':
        return await _dio!.get(url, queryParameters: params);
      // case 'POST':
      //   return await _dio!.post(url, data: data ?? params!);

      case 'POST':
        return await _dio!.post(url, data: data ?? FormData.fromMap(params!)!);

      case 'PUT':
        return await _dio!.put(url, data: data ?? FormData.fromMap(params!));
      case 'DELETE':
        return await _dio!
            .delete(url + (params != null ? params.toString() : ''));
      case 'PATCH':
        return await _dio!
            .patch(url, data: params != null ? FormData.fromMap(params!) : "");

      default:
        throw Exception('Unsupported method: $method');
    }
  }

  Future<Response> post(String url, Map<String, dynamic> params) =>
      _request('POST', url, params: params);
  Future<Response> getWithCustomURL(String url) => _request('GET', url);
  Future<Response> put(String url, Map<String, dynamic> params) =>
      _request('PUT', url, params: params);
  Future<Response> delete(String url, String params) =>
      _request('DELETE', url, params: {'param': params});
  Future<Response> get(String url) => _request('GET', url);
  Future<Response> getWithAccessToken(String url) =>
      _request('GET', url); // NOTE: Add access token logic here
  Future<Response> getwithauthwithoutparam(String url, String auth) =>
      _request('GET', url, auth: auth);
  Future<Response> getwithauthparam(
          String url, String auth, Map<String, dynamic> params) =>
      _request('GET', url, auth: auth, params: params);
  Future<Response> getWithParam(String url, Map<String, dynamic> params) =>
      _request('GET', url, params: params);
  Future<Response> postWithoutHeader(String url, Map<String, dynamic> params) =>
      _request('POST', url, params: params);
  Future<Response> postWithparamAndauth(
          String url, Map<String, dynamic> params, String auth) =>
      _request('POST', url, params: params, auth: auth);
  Future<Response> getWithParamUrl(String url, String additionalUrl) =>
      _request('GET', url + additionalUrl);
  Future<Response> getWithauthParamUrl(
          String url, String additionalUrl, String auth) =>
      _request('GET', url + additionalUrl, auth: auth);
  Future<Response> postWithAdditionalUrl(
          String url, Map<String, dynamic> params, String additionURL) =>
      _request('POST', url + additionURL, params: params);

  Future<Response> patchWithAdditionalUrl(String url, String additionURL) =>
      _request('PATCH', url + additionURL);
  Future<Response> patchwithoutparams(String url) => _request('PATCH', url);
  Future<Response> patchWithParams(
    String url,
    Map<String, dynamic> params,
  ) =>
      _request('PATCH', url, params: params);
}

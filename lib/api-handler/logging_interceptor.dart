// // ignore_for_file: avoid_print, avoid_renaming_method_parameters, unnecessary_null_comparison, dead_code_on_catch_subtype

// import 'dart:convert';
// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/instance_manager.dart';
// import 'package:get/route_manager.dart';

// import 'package:islamic_event_admin/api-handler/env_constants.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../custom_widgets/InternalStorage.dart';

// class LoggingInterceptors extends Interceptor {
//   final Dio? dio;

//   LoggingInterceptors({this.dio});

//   Future<bool> _isInternetConnected() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       Fluttertoast.showToast(
//           msg: EnvironmentConstants.internetNotAvailableMessage);
//       return false;
//     }
//     return true;
//   }

//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     if (await _isInternetConnected()) {
//       Get.log(
//           "--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}");
//       Get.log("Headers: ${options.headers}");
//       Get.log("QueryParameters: ${options.queryParameters}");
//       if (options.data != null) {
//         log("Body: ${options.data}");
//       }
//       Get.log("--> END ${options.method.toUpperCase()}");
//       handler.next(options);
//     } else {
//       handler.reject(
//           DioError(requestOptions: options, error: 'No Internet Connection'));
//     }
//   }

//   @override
//   void onError(DioError dioError, ErrorInterceptorHandler handler) {

//     Get.log(
//         "ERROR[${dioError.response?.statusCode}] => PATH: ${dioError.requestOptions.baseUrl}${dioError.requestOptions.path}");
//     Get.log("Error Message: ${dioError.message}");
//     if (dioError.response != null) {
//       EasyLoading.dismiss();
//       Get.log("Error Data: ${dioError.response?.data}");
//       Get.log("Error Code: ${dioError.response?.statusCode}");
//     }
//     handler.next(dioError);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     EasyLoading.dismiss();

//     Get.log(
//         "<-- ${response.statusCode} ${response.requestOptions.baseUrl}${response.requestOptions.path}");
//     Get.log("Headers: ${response.headers}");
//     Get.log(
//         "Response: ${const JsonEncoder.withIndent('  ').convert(response.data)}");
//     Get.log("<-- END HTTP");
//     handler.next(response);
//   }

// }
// ignore_for_file: avoid_print, avoid_renaming_method_parameters, unnecessary_null_comparison, dead_code_on_catch_subtype

import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_core/src/get_main.dart';

import '../custom_widgets/toast.dart';
import 'env_constants.dart';

class LoggingInterceptors extends Interceptor {
  final Dio? dio;
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to logPrint json response
  static const int kInitialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per logPrint
  final int maxWidth;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  /// Log printer; defaults logPrint log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  final void Function(Object object) logPrint;
  LoggingInterceptors(
      {this.dio,
      this.request = true,
      this.requestHeader = true,
      this.requestBody = true,
      this.responseHeader = false,
      this.responseBody = true,
      this.error = true,
      this.maxWidth = 90,
      this.compact = true,
      this.logPrint = print});

  Future<bool> _isInternetConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      flutterToast(EnvironmentConstants.internetNotAvailableMessage);
      return false;
    }
    return true;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (await _isInternetConnected()) {
      if (request) {
        _printRequestHeader(options);
      }
      if (requestHeader) {
        _printMapAsTable(options.queryParameters, header: 'Query Parameters');
        final requestHeaders = <String, dynamic>{};
        requestHeaders.addAll(options.headers);
        requestHeaders['contentType'] = options.contentType?.toString();
        requestHeaders['responseType'] = options.responseType.toString();
        requestHeaders['followRedirects'] = options.followRedirects;
        requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
        requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
        _printMapAsTable(requestHeaders, header: 'Headers');
        _printMapAsTable(options.extra, header: 'Extras');
      }
      if (requestBody && options.method != 'GET') {
        final dynamic data = options.data;
        if (data != null) {
          if (data is Map) {
            _printMapAsTable(options.data as Map?, header: 'Body');
          }
          if (data is FormData) {
            final formDataMap = <String, dynamic>{}
              ..addEntries(data.fields)
              ..addEntries(data.files);
            _printMapAsTable(formDataMap,
                header: 'Form data | ${data.boundary}');
          } else {
            _printBlock(data.toString());
          }
        }
      }
      handler.next(options);
    } else {
      handler.reject(DioException(
          requestOptions: options, error: 'No Internet Connection'));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      if (err.type == DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
            header:
                'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
            text: uri.toString());
        if (err.response != null && err.response?.data != null) {
          logPrint('╔ ${err.type.toString()}');
          _printResponse(err.response!);
        }
        _printLine('╚');
        logPrint('');
      } else {
        _printBoxed(header: 'DioError ║ ${err.type}', text: err.message);
      }
    }

    if (err.response != null) {
      Get.log("Error Data: ${err.response?.data}");
    }
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      logPrint('╔ Body');
      logPrint('║');
      _printResponse(response);
      logPrint('║');
      _printLine('╚');
    }
    handler.next(response);
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine('╚');
  }

  void _printResponse(Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map);
      } else if (response.data is Uint8List) {
        logPrint('║${_indent()}[');
        _printUint8List(response.data as Uint8List);
        logPrint('║${_indent()}]');
      } else if (response.data is List) {
        logPrint('║${_indent()}[');
        _printList(response.data as List);
        logPrint('║${_indent()}]');
      } else {
        _printBlock(response.data.toString());
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header:
            'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
        text: uri.toString());
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: 'Request ║ $method ', text: uri.toString());
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      _printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint((i >= 0 ? '║ ' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = kInitialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kInitialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kInitialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          logPrint('║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${_indent(tabs)} $key: {');
          _printPrettyMap(value, initialTab: tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          logPrint('║${_indent(tabs)} $key: ${value.toString()}');
        } else {
          logPrint('║${_indent(tabs)} $key: [');
          _printList(value, tabs: tabs);
          logPrint('║${_indent(tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            logPrint(
                '║${_indent(tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
          }
        } else {
          logPrint('║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = kInitialTab}) {
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          logPrint('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e,
              initialTab: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        logPrint('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  void _printUint8List(Uint8List list, {int tabs = kInitialTab}) {
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
            i, i + chunkSize > list.length ? list.length : i + chunkSize),
      );
    }
    for (var element in chunks) {
      logPrint('║${_indent(tabs)} ${element.join(", ")}');
    }
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach(
        (dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }
}

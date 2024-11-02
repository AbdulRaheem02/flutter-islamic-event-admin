/// Enum to define Application Environment instance
enum Environment { DEV, STAGING, PROD }

class EnvironmentConstants {
  // imageUrl for images for dev
  static String? baseUrlforimage;
  static String? socket;

  ///image url for live
  ///
  // static String baseUrlforimage = "http://51.20.114.124:5050";

  /// method to set environment
  ///
  static String? _config;

  static String setEnvironment(Environment env) {
    switch (env) {
      case Environment.PROD:
        socket = "http://13.127.226.157:3535/";
        _config = "http://13.127.226.157:3535/api/v1/";
        baseUrlforimage = "http://13.127.226.157:3535";
        break;
      case Environment.STAGING:
        socket = "https://h9rh5km3-5050.inc1.devtunnels.ms/";
        _config = "https://h9rh5km3-5050.inc1.devtunnels.ms/api/v1/";
        baseUrlforimage = "https://h9rh5km3-5050.inc1.devtunnels.ms";

        break;
      case Environment.DEV:
        socket = "https://wv9pfwh9-3535.inc1.devtunnels.ms/";
        _config = "https://wv9pfwh9-3535.inc1.devtunnels.ms/api/v1/";
        baseUrlforimage = "https://wv9pfwh9-3535.inc1.devtunnels.ms";
        break;
    }
    return _config!;
  }

  static String internetCheckUrl = 'http://google.com/';
  static String internetNotAvailableMessage =
      'Please check your internet connection';
  // static String apiKey = 'AIzaSyCG_wbzjzC9uXpfEOMn8TeKfd4SklwYYC4';
  static String apiKey = 'AIzaSyAbPn3X5qrqKJ999HOxj4oHpl4bAVfndA8';

//
}

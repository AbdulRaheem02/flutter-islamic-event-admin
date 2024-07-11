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
        socket = "https://f66468x0-5050.inc1.devtunnels.ms/";
        _config = "https://f66468x0-5050.inc1.devtunnels.ms/api/v1/";
        baseUrlforimage = "https://f66468x0-5050.inc1.devtunnels.ms";
        break;
      case Environment.STAGING:
        _config = "https://jsonplaceholder.typicode.com/";
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
  static String apiKey = '';
}

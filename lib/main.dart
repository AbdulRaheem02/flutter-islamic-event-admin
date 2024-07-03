import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'core/app_export.dart';
import 'core/utils/size_utils.dart';
import 'screen/splash_screen/splashScreen.dart';
import 'system-util/display_mode_util.dart';
import 'system-util/initial_setup.dart';
import 'theme/theme_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  setIntialSetup();
  setHighRefreshRate();

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  configLoading();

  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = appTheme.blueGray400
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          theme: theme,
          builder: EasyLoading.init(),
          title: 'islamic event',
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}

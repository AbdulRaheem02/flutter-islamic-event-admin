import 'package:flutter_displaymode/flutter_displaymode.dart';

Future<void> setHighRefreshRate() async {
  List<DisplayMode> modes = await FlutterDisplayMode.supported;
  DisplayMode? highRefreshMode;

  // Find the high refresh rate mode (e.g., 90Hz or 120Hz)
  for (var mode in modes) {
    if (mode.refreshRate >= 90) {
      highRefreshMode = mode;
      break;
    }
  }
  // Set the high refresh rate mode
  if (highRefreshMode != null) {
    await FlutterDisplayMode.setPreferredMode(highRefreshMode);
  }
}

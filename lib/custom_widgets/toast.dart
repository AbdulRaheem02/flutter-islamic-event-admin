import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamic_event_admin/core/app_export.dart';

void flutterToast(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: msg, backgroundColor: theme.colorScheme.primary);
}

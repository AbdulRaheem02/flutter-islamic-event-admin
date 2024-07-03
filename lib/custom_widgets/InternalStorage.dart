
import 'package:shared_preferences/shared_preferences.dart';


//////////// Get and Set and clear Access Token //////////////
Future<String> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('AccessToken');

  return token ?? '';
}

void saveAccessToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('AccessToken', token);
}

void clearAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('AccessToken');
}

void clearEveryThing() {
  clearAccessToken();
}

Future<bool> getonboard() async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getBool('Onboard');

  return token ?? false;
}

void saveonboard() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('Onboard', true);
}

// const _key = 'user_profile';

// // Save UserProfile to local storage
// Future<void> saveUserProfile(UserProfile userProfile) async {
//   final prefs = await SharedPreferences.getInstance();
//   final userProfileJson = userProfile.toJson();
//   print("befor save ${userProfileJson}");
//   await prefs.setString(_key, userProfile.toString());
//   print("save");
// }

// // Retrieve UserProfile from local storage
// Future<UserProfile?> getUserProfile() async {
//   print("save get");

//   final prefs = await SharedPreferences.getInstance();
//   final userProfileJson = prefs.getString(_key);
//   print("save ${userProfileJson}");
//   print("save skdn ${userProfileJson != null}");
//   print("save skdn as${userProfileJson!.isNotEmpty}");

//   if (userProfileJson.toString() != "null" && userProfileJson.isNotEmpty) {
//     try {
      
//       final Map<String, dynamic> userProfileMap = json.decode(userProfileJson);
//       print("save userProfileMap${userProfileMap}");

//       UserProfile userdata = UserProfile.fromJson(userProfileMap);
//       print("save userdata= ${userdata}");
//       return UserProfile.fromJson(userProfileMap);
//     } catch (e) {
//       print(' save Error decoding user profile JSON: $e');
//       return null;
//     }
//   } else {
//     print('save User profile JSON is empty or null');
//     return null;
//   }
// }

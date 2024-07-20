import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:islamic_event_admin/api-handler/env_constants.dart';
import 'package:islamic_event_admin/controller/initialStatuaController.dart';
import 'package:islamic_event_admin/screen/home_page/loationService.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/app_export.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/appbar_title.dart';
import '../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../widgets/custom_text_form_field.dart';

class PlacesSearchScreen extends StatefulWidget {
  const PlacesSearchScreen({super.key});

  @override
  State<PlacesSearchScreen> createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _placesData = [];
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  Position? position;
  Future<void> searchPlaces(String input) async {
    // String apiKey =
    //     'AIzaSyDmWpvoFV6kqRFA0UbI6qWnEncFO6E8HjM';
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json';
    String query = Uri.encodeQueryComponent(input);
    String url = '$baseUrl?query=$query&key=${EnvironmentConstants.apiKey}';
    print(url);
    try {
      http.Response response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> results = data['results'];
        List<Map<String, dynamic>> placesData = [];
        print("resultss ${results.toList()}");
        for (var result in results) {
          Map<String, dynamic> placeData = {
            'placeName': result['name'],
            'address': result['formatted_address'],
            'latitude': result['geometry']['location']['lat'],
            'longitude': result['geometry']['location']['lng'],
          };
          placesData.add(placeData);
          print(placeData);
        }
        setState(() {
          _placesData = placesData;
        });
      } else {
        print('Failed to fetch places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        margin: EdgeInsets.only(bottom: 5.v),
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [
            SizedBox(height: 8.v),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 3.h),
                    child: Text("Location",
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: theme.colorScheme.primary))),
              ],
            ),
            SizedBox(height: 6.v),
            Padding(
                padding: EdgeInsets.only(left: 1.h),
                child: CustomTextFormField(
                  onChanged: (value) {
                    if (value.length >= 4) {
                      searchPlaces(value.toString());
                    }
                  },
                  controller: _searchController,
                  hintText: "Search",
                )),
            SizedBox(height: 5.v),
            GestureDetector(
              onTap: () async {
                String? currentAddress;
                Position? currentPosition;
                EasyLoading.show();
                currentPosition = await LocationHandler.getCurrentPosition();
                currentAddress = await LocationHandler.getAddressFromLatLng(
                    currentPosition!);
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    currentPosition.latitude, currentPosition.longitude);
                _initialStatusController.latitude =
                    currentPosition.latitude.toString();
                _initialStatusController.longitude =
                    currentPosition.longitude.toString();

                Placemark place = placemarks[0];

                _initialStatusController.locationEditTextController.text =
                    '${place.street},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                print(_initialStatusController.locationEditTextController.text);
                print(place);
                EasyLoading.dismiss();

                Get.back();
                // await _getCurrentLocation();
              },
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  SizedBox(width: 5.v),
                  Text(
                    "Use current location",
                    style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 9.v),
            Expanded(
              child: ListView.builder(
                itemCount: _placesData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      double latitude = _placesData[index]['latitude'];
                      double longitude = _placesData[index]['longitude'];
                      _initialStatusController.latitude = latitude.toString();
                      _initialStatusController.longitude = longitude.toString();

                      _initialStatusController.locationEditTextController.text =
                          _placesData[index]['address'];
                      Get.back();
                    },
                    title: Text(
                      "${_placesData[index]['address']}",
                      style: theme.textTheme.bodySmall!
                          .copyWith(color: appTheme.black900),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
      centerTitle: true,
      title: AppbarTitle(text: 'Location'),
    );
  }

  // Future<void> _getCurrentLocation() async {
  //   // Check if location permission is granted
  //   bool isLocationPermissionGranted = await _checkLocationPermission();

  //   if (isLocationPermissionGranted) {
  //     // Location permission is granted, get current location
  //     try {
  //       EasyLoading.show();

  //       position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //       List<Placemark> placemarks = await placemarkFromCoordinates(
  //           position!.latitude, position!.longitude);
  //       _addCarController.latitude = position!.latitude.toString();
  //       _addCarController.longitude = position!.longitude.toString();

  //       Placemark place = placemarks[0];

  //       _addCarController.locationEditTextController.text =
  //           '${place.street},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //       print(_addCarController.locationEditTextController.text);
  //       print(place);
  //       Get.back();

  //       EasyLoading.dismiss();
  //     } catch (e) {
  //       print('Error getting current location: $e');
  //       EasyLoading.dismiss();
  //     }
  //   } else {
  //     // Location permission is not granted, request permission
  //     await _requestLocationPermission();
  //   }
  // }

  // Future<bool> _checkLocationPermission() async {
  //   // Check if location permission is granted
  //   PermissionStatus permission = await Permission.location.status;
  //   return permission == PermissionStatus.granted;
  // }

  // Future<void> _requestLocationPermission() async {
  //   PermissionStatus permissionStatus = await Permission.location.request();
  //   if (permissionStatus == PermissionStatus.granted) {
  //     _getCurrentLocation();
  //   } else {
  //     print('Location permission denied');
  //   }
  // }
}

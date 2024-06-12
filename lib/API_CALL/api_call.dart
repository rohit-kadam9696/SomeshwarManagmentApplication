// import 'dart:convert';
// import 'dart:io';
// import 'package:device_info/device_info.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
//
// import '../SharedPrefrence/shared_pref2.dart';
// import '../appInfo/app_info.dart';
// import '../pojo/cane_yard_response.dart';
// import '../pojo/crushing_response.dart';
// import '../pojo/crushing_shiftwiseReport.dart';
// import '../pojo/gatwise_crushing_response.dart';
// import '../pojo/hangam_crushing_response.dart';
// import '../pojo/hourly_crushing _response.dart';
// import '../pojo/variety_wise_crushing_response.dart';
// import '../pojo/vehicle_war_response.dart';
//
//
// class DataFetcher {
//
//
//   late List<double> sortedHours;
//   late Map<double, HourlyCrushingData> sortedHourlyCrushingData;
//   late List<String> sortedVehicleType;
//   late Map<String, GatWiseCrushingData> sortedDepartmentCrushingData;
//   late List<String> sortedDepartment;
//   late Map<String, CaneYardCrushingData> sortedCaneTypeCrushingData;
//   late List<String> sortedHangam;
//   late Map<String, HangamCrushingData> sortedHangamCrushingData;
//   late List<String> sortedVariety;
//   late Map<String, VarietyWiseCrushingData> sortedVarietyCrushingData;
//
//   late DateTime selectedDate;
//   late String formattedDate = "";
//   late String chitBoyId;
//   late String randomString;
//   late String mobileNo;
//   static String identifier = 'Identifier not available';
//
//    static Future<CrushingResponse?> _crushingFuture = Future.value();
//   static Future<ShiftCrushingResponse?> _shiftWiseCrushingFuture = Future.value();
//   static  Future<CaneYardResponse?> _caneTypeCrushingFuture = Future.value();
//   static Future<HourlyCrushingReponse?> _hourTypeCrushingFuture = Future.value();
//   static Future<GatWiseCrushingResponse?> _gatTypeCrushingFuture = Future.value();
//   static Future<HangamWiseCrushingResponse?> _hangamTypeCrushingFuture = Future.value();
//   static Future<VarietyWiseCrushingResponse?> _varietyTypeCrushingFuture = Future.value();
//   static Future<VehicleTypeWarCrushingResponse?> _vehicleTypeCrushingFuture = Future.value();
//   Map<String, dynamic> data = {};
//
//   ShiftCrushingResponse? data1;
//   void initDate() {
//     initData();
//     selectedDate = DateTime.now();
//   }
//
//   static Future<void> initData() async {
//     fetchData();
//
//   }
//
//   static Future<void> fetchData() async {
//     String randomString = await SharedPreferencesHelper.getUniqString();
//     String chitBoyId = await SharedPreferencesHelper.getChitboyId();
//     String versionId = await AppInfo.getVersionId();
//     String mobileNo = await SharedPreferencesHelper.getMobileNo();
//     String YearCode = await SharedPreferencesHelper.getYearCode();
//
//     DateTime selectedDate = DateTime.now();
//     String formattedDate = _formatDate(selectedDate);
//
//     if (selectedDate.isBefore(DateTime.now()) || selectedDate.isAtSameMomentAs(DateTime.now())) {
//       await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode, formattedDate);
//     }
//
//     _getDeviceInfo();
//   }
//
//   static Future<void> fetchDataForDate(String randomString, String chitBoyId, String versionId, String mobileNo, String YearCode, String formattedDate) async {
//     _crushingFuture = crushingReport1(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _shiftWiseCrushingFuture = getShiftWiseCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _caneTypeCrushingFuture = getCaneYardCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _hourTypeCrushingFuture=getHourlyCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _gatTypeCrushingFuture=getSectionWiseCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _hangamTypeCrushingFuture=getHangamWiseCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _varietyTypeCrushingFuture=getVarietyWiseCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//     _vehicleTypeCrushingFuture=getVehicleWarCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
//   }
//   static Future<String?> _getDeviceInfo() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Platform.isAndroid) {
//         var status = await Permission.phone.status;
//         if (status.isGranted) {
//           AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//           return androidInfo.androidId ?? 'IMEI not available';
//         } else {
//           await Permission.phone.request();
//         }
//       } else if (Platform.isIOS) {
//         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         return iosInfo.identifierForVendor ?? 'Identifier not available';
//       }
//     } catch (e) {
//       print('Error getting device info: $e');
//     }
//     return null;
//   }
//
//
//   static String _formatDate(DateTime date) {
//
//   }
// }

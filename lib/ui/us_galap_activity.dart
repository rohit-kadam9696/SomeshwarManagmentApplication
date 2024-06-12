



import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:SomeshwarManagementApp/ui/production_page.dart';
import 'package:SomeshwarManagementApp/ui/punar_us_nond.dart';
import 'package:SomeshwarManagementApp/ui/vikrisath_page.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SomeshwarManagementApp/pojo/crushing_response.dart';
import 'package:SomeshwarManagementApp/pojo/gatwise_crushing_response.dart';
import 'package:SomeshwarManagementApp/pojo/variety_wise_crushing_response.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';


import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:device_info/device_info.dart';

import 'package:SomeshwarManagementApp/pojo/login_response.dart';
import 'package:SomeshwarManagementApp/pojo/main_response.dart';
import 'package:SomeshwarManagementApp/ui/otp_activity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import '../constant/random_string.dart';
import '../constant/snackbar_apierror.dart';
import '../constantfunction/constant_function.dart';
import '../pojo/cane_yard_response.dart';
import '../pojo/crushing_report.dart';
import '../pojo/crushing_shiftwiseReport.dart';

import '../pojo/gatwise_crushing_response.dart';
import '../pojo/gatwise_crushing_response.dart';
import '../pojo/gatwise_crushing_response.dart';
import '../pojo/gatwise_crushing_response.dart';
import '../pojo/gatwise_crushing_response.dart';
import '../pojo/hangam_crushing_response.dart';
import '../pojo/hourly_crushing _response.dart';
import '../pojo/variety_wise_crushing_response.dart';
import '../pojo/vehicle_war_response.dart';
import '../progress_bar/animated_circular_progressbar.dart';
import '../progress_bar/progress_bar.dart';
import 'bottom_nav_activity.dart';
import 'cha_us_nond.dart';

class UsGalapPage extends StatefulWidget {
  // final int selectedIndex;

//  const UsGalapPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  const UsGalapPage({super.key});

  @override
  State<UsGalapPage> createState() => _UsGalapPageState();
}

class _UsGalapPageState extends State<UsGalapPage> {

  late Future<CrushingReport?> _crushingReportFuture = Future.value();

  late List<double> sortedHours;
  late Map<double, HourlyCrushingData> sortedHourlyCrushingData={};
  late List<String> sortedVehicleType;
  late Map<String, GatWiseCrushingData> sortedDepartmentCrushingData= {};
  late List<String> sortedDepartment;
  late Map<String, CaneYardCrushingData> sortedCaneTypeCrushingData;
  late List<String> sortedHangam;
 // late Map<String, HangamCrushingData> sortedHangamCrushingData;
  late List<String> sortedVariety;
  late Map<String, VarietyWiseCrushingData> sortedVarietyCrushingData;


  static const Color darkgreen = Color(0xFF4CB050);
  static const Color smallgreen = Color(0xFF8BE08E);
  static const Color verysmallgreen = Color(0xFFC8E6CA);


 static const Color myColor = Color(0xFF80FFAA);

  static  const Color tabledata = Color(0xFFB3FFCC);
  double todayCrushing = 0.0;
  double uptoTodayCrushing = 0.0;


  late DateTime selectedDate;
  late String formattedDate = "";
  late String chitBoyId;
  late String randomString;
  late String mobileNo;
  static String identifier = 'Identifier not available';

  late Future<CrushingResponse?> _crushingFuture = Future.value();
  late Future<ShiftCrushingResponse?> _shiftWiseCrushingFuture = Future.value();
  late Future<CaneYardResponse?> _caneTypeCrushingFuture = Future.value();
  late Future<HourlyCrushingReponse?> _hourTypeCrushingFuture = Future.value();
  late Future<GatWiseCrushingResponse?> _gatTypeCrushingFuture = Future.value();
  late Future<HangamWiseCrushingResponse?> _hangamTypeCrushingFuture = Future.value();
  late Future<VarietyWiseCrushingResponse?> _varietyTypeCrushingFuture = Future.value();
  late Future<VehicleTypeWarCrushingResponse?> _vehicleTypeCrushingFuture = Future.value();
  Map<String, dynamic> data = {};

  ShiftCrushingResponse? data1;
  Map<String, ShiftCrushingData> shiftWiseCrushingBeanMap = {};
  Map<String, GatWiseCrushingData> gatWiseTypeCrushingBeanMap = {};
   Map<String, HangamCrushingData> hangamCrushingBeanMap={};
   Map<String, VarietyWiseCrushingData> varietyWiseCrushingBeanMap={};
  Map<String, VehicleTypeWarData> vehicleCrushingBeanMap={};
   Map<double, HourlyCrushingData> hourlyTypeCrushingBeanMap={};
  GatWiseCrushingResponse? data2;
  @override
  void initState() {
    super.initState();
    initData();
    selectedDate = DateTime.now();
  }

  Future<void> initData() async {
    fetchData();
  }

  Future<void> fetchData() async {
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String YearCode = await SharedPreferencesHelper.getYearCode();

    selectedDate = DateTime.now();
    formattedDate = _formatDate(selectedDate);

    if (selectedDate.isBefore(DateTime.now()) ||
        selectedDate.isAtSameMomentAs(DateTime.now())) {
      await fetchDataForDate(
          randomString, chitBoyId, versionId, mobileNo, YearCode);
    }

    _getDeviceInfo();
  }


  Future<void> _selectDate(BuildContext context) async {
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String YearCode = await SharedPreferencesHelper.getYearCode();

    DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: currentDate.subtract(Duration(days: 365)),
      // Allow selection of past dates within the last year
      lastDate: currentDate,
    );
    if (picked == null) {
      setState(() {
        selectedDate = currentDate;
        formattedDate = _formatDate(currentDate);
      });
      await fetchDataForDate(
          randomString, chitBoyId, versionId, mobileNo, YearCode);
    } else
    if (picked.isBefore(currentDate) || picked.isAtSameMomentAs(currentDate)) {
      setState(() {
        selectedDate = picked;
        formattedDate = _formatDate(selectedDate);
      });
      await fetchDataForDate(
          randomString, chitBoyId, versionId, mobileNo, YearCode);
    }
  }

  Future<void> fetchDataForDate(String randomString, String chitBoyId,
      String versionId, String mobileNo, String YearCode) async {
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String YearCode = await SharedPreferencesHelper.getYearCode();

    _crushingFuture = crushingReport1(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _shiftWiseCrushingFuture = getShiftWiseCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _caneTypeCrushingFuture = getCaneYardCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _hourTypeCrushingFuture = getHourlyCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _gatTypeCrushingFuture = getSectionWiseCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _hangamTypeCrushingFuture = getHangamWiseCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _varietyTypeCrushingFuture = getVarietyWiseCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);
    _vehicleTypeCrushingFuture = getVehicleWarCrushing(
        randomString,
        chitBoyId,
        identifier,
        versionId,
        formattedDate,
        mobileNo,
        YearCode);

    log("_shiftWiseCrushingFuture: ${_shiftWiseCrushingFuture}");

    final CrushingResponse? response = await _crushingFuture;
    if (response != null) {
      setState(() {
        todayCrushing = response.todayCrushing ?? 0.0;

        uptoTodayCrushing = response.uptoTodayCrushing ?? 0.0;
      });




      // data1 = await _shiftWiseCrushingFuture;
      // if (data1 != null) {
      //
      //   data1!.shiftWiseCrushingBeanMap.forEach((shiftNo, shiftData) {
      //     print("Shift No: $shiftNo");
      //     print("Today Crushing: ${shiftData.shiftTodayCrushing}");
      //     print("Yesterday Crushing: ${shiftData.shiftYeastrdayCrushing}");
      //
      //   });
      // } else {
      //   log("Shift-wise crushing data is null");
      // }
      //
      //
      //
      // setState(() {
      //     shiftWiseCrushingBeanMap = data1!.shiftWiseCrushingBeanMap;
      //
      //   });


      // }

      final data2 = await _gatTypeCrushingFuture;
      if (data2 != null) {
        setState(() {
          gatWiseTypeCrushingBeanMap = data2.gatWiseTypeCrushingBeanMap.map(
                (department, gatData) {
              return MapEntry(
                department,
                GatWiseCrushingData(
                  todayCrushing: gatData.todayCrushing ?? 0.0,
                  uptoTodayCrushingngWt: gatData.uptoTodayCrushingngWt ?? 0.0, department: 'raver',
                ),
              );
            },
          );
        });

        // Handling shift-wise data
        data2.gatWiseTypeCrushingBeanMap.forEach((department, gatData) {
          print("department No: $department");
          print("gat today Crushing: ${gatData.todayCrushing ?? 0.0}");
          print("gat Yesterday Crushing: ${gatData.uptoTodayCrushingngWt ?? 0.0}");
        });
      }


      final data1 = await _shiftWiseCrushingFuture;
      if (data1 != null && data1.shiftWiseCrushingBeanMap.isNotEmpty) {
        setState(() {
          shiftWiseCrushingBeanMap = data1.shiftWiseCrushingBeanMap;
        });
        // Handling shift-wise data
        data1.shiftWiseCrushingBeanMap.forEach((shiftNo, shiftData) {
          print("Shift No: $shiftNo");
          print("Today Crushing: ${shiftData.shiftTodayCrushing}");
          print("Yesterday Crushing: ${shiftData.shiftYeastrdayCrushing}");
        });
      }



      final data3= await _hangamTypeCrushingFuture;
      if (data3 != null) {
        setState(() {
          hangamCrushingBeanMap = data3.hangamCrushingBeanMap;
        });
        // Handling shift-wise data
        data3.hangamCrushingBeanMap.forEach((hangam, hangamData) {
          print("hangam : $hangam");
          print("Today Crushing: ${hangamData.todayCrushing}");
          print("Yesterday Crushing: ${hangamData.uptoTodayCrushingngWt1}");
        });
      }


      final data4= await _varietyTypeCrushingFuture;
      if (data4 != null) {
        setState(() {
          varietyWiseCrushingBeanMap = data4.varietyWiseCrushingBeanMap;
        });
        // Handling shift-wise data
        data4.varietyWiseCrushingBeanMap.forEach((varietyName, gatData) {
          print("varietyName : $varietyName");
          print("Today Crushing: ${gatData.todayCrushingWt}");
          print("Yesterday Crushing: ${gatData.uptoTodayCrushingWt}");
        });
      }


      final data5= await _vehicleTypeCrushingFuture;
      if (data5 != null) {
        setState(() {
          vehicleCrushingBeanMap = data5.vehicleCrushingBeanMap;
        });
        // Handling shift-wise data
        data5.vehicleCrushingBeanMap.forEach((vvehicleType, vehicleData) {
          print("vvehicleType : $vvehicleType");
          print("Today Crushing: ${vehicleData.todayWt}");
          print("Yesterday Crushing: ${vehicleData.todateWt}");
        });
      }


      final hourlyCrushing= await _hourTypeCrushingFuture;
      if (hourlyCrushing != null) {
        setState(() {
          hourlyTypeCrushingBeanMap = hourlyCrushing.hourlyTypeCrushingBeanMap;
          sortedHourlyCrushingData = Map.fromEntries(hourlyCrushing.hourlyTypeCrushingBeanMap.entries.toList()..sort());
        });
        // Handling shift-wise data
        hourlyCrushing.hourlyTypeCrushingBeanMap.forEach((hour,horlyData) {
          print("hour : $hour");
          print("horlyData: ${horlyData.crushingWt}");

        });
      }


      else {
        // Handling when shift-wise data is null or empty
        log("Shift-wise crushing data is null or empty");
        // Show a dialog message or handle the absence of data accordingly
      }
    }
  }





  String _formatDate(DateTime date) {
    return DateFormat('dd-MMM-yyyy').format(date);
  }
  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var status = await Permission.phone.status;
        if (status.isGranted) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          String imei = androidInfo.androidId ?? 'IMEI not available';
          setState(() {
            identifier = imei;
          });
        } else {
          await Permission.phone.request();
        }
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        identifier = iosInfo.identifierForVendor ?? 'Identifier not available';
        setState(() {
          identifier = identifier;
        });
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }
  final List<DeviceOrientation> preferredOrientations = [
    DeviceOrientation.portraitUp
  ];
  Color bottomNavBarColor = darkgreen;
  // static Color darkgreen = const Color(0xFF4CAF50);
  static const Color brownColor = Color(0xFFB08401);
  static const Color darkRed = Color(0xFFF44236);
  static const Color darkBlue = Color(0xFF008596);
  static const Color darkBlue1 = Color(0xFF2196F3);


  List<Widget> _screens = [
    UsGalapPage(),
    ChaUsNodPage(),
    PunarUsNodPage(),
    VikriSathaPage(),
    ProductionPage(),
  ];
  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    if (selectedIndex < _screens.length) {
      setState(() {
        _selectedIndex = selectedIndex;
      });

      // Update color based on the selected index
      switch (selectedIndex) {
        case 0:
          updateNavBarColor(darkgreen);
          setState(() {
            bottomNavBarColor = darkgreen;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UsGalapPage()),
          );
          break;

        case 1:
          updateNavBarColor(brownColor);
          setState(() {

            bottomNavBarColor = brownColor;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChaUsNodPage()),
          );
          break;

        case 2:
          updateNavBarColor(darkBlue);
          setState(() {
            bottomNavBarColor = darkBlue;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PunarUsNodPage()),
          );
          break;
        case 3:
          updateNavBarColor(darkRed);
          setState(() {
            bottomNavBarColor = darkRed;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VikriSathaPage()),
          );
          break;
        case 4:
          updateNavBarColor(darkBlue1);
          setState(() {
            bottomNavBarColor = darkBlue1;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductionPage()),
          );
          break;

        default:
          setState(() {
            bottomNavBarColor = darkgreen;
          });
      }
    }
  }
  void changeScreen() {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Navigator.pushReplacementNamed(context, '/chaUsNond');
    });
  }
  void updateNavBarColor(Color color) {
    setState(() {
      bottomNavBarColor = color;
    });
  }
  DateTime? currentBackPressTime;
  Future<bool> onBackpress(BuildContext context) async {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
        ),
      );
      return false; // Do not exit yet
    } else {
      SystemNavigator.pop();
      exit(0);
      return true; // Allow the system to exit the app
    }
  }


  @override
  Widget build(BuildContext context) {
    String versionId;
    SystemChrome.setPreferredOrientations(preferredOrientations);
    DateTime todayDate = DateTime.now();
    String formattedTodayDate = _formatDate(todayDate); // Assuming _formatDate function formats the date as required


    bool isToday = formattedDate == formattedTodayDate;
    return WillPopScope(

      onWillPop: () => onBackpress(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            margin: EdgeInsets.only(top: 20,),

            child: AppBar(
              title: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'श्री सोमेश्वर स.सा.का.लि',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              backgroundColor: darkgreen,
              leading: Container(
                padding: EdgeInsets.only( bottom: 5),
                margin: EdgeInsets.only(bottom: 10.0, left: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:smallgreen,

                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      await _selectDate(context);

                    },
                    color: Colors.white,
                    iconSize: 30.0,
                  ),
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 2.0,left:2,bottom:5),

                  margin: EdgeInsets.only(bottom: 10.0,right:10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: smallgreen,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {

                      String randomString = await SharedPreferencesHelper.getUniqString();
                      String chitBoyId = await SharedPreferencesHelper.getChitboyId();
                      String versionId = await AppInfo.getVersionId();
                      String mobileNo = await SharedPreferencesHelper.getMobileNo();
                      String YearCode = await SharedPreferencesHelper.getYearCode();

                      await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode);
                      setState(() {});
                    },
                    color: Colors.white,
                    iconSize: 30.0,
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(right: 2.0,left:2,bottom:5),
                //
                //   margin: EdgeInsets.only(bottom: 10.0,right:10.0),
                //  // padding: EdgeInsets.all(8.0), // Adjust padding as needed
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: smallgreen, // Change the color as needed
                //   ),
                //   child: IconButton(
                //     icon: Icon(Icons.arrow_circle_right_outlined),
                //     onPressed: () async {
                //       if(mounted){
                //         changeScreen();
                //       }
                //
                //       // await SharedPreferencesHelper.clearUserData();
                //       // Navigator.pushReplacementNamed(context, '/home');
                //     },
                //     color: Colors.white,
                //     iconSize: 30.0,
                //   ),
                // )

              ],
            ),
          ),
        ),
        body: SingleChildScrollView(

          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),

              Container(
              //  margin: EdgeInsets.all(10),
               // color: Colors.green,
                child: Visibility(
                  visible: !_isDateGreaterThanCurrentDate(selectedDate),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width:220,
                          margin: EdgeInsets.only(top: 15,left:10,right:10),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'दि: -${formattedDate ?? selectedDate}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: darkgreen,
                            borderRadius: BorderRadius.circular(10.0),
                            // border: Border.all(
                            //   color: Colors.black,
                            //   width: 2.0,
                            // ),
                            // borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                    Container(
                     // margin: EdgeInsets.only(left:4,right:1),
                      width:double.infinity,
                      child: Card(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12.0),
                        // ),
                        elevation: 200,
                        shadowColor: myColor,
                        //color: verysmallgreen,
                        color:tabledata,


                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     color: Colors.black,
                            //     width: 2.0,
                            //   ),
                            //   borderRadius: BorderRadius.circular(5.0),
                            // ),
                          // width: double.infinity,

                            child:ClipRect(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                                  columns: [
                                    DataColumn(
                                      label: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0.5), // Adjusted padding
                                        child: Text(
                                          'आजचे क्रशिग',
                                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0.5), // Adjusted padding
                                        child: Text(
                                          'आजअखेर क्रशिग',
                                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0.5), // Adjusted padding
                                          child: Text(todayCrushing.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0.5), // Adjusted padding
                                          child: Text(uptoTodayCrushing.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),


                      ),
                      ),
                    ],
                  ),
                ),
              ),









              // Container(
              //   margin: EdgeInsets.all(10),
              //   color: verysmallgreen,
              //   child: Visibility(
              //     visible: !_isDateGreaterThanCurrentDate(selectedDate),
              //     child: Column(
              //       children: [
              //         Center(
              //           child: Container(
              //             margin: EdgeInsets.only(top: 15),
              //             padding: EdgeInsets.all(5),
              //             child: Text(
              //               'दि:${formattedDate ?? selectedDate}',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //               ),
              //             ),
              //             decoration: BoxDecoration(
              //               color: darkgreen,
              //               border: Border.all(
              //                 color: Colors.black,
              //                 width: 2.0,
              //               ),
              //               borderRadius: BorderRadius.circular(10.0),
              //             ),
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //         Card(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12.0),
              //           ),
              //           elevation: 50,
              //           shadowColor: Colors.black,
              //           color: verysmallgreen,
              //           child: FutureBuilder<CrushingResponse?>(
              //             future: _crushingFuture,
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState == ConnectionState.waiting) {
              //                 return Container();
              //               } else if (snapshot.hasError) {
              //                 return Text('Error: ${snapshot.error}');
              //               }
              //
              //               else if (snapshot.hasData) {
              //                 final todayCrushing = snapshot.data?.todayCrushing ?? 0.0;
              //                 final uptoTodayCrushing = snapshot.data?.uptoTodayCrushing ?? 0.0;
              //
              //                 return SingleChildScrollView(
              //                   scrollDirection: Axis.horizontal,
              //                   child: Container(
              //                     decoration: BoxDecoration(
              //                       border: Border.all(
              //                         color: Colors.black,
              //                         width: 2.0,
              //                       ),
              //                       borderRadius: BorderRadius.circular(5.0),
              //                     ),
              //                     child: DataTable(
              //                       headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                       columns: [
              //                         DataColumn(
              //                           label: Text(
              //                             'आजचे क्रशिग',
              //                             style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                           ),
              //                         ),
              //                         DataColumn(
              //                           label: Padding(
              //                             padding: EdgeInsets.symmetric(horizontal: 20.0),
              //                             child: Text(
              //                               'आजअखेर क्रशिग',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                       rows: [
              //                         DataRow(cells: [
              //                           DataCell(Text(todayCrushing.toString(), style: TextStyle(fontWeight: FontWeight.bold))),
              //                           DataCell(Padding(
              //                             padding: EdgeInsets.symmetric(horizontal: 25.0),
              //                             child: Text(uptoTodayCrushing.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
              //                           )),
              //                         ]),
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               }
              //
              //               else {
              //                 return Container();
              //               }
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),


              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Visibility(
                  visible: !_isDateGreaterThanCurrentDate(selectedDate),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.only(top: 15),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'शिफ्ट क्रशिग',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: darkgreen,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (shiftWiseCrushingBeanMap != null && shiftWiseCrushingBeanMap.isNotEmpty)
                        Card(
                          elevation: 50,
                          shadowColor: myColor,
                          color: tabledata,
                          child: Container(
                            width: double.infinity,
                            child: DataTable(
                              // headingRowColor: _isDateGreaterThanCurrentDate(selectedDate)
                              //     ? MaterialStateColor.resolveWith((states) => myColor)
                              //     : null,

                              headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'शिफ्ट',
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'आज',
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      'काल',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              rows: [
                                ...shiftWiseCrushingBeanMap.entries.map<DataRow>((entry) {
                                  String shiftNo = entry.key;
                                  ShiftCrushingData shiftData = entry.value;
                                  String shift1 = mapShiftNo(shiftNo);

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          shift1,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          shiftData.shiftTodayCrushing.toStringAsFixed(3),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(
                                            shiftData.shiftYeastrdayCrushing.toStringAsFixed(3),
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
              ),












              // Container(
              //   margin: EdgeInsets.all(10),
              //   child: Visibility(
              //     visible: !_isDateGreaterThanCurrentDate(selectedDate),
              //     child: Container(
              //       color: verysmallgreen,
              //       padding: EdgeInsets.all(5),
              //       child: Column(
              //         children: [
              //           Center(
              //             child: Container(
              //               padding: EdgeInsets.all(5),
              //               child: Text(
              //                 'शिफ्ट क्रशिग',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               decoration: BoxDecoration(
              //                 color: darkgreen,
              //                 border: Border.all(
              //                   color: Colors.black,
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //             ),
              //           ),
              //           SizedBox(height: 20),
              //           Card(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12.0),
              //             ),
              //             elevation: 50,
              //             shadowColor: Colors.black,
              //             color: verysmallgreen,
              //             child: FutureBuilder<ShiftCrushingResponse?>(
              //               future: _shiftWiseCrushingFuture,
              //               builder: (context, snapshot) {
              //                 if (snapshot.connectionState == ConnectionState.waiting) {
              //                   return Container();
              //                 } else if (snapshot.hasError) {
              //                   return Text('Error: ${snapshot.error}');
              //                 }
              //                 else if (snapshot.hasData) {
              //                   ShiftCrushingResponse crushingResponse = snapshot.data!;
              //                   Map<String, ShiftCrushingData> shiftWiseCrushingBeanMap = crushingResponse.shiftWiseCrushingBeanMap;
              //
              //                   double totalTodayCrushing = shiftWiseCrushingBeanMap.values
              //                       .map((shiftData) => shiftData.shiftTodayCrushing)
              //                       .fold(0, (previous, current) => previous + current);
              //
              //                   double totalYesterdayCrushing = shiftWiseCrushingBeanMap.values
              //                       .map((shiftData) => shiftData.shiftYeastrdayCrushing)
              //                       .fold(0, (previous, current) => previous + current);
              //
              //                   return Container(
              //                     decoration: BoxDecoration(
              //                       border: Border.all(
              //                         color: Colors.black,
              //                         width: 2.0,
              //                       ),
              //                       borderRadius: BorderRadius.circular(5.0),
              //                     ),
              //                     child: DataTable(
              //                       headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                       columns: [
              //                         DataColumn(
              //                           label: Text(
              //                             'शिफ्ट',
              //                             style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                           ),
              //                         ),
              //                         DataColumn(
              //                           label: Text(
              //                             'आज',
              //                             style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                           ),
              //                         ),
              //                         DataColumn(
              //                           label: Padding(
              //                             padding: EdgeInsets.symmetric(horizontal: 15.0),
              //                             child: Text(
              //                               'काल',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                       rows: [
              //                         ...shiftWiseCrushingBeanMap.entries.map<DataRow>(
              //                               (entry) {
              //                             String shiftNo = entry.key;
              //
              //                             String shift1 = mapShiftNo(shiftNo);
              //                             ShiftCrushingData shiftData = entry.value;
              //
              //                             return DataRow(
              //                               cells: [
              //                                 DataCell(
              //                                   Text(
              //                                     shift1,
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                   ),
              //                                 ),
              //                                 DataCell(
              //                                   Text(
              //                                     shiftData.shiftTodayCrushing.toStringAsFixed(3),
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                   ),
              //                                 ),
              //                                 DataCell(
              //                                   Padding(
              //                                     padding: EdgeInsets.symmetric(horizontal: 10.0),
              //                                     child: Text(
              //                                       shiftData.shiftYeastrdayCrushing.toStringAsFixed(3),
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ],
              //                             );
              //                           },
              //                         ),
              //
              //                         DataRow(
              //                           cells: [
              //                             DataCell(
              //                               Text(
              //                                 'एकूण',
              //                                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                             DataCell(
              //                               Text(
              //                                 totalTodayCrushing.toStringAsFixed(3),
              //                                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                             DataCell(
              //                               Padding(
              //                                 padding: EdgeInsets.symmetric(horizontal: 10.0),
              //                                 child: Text(
              //                                   totalYesterdayCrushing.toStringAsFixed(3),
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //
              //
              //                       ],
              //                     ),
              //                   );
              //                 }
              //                 else {
              //                   return Container();
              //                 }
              //
              //                 return CircularProgressIndicator(color: Colors.black,);
              //                 // ShiftCrushingResponse crushingResponse = snapshot.data!;
              //                 // Map<String, ShiftCrushingData> shiftWiseCrushingBeanMap = crushingResponse.shiftWiseCrushingBeanMap;
              //                 //
              //                 // double totalTodayCrushing = shiftWiseCrushingBeanMap.values
              //                 //     .map((shiftData) => shiftData.shiftTodayCrushing)
              //                 //     .fold(0, (previous, current) => previous + current);
              //                 //
              //                 // double totalYesterdayCrushing = shiftWiseCrushingBeanMap.values
              //                 //     .map((shiftData) => shiftData.shiftYeastrdayCrushing)
              //                 //     .fold(0, (previous, current) => previous + current);
              //                 //
              //                 // return Container(
              //                 //   decoration: BoxDecoration(
              //                 //     border: Border.all(
              //                 //       color: Colors.black,
              //                 //       width: 2.0,
              //                 //     ),
              //                 //     borderRadius: BorderRadius.circular(5.0),
              //                 //   ),
              //                 //   child: DataTable(
              //                 //     headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                 //     columns: [
              //                 //       DataColumn(
              //                 //         label: Text(
              //                 //           'शिफ्ट',
              //                 //           style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                 //         ),
              //                 //       ),
              //                 //       DataColumn(
              //                 //         label: Text(
              //                 //           'आज',
              //                 //           style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                 //         ),
              //                 //       ),
              //                 //       DataColumn(
              //                 //         label: Padding(
              //                 //           padding: EdgeInsets.symmetric(horizontal: 15.0),
              //                 //           child: Text(
              //                 //             'काल',
              //                 //             style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                 //           ),
              //                 //         ),
              //                 //       ),
              //                 //     ],
              //                 //     rows: [
              //                 //       ...shiftWiseCrushingBeanMap.entries.map<DataRow>(
              //                 //             (entry) {
              //                 //           String shiftNo = entry.key;
              //                 //
              //                 //           String shift1 = mapShiftNo(shiftNo);
              //                 //           ShiftCrushingData shiftData = entry.value;
              //                 //
              //                 //           return DataRow(
              //                 //             cells: [
              //                 //               DataCell(
              //                 //                 Text(
              //                 //                   shift1,
              //                 //                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                 //                 ),
              //                 //               ),
              //                 //               DataCell(
              //                 //                 Text(
              //                 //                   shiftData.shiftTodayCrushing.toStringAsFixed(3),
              //                 //                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                 //                 ),
              //                 //               ),
              //                 //               DataCell(
              //                 //                 Padding(
              //                 //                   padding: EdgeInsets.symmetric(horizontal: 10.0),
              //                 //                   child: Text(
              //                 //                     shiftData.shiftYeastrdayCrushing.toStringAsFixed(3),
              //                 //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                 //                   ),
              //                 //                 ),
              //                 //               ),
              //                 //             ],
              //                 //           );
              //                 //         },
              //                 //       ),
              //                 //
              //                 //       DataRow(
              //                 //         cells: [
              //                 //           DataCell(
              //                 //             Text(
              //                 //               'एकूण',
              //                 //               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                 //             ),
              //                 //           ),
              //                 //           DataCell(
              //                 //             Text(
              //                 //               totalTodayCrushing.toStringAsFixed(3),
              //                 //               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                 //             ),
              //                 //           ),
              //                 //           DataCell(
              //                 //             Padding(
              //                 //               padding: EdgeInsets.symmetric(horizontal: 10.0),
              //                 //               child: Text(
              //                 //                 totalYesterdayCrushing.toStringAsFixed(3),
              //                 //                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                 //               ),
              //                 //             ),
              //                 //           ),
              //                 //         ],
              //                 //       ),
              //                 //
              //                 //
              //                 //     ],
              //                 //   ),
              //                 // );
              //               },
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),


              Visibility(
                visible: formattedDate == _formatDate(DateTime.now()),
                child: Container(
                  margin: EdgeInsets.all(10),
                  color: tabledata,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(10),

                        child: Container(
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 200,
                                  margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'क्रेनयार्ड शिल्लक ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  decoration: BoxDecoration(
                                    color: darkgreen,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Card(
                                elevation: 250,
                                shadowColor: myColor,
                                color: tabledata,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: DataTable(
                                    headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'वाहन',
                                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                            'संख्या',
                                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      DataColumn(
                                        label: Text(
                                          'अपेक्षितटनेज',
                                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                    ],
                                    rows: [

                                      ...sortedHourlyCrushingData.entries.map<DataRow>(
                                            (entry) {
                                          double hour = entry.key;
                                          HourlyCrushingData horlyData = entry.value;

                                              // CaneYardCrushingData vehicleData = caneYardCrushingBeanMap[vehicleType]!;
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                                  child: Text(
                                                    hour.toString(),
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 90.0),
                                                  child: Text(
                                                    horlyData.crushingWt.toString(),
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   child: Card(
                      //     elevation: 50,
                      //     shadowColor: Colors.black,
                      //     color: verysmallgreen,
                      //     child: FutureBuilder<HourlyCrushingReponse?>(
                      //       future: _hourTypeCrushingFuture,
                      //       builder: (context, snapshot) {
                      //         if (snapshot.connectionState == ConnectionState.waiting) {
                      //           // Loading state
                      //           return Container();
                      //         }
                      //         else if (snapshot.hasError) {
                      //           return Center(
                      //             child: Text(
                      //               'Error loading data. Please try again.',
                      //               style: TextStyle(color: Colors.red),
                      //             ),
                      //           );
                      //         }
                      //
                      //         else if (snapshot.hasData) {
                      //           HourlyCrushingReponse hourlyResposne = snapshot.data!;
                      //           Map<double, HourlyCrushingData> hourlyCrushingBeanMap = hourlyResposne.hourlyTypeCrushingBeanMap;
                      //           bool isToday = formattedDate == _formatDate(DateTime.now());
                      //           sortedHours = hourlyCrushingBeanMap.keys.toList()..sort();
                      //           sortedHourlyCrushingData = Map.fromEntries(sortedHours.map((hour) => MapEntry(hour, hourlyCrushingBeanMap[hour]!)));
                      //           // Calculate the total of shiftData.shiftTodayCrushing for all entries in hourlyCrushingBeanMap
                      //           double totalHourCrushing = hourlyCrushingBeanMap.values
                      //               .map((hourlyData) => hourlyData.crushingWt)
                      //               .fold(0, (previous, current) => previous + current);
                      //           if (isToday) {
                      //             return Container(
                      //               decoration: BoxDecoration(
                      //                 //color: verysmallgreen,
                      //                 border: Border.all(
                      //                   color: Colors.black, // Change color as needed
                      //                   width: 2.0, // Adjust width as needed
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
                      //               ),
                      //               child: DataTable(
                      //                 headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
                      //                 columns: [
                      //                   DataColumn(
                      //                     label: Text(
                      //                       'तास',
                      //                       style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      //                     ),
                      //                   ),
                      //                   DataColumn(
                      //                     label: Padding(
                      //                       padding: EdgeInsets.symmetric(horizontal: 100.0),
                      //                       child: Text(
                      //                         'क्रशिग',
                      //                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //                 rows: [
                      //                   ...sortedHourlyCrushingData.entries.map<DataRow>(
                      //                         (entry) {
                      //                       double hour = entry.key;
                      //                       HourlyCrushingData horlyData = entry.value;
                      //                       return DataRow(
                      //                         cells: [
                      //                           DataCell(
                      //                             Text(
                      //                               hour.toString(),
                      //                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                      //                             ),
                      //                           ),
                      //                           DataCell(
                      //                             Padding(
                      //                               padding: EdgeInsets.symmetric(horizontal: 90.0),
                      //                               child: Text(
                      //                                 horlyData.crushingWt.toString(),
                      //                                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           // Add other DataCell widgets as needed
                      //                         ],
                      //                       );
                      //                     },
                      //                   ),
                      //                   // Additional row
                      //                   DataRow(
                      //                     cells: [
                      //                       DataCell(
                      //                         Text(
                      //                           'एकूण',
                      //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //                         ),
                      //                       ),
                      //                       DataCell(
                      //                         Padding(
                      //                           padding: EdgeInsets.symmetric(horizontal: 90.0),
                      //                           child: Text(
                      //                             totalHourCrushing.toStringAsFixed(3),
                      //                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       // Add other DataCell widgets as needed
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //
                      //             );
                      //           }
                      //
                      //           else {
                      //             // Display a message if the selected date is not today
                      //             return Center(
                      //               // child: Text(
                      //               //   'Data will not be available for selected date.',
                      //               //   style: TextStyle(color: Colors.black),
                      //               // ),
                      //             );
                      //           }
                      //         } else {
                      //           // Placeholder for no data
                      //           return Center(
                      //             child: Text(
                      //               'No data available.',
                      //               style: TextStyle(color: Colors.black),
                      //             ),
                      //           );
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),


              // Visibility(
              //   visible: formattedDate == _formatDate(DateTime.now()),
              //   child: Container(
              //     margin: EdgeInsets.all(10),
              //     color: verysmallgreen,
              //     padding: EdgeInsets.all(5),
              //     child: Column(
              //       children: [
              //         Center(
              //           child: Container(
              //             margin: EdgeInsets.only(top: 10),
              //             padding: EdgeInsets.all(5),
              //             child: Text(
              //               'क्रेनयार्ड शिल्लक ',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //
              //               ),
              //             ),
              //             decoration: BoxDecoration(
              //               color: darkgreen,
              //               border: Border.all(
              //                 color: Colors.black,
              //                 width: 2.0, // Set the width of the border
              //               ),
              //               borderRadius: BorderRadius.circular(
              //                   10.0), // Optionally, set border radius
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Container(
              //           padding: EdgeInsets.all(5),
              //           child: Card(
              //             elevation: 50,
              //             shadowColor: Colors.black,
              //             color: verysmallgreen,
              //             child: FutureBuilder<CaneYardResponse?>(
              //               future: _caneTypeCrushingFuture,
              //               builder: (context, snapshot) {
              //                 if (snapshot.connectionState == ConnectionState.waiting) {
              //                   // Loading state
              //                   return Container();
              //                 } else if (snapshot.hasError) {
              //                   // Error state
              //                   return Center(
              //                     child: Text(
              //                       'Error loading data. Please try again.',
              //                       style: TextStyle(color: Colors.red),
              //                     ),
              //                   );
              //                 } else if (snapshot.hasData) {
              //                   // Data available
              //                   CaneYardResponse caneYardResponse = snapshot.data!;
              //                   Map<String, CaneYardCrushingData> caneYardCrushingBeanMap = caneYardResponse.caneTypeCrushingBeanMap;
              //
              //                   bool isToday = formattedDate == _formatDate(DateTime.now());
              //                   sortedVehicleType = caneYardCrushingBeanMap.keys.toList()..sort();
              //                   Map<String, CaneYardCrushingData> sortedCaneTypeCrushingData = Map.fromEntries(sortedVehicleType.map((vehicleType) => MapEntry(vehicleType, caneYardCrushingBeanMap[vehicleType]!)));
              //                   if(isToday){
              //
              //                     return Container(
              //                       decoration: BoxDecoration(
              //                         border: Border.all(
              //
              //                           color: Colors.black, // Change color as needed
              //                           width: 2.0, // Adjust width as needed
              //                         ),
              //                         borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
              //                       ),
              //                       child: DataTable(
              //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                         columns: [
              //                           DataColumn(
              //                             label: Text(
              //                               'वाहन',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                           DataColumn(
              //                             label: Text(
              //                               'संख्या',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                           DataColumn(
              //                             label: Padding(
              //                               padding: EdgeInsets.symmetric(horizontal: 0.0), // Adjust the padding as needed
              //                               child: Text(
              //                                 'अपेक्षितटनेज',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ),
              //
              //                         ],
              //                         rows: sortedVehicleType.map<DataRow>((vehicleType) {
              //                           CaneYardCrushingData vehicleData = caneYardCrushingBeanMap[vehicleType]!;
              //                           return DataRow(
              //                             cells: [
              //                               DataCell(
              //                                 Text(
              //                                   vehicleType,
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                 ),
              //                               ),
              //                               DataCell(
              //                                 Text(
              //                                   vehicleData.cnt.toString(),
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                 ),
              //                               ),
              //                               DataCell(
              //                                 Padding(
              //                                   padding: EdgeInsets.symmetric(horizontal: 35.0), // Adjust the padding as needed
              //                                   child: Text(
              //                                     vehicleData.avgTonnage.toString(),
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ],
              //                           );
              //                         }).toList(),
              //                       ),
              //                     );
              //                   }
              //                   else {
              //                     // Display a message if the selected date is not today
              //                     return Center(
              //                     );
              //                   }
              //                 } else {
              //                   return Center(
              //                   );
              //                 }
              //               },
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //
              //   ),
              // ),




              SizedBox(
                height: 5,
              ),
              Visibility(
                visible: formattedDate == _formatDate(DateTime.now()),
                child: Container(
                  margin: EdgeInsets.all(10),
                  color: tabledata,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(10),

                          child: Container(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    width: 200,
                                    margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'प्रति तास क्रशिग',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      color: darkgreen,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Card(
                                  elevation: 250,
                                  shadowColor: myColor,
                                  color: tabledata,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: DataTable(
                                      headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'तास',
                                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 100.0),
                                            child: Text(
                                              'क्रशिग',
                                              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),

                                      ],
                                      rows: [
                                        ...sortedHourlyCrushingData.entries.map<DataRow>(
                                              (entry) {
                                                double hour = entry.key;
                                                HourlyCrushingData horlyData = entry.value;
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                                    child: Text(
                                                      hour.toString(),
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 90.0),
                                                    child: Text(
                                                      horlyData.crushingWt.toString(),
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   child: Card(
                      //     elevation: 50,
                      //     shadowColor: Colors.black,
                      //     color: verysmallgreen,
                      //     child: FutureBuilder<HourlyCrushingReponse?>(
                      //       future: _hourTypeCrushingFuture,
                      //       builder: (context, snapshot) {
                      //         if (snapshot.connectionState == ConnectionState.waiting) {
                      //           // Loading state
                      //           return Container();
                      //         }
                      //         else if (snapshot.hasError) {
                      //           return Center(
                      //             child: Text(
                      //               'Error loading data. Please try again.',
                      //               style: TextStyle(color: Colors.red),
                      //             ),
                      //           );
                      //         }
                      //
                      //         else if (snapshot.hasData) {
                      //           HourlyCrushingReponse hourlyResposne = snapshot.data!;
                      //           Map<double, HourlyCrushingData> hourlyCrushingBeanMap = hourlyResposne.hourlyTypeCrushingBeanMap;
                      //           bool isToday = formattedDate == _formatDate(DateTime.now());
                      //           sortedHours = hourlyCrushingBeanMap.keys.toList()..sort();
                      //           sortedHourlyCrushingData = Map.fromEntries(sortedHours.map((hour) => MapEntry(hour, hourlyCrushingBeanMap[hour]!)));
                      //           // Calculate the total of shiftData.shiftTodayCrushing for all entries in hourlyCrushingBeanMap
                      //           double totalHourCrushing = hourlyCrushingBeanMap.values
                      //               .map((hourlyData) => hourlyData.crushingWt)
                      //               .fold(0, (previous, current) => previous + current);
                      //           if (isToday) {
                      //             return Container(
                      //               decoration: BoxDecoration(
                      //                 //color: verysmallgreen,
                      //                 border: Border.all(
                      //                   color: Colors.black, // Change color as needed
                      //                   width: 2.0, // Adjust width as needed
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
                      //               ),
                      //               child: DataTable(
                      //                 headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
                      //                 columns: [
                      //                   DataColumn(
                      //                     label: Text(
                      //                       'तास',
                      //                       style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      //                     ),
                      //                   ),
                      //                   DataColumn(
                      //                     label: Padding(
                      //                       padding: EdgeInsets.symmetric(horizontal: 100.0),
                      //                       child: Text(
                      //                         'क्रशिग',
                      //                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //                 rows: [
                      //                   ...sortedHourlyCrushingData.entries.map<DataRow>(
                      //                         (entry) {
                      //                       double hour = entry.key;
                      //                       HourlyCrushingData horlyData = entry.value;
                      //                       return DataRow(
                      //                         cells: [
                      //                           DataCell(
                      //                             Text(
                      //                               hour.toString(),
                      //                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                      //                             ),
                      //                           ),
                      //                           DataCell(
                      //                             Padding(
                      //                               padding: EdgeInsets.symmetric(horizontal: 90.0),
                      //                               child: Text(
                      //                                 horlyData.crushingWt.toString(),
                      //                                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           // Add other DataCell widgets as needed
                      //                         ],
                      //                       );
                      //                     },
                      //                   ),
                      //                   // Additional row
                      //                   DataRow(
                      //                     cells: [
                      //                       DataCell(
                      //                         Text(
                      //                           'एकूण',
                      //                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //                         ),
                      //                       ),
                      //                       DataCell(
                      //                         Padding(
                      //                           padding: EdgeInsets.symmetric(horizontal: 90.0),
                      //                           child: Text(
                      //                             totalHourCrushing.toStringAsFixed(3),
                      //                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       // Add other DataCell widgets as needed
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //
                      //             );
                      //           }
                      //
                      //           else {
                      //             // Display a message if the selected date is not today
                      //             return Center(
                      //               // child: Text(
                      //               //   'Data will not be available for selected date.',
                      //               //   style: TextStyle(color: Colors.black),
                      //               // ),
                      //             );
                      //           }
                      //         } else {
                      //           // Placeholder for no data
                      //           return Center(
                      //             child: Text(
                      //               'No data available.',
                      //               style: TextStyle(color: Colors.black),
                      //             ),
                      //           );
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),





              SizedBox(
                height: 5,
              ),


              Container(
                width:double.infinity,
                margin: EdgeInsets.all(10),
                child: Visibility(
                  visible: !_isDateGreaterThanCurrentDate(selectedDate),
                  child: Container(
                   // color: verysmallgreen,
                    color: tabledata,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width:200,
                            margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              ' गटवार क्रशिग',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: darkgreen,
                              // border: Border.all(
                              //   color: Colors.black87,
                              //   width: 2.0,
                              // ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),


                        Card(
                          elevation: 250,
                          shadowColor: myColor,
                          color: tabledata,

                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: Colors.black,
                                //   width: 2.0,
                                // ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'विभाग',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                                      child: Text(
                                        'आज',
                                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'आजअखेर',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: [

                                  ...gatWiseTypeCrushingBeanMap.entries.map<DataRow>(

                                        (entry) {

                                      String department = entry.key;
                                      GatWiseCrushingData gatData = entry.value;
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                      Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:10),
                                            child:  Text(
                                              department,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                          ),
                                          DataCell(
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:10),
                                              child: Text(
                                                gatData.todayCrushing.toStringAsFixed(3),
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:10),
                                              child: Text(
                                                gatData.uptoTodayCrushingngWt.toStringAsFixed(3),
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                ],
                              ),
                            ),

                        ),
                      ],
                    ),
                  ),
                ),
              ),





              // Container(
              //   margin: EdgeInsets.all(10),
              //   child: Visibility(
              //     visible: !_isDateGreaterThanCurrentDate(selectedDate),
              //     child: Container(
              //       color: verysmallgreen,
              //       child: Column(
              //         children: [
              //           Center(
              //             child: Container(
              //               margin: EdgeInsets.only(top: 10, left: 20, right: 10),
              //               padding: EdgeInsets.all(5),
              //               child: Text(
              //                 ' गटवार क्रशिग',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              //               ),
              //               decoration: BoxDecoration(
              //                 color: darkgreen,
              //                 border: Border.all(
              //                   color: Colors.black87,
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 5,
              //           ),
              //           Container(
              //             padding: EdgeInsets.all(3.0),
              //             margin: EdgeInsets.all(0.0),
              //             child: Card(
              //               elevation: 50,
              //               shadowColor: Colors.black,
              //               color: verysmallgreen,
              //               child: FutureBuilder<GatWiseCrushingResponse?>(
              //                 future: _gatTypeCrushingFuture,
              //                 builder: (context, snapshot) {
              //                   if (snapshot.connectionState == ConnectionState.waiting) {
              //                     // Loading state
              //                     return Container();
              //                   } else if (snapshot.hasError) {
              //                     return Center(
              //                       child: Text(
              //                         'Error loading data. Please try again.',
              //                         style: TextStyle(color: Colors.red),
              //                       ),
              //                     );
              //                   } else if (snapshot.hasData) {
              //                     // Data available
              //                     GatWiseCrushingResponse gatWiseResponse = snapshot.data!;
              //                     Map<String, GatWiseCrushingData> gatWiseCrushingBeanMap = gatWiseResponse.gatWiseTypeCrushingBeanMap;
              //                     bool isToday = formattedDate == _formatDate(DateTime.now());
              //                     sortedDepartment = gatWiseCrushingBeanMap.keys.toList()..sort();
              //                     sortedDepartmentCrushingData = Map.fromEntries(sortedDepartment.map((department) => MapEntry(department, gatWiseCrushingBeanMap[department]!)));
              //
              //                     double totalTodayCrushing = gatWiseCrushingBeanMap.values
              //                         .map((gatData) => gatData.todayCrushing)
              //                         .fold(0, (previous, current) => previous + current);
              //
              //                     double totalYesterdayCrushing = gatWiseCrushingBeanMap.values
              //                         .map((gatData) => gatData.uptoTodayCrushingngWt)
              //                         .fold(0, (previous, current) => previous + current);
              //                     return SingleChildScrollView(
              //                       scrollDirection: Axis.horizontal,
              //                       child: Container(
              //                         decoration: BoxDecoration(
              //                           // color: verysmallgreen, // Set your desired background color
              //                           border: Border.all(
              //                             color: Colors.black, // Change color as needed
              //                             width: 2.0, // Adjust width as needed
              //                           ),
              //                           borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
              //                         ),
              //                         child: DataTable(
              //                           headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                           columns: [
              //                             DataColumn(
              //                               label: Text(
              //                                 'विभाग',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                             DataColumn(
              //                               label: Padding(
              //                                 padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                 child: Text(
              //                                   'आज',
              //                                   style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                                 ),
              //                               ),
              //                             ),
              //                             DataColumn(
              //                               label: Text(
              //                                 'आजअखेर',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                           rows: [
              //                             ...sortedDepartmentCrushingData.entries.map<DataRow>(
              //                                   (entry) {
              //                                 String department = entry.key;
              //                                 GatWiseCrushingData gatData = entry.value;
              //                                 return DataRow(
              //                                   cells: [
              //                                     DataCell(
              //                                       Text(
              //                                         department,
              //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                       ),
              //                                     ),
              //                                     DataCell(
              //                                       Padding(
              //                                         padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                         child: Text(
              //                                           gatData.todayCrushing.toStringAsFixed(3),
              //
              //                                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal,),
              //                                           textAlign: TextAlign.center,
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     DataCell(
              //                                       Text(
              //                                         gatData.uptoTodayCrushingngWt.toStringAsFixed(3),
              //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                         textAlign: TextAlign.left,
              //                                       ),
              //                                     ),
              //                                     // Add other DataCell widgets as needed
              //                                   ],
              //                                 );
              //                               },
              //                             ),
              //                             // Additional row
              //                             DataRow(
              //                               cells: [
              //                                 DataCell(
              //                                   Text(
              //                                     'एकूण',
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                   ),
              //                                 ),
              //                                 DataCell(
              //                                   Padding(
              //                                     padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                     child: Text(
              //                                       totalTodayCrushing.toStringAsFixed(3),
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                       textAlign: TextAlign.left,
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 DataCell(
              //                                   Text(
              //                                     totalYesterdayCrushing.toStringAsFixed(3),
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                     textAlign: TextAlign.left,
              //                                   ),
              //                                 ),
              //                                 // Add other DataCell widgets as needed
              //                               ],
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     );
              //                   } else {
              //                     return Center(
              //                       child: Text(
              //                         'No data available.',
              //                         style: TextStyle(color: Colors.black),
              //                       ),
              //                     );
              //
              //
              //
              //                   }
              //                 },
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),




              SizedBox(
                height: 5,
              ),





              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left:5,right:5),
                child: Visibility(
                  visible: !_isDateGreaterThanCurrentDate(selectedDate),
                  child: Container(
                    // color: verysmallgreen,
                    color: tabledata,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 200,
                            margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'हंगामनुसार क्रशिग',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: darkgreen,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 250,
                          shadowColor: myColor,
                          color: tabledata,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                              columns: [
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:15),
                                    child: Text(
                                      'हंगाम',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:15),
                                    child: Text(
                                      'आज',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:15),
                                    child: Text(
                                      'आजअखेर',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              rows: [
                                ...hangamCrushingBeanMap.entries.map<DataRow>(
                                      (entry) {
                                    String hangam = entry.key;
                                    HangamCrushingData hangamData = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                              hangam,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                              hangamData.todayCrushing.toStringAsFixed(3),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                              hangamData.uptoTodayCrushingngWt1.toStringAsFixed(3),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),



              // Container(
              //   margin: EdgeInsets.all(10),
              //   child: Visibility(
              //     visible: !_isDateGreaterThanCurrentDate(selectedDate),
              //     child: Container(
              //       color: verysmallgreen,
              //       child: Column(
              //         children: [
              //           Center(
              //             child: Container(
              //               margin: EdgeInsets.only(top: 10, left: 20, right: 10),
              //               padding: EdgeInsets.all(5),
              //               child: Text(
              //                 'हंगामनुसार क्रशिग',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              //               ),
              //               decoration: BoxDecoration(
              //                 color: darkgreen,
              //                 border: Border.all(
              //                   color: Colors.black87,
              //                   width: 2.0,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10.0),
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 5,
              //           ),
              //           Container(
              //             padding: EdgeInsets.all(0.0),
              //             margin: EdgeInsets.all(0.0),
              //             child: Card(
              //               elevation: 50,
              //               shadowColor: Colors.black,
              //               color: verysmallgreen,
              //               child: FutureBuilder<HangamWiseCrushingResponse?>(
              //                 future: _hangamTypeCrushingFuture,
              //                 builder: (context, snapshot) {
              //                   if (snapshot.connectionState == ConnectionState.waiting) {
              //                     return Container();
              //                     // Loading state
              //                     // return Center(
              //                     //   child: AnimatedCircularProgressIndicator(),
              //                     // );
              //                   } else if (snapshot.hasError) {
              //                     return Center(
              //                       child: Text(
              //                         'Error loading data. Please try again.',
              //                         style: TextStyle(color: Colors.red),
              //                       ),
              //                     );
              //                   } else if (snapshot.hasData) {
              //                     // Data available
              //                     HangamWiseCrushingResponse hangamWiseResponse = snapshot.data!;
              //                     Map<String, HangamCrushingData> hangamWiseCrushingBeanMap = hangamWiseResponse.hangamCrushingBeanMap;
              //                     bool isToday = formattedDate == _formatDate(DateTime.now());
              //                     sortedHangam = hangamWiseCrushingBeanMap.keys.toList()..sort();
              //                     sortedHangamCrushingData = Map.fromEntries(sortedHangam.map((hangam) => MapEntry(hangam, hangamWiseCrushingBeanMap[hangam]!)));
              //                     double totalTodayCrushing = hangamWiseCrushingBeanMap.values
              //                         .map((hangamData) => hangamData.todayCrushing)
              //                         .fold(0, (previous, current) => previous + current);
              //                     double totalYesterdayCrushing = hangamWiseCrushingBeanMap.values
              //                         .map((hangamData) => hangamData.uptoTodayCrushingngWt1)
              //                         .fold(0, (previous, current) => previous + current);
              //                     return SingleChildScrollView(
              //                       scrollDirection: Axis.horizontal,
              //                       child: Container(
              //                         //width: double.infinity,
              //                         decoration: BoxDecoration(
              //                           //color: verysmallgreen, // Set your desired background color
              //                           border: Border.all(
              //                             color: Colors.black, // Change color as needed
              //                             width: 2.0, // Adjust width as needed
              //                           ),
              //                           borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
              //                         ),
              //                         child: DataTable(
              //                           headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                           columns: [
              //                             DataColumn(
              //                               label: Text(
              //                                 'हंगाम',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                             DataColumn(
              //                               label: Padding(
              //                                 padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                 child: Text(
              //                                   'आज',
              //                                   style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                                 ),
              //                               ),
              //                             ),
              //                             DataColumn(
              //                               label: Text(
              //                                 'आजअखेर',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ],
              //                           rows: [
              //                             ...sortedHangamCrushingData.entries.map<DataRow>(
              //                                   (entry) {
              //                                 String hangam = entry.key;
              //                                 HangamCrushingData hangamData = entry.value;
              //                                 return DataRow(
              //                                   cells: [
              //                                     DataCell(
              //                                       Text(
              //                                         hangam,
              //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                       ),
              //                                     ),
              //                                     DataCell(
              //                                       Padding(
              //                                         padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                         child: Text(
              //                                           hangamData.todayCrushing.toStringAsFixed(3),
              //                                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     DataCell(
              //                                       Text(
              //                                         hangamData.uptoTodayCrushingngWt1.toStringAsFixed(3),
              //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                       ),
              //                                     ),
              //                                     // Add other DataCell widgets as needed
              //                                   ],
              //                                 );
              //                               },
              //                             ),
              //                             // Additional row
              //                             DataRow(
              //                               cells: [
              //                                 DataCell(
              //                                   Text(
              //                                     'एकूण',
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                   ),
              //                                 ),
              //                                 DataCell(
              //                                   Padding(
              //                                     padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                     child: Text(
              //                                       totalTodayCrushing.toStringAsFixed(3),
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 DataCell(
              //                                   Text(
              //                                     totalYesterdayCrushing.toStringAsFixed(3),
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                     textAlign: TextAlign.start,
              //                                   ),
              //                                 ),
              //                                 // Add other DataCell widgets as needed
              //                               ],
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     );
              //                   } else {
              //                     // Placeholder for no data
              //                     return Center(
              //                       child: Text(
              //                         'No data available.',
              //                         style: TextStyle(color: Colors.black),
              //                       ),
              //                     );
              //                   }
              //                 },
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),







              SizedBox(
                height: 20,
              ),


              Container(
                width: double.infinity,
               // margin: EdgeInsets.only(left:5,right:5),
                child: Visibility(
                  visible: !_isDateGreaterThanCurrentDate(selectedDate),
                  child: Container(
                    // color: verysmallgreen,
                    color: tabledata,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Align children vertically at the center
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 230,
                            margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'व्हरायटी नुसार  क्रशिग',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: darkgreen,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 250,
                          shadowColor: myColor,
                          color: tabledata,
                          child: Container(
                            width:double.infinity,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                              columns: [


                                DataColumn(
                                  label:
                                    //padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:15),
                                     Text(
                                      'व्हरायटी',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,

                                    ),

                                ),
                                DataColumn(
                                  label: Text(
                                      'आज',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),

                                ),
                                DataColumn(
                                  label: Text(
                                      'आजअखेर',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),

                                ),
                              ],
                              rows: [
                                ...varietyWiseCrushingBeanMap.entries.map<DataRow>(
                                      (entry) {
                                        String varietyName = entry.key;
                                        VarietyWiseCrushingData gatData = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                              varietyName,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),

                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                              gatData.todayCrushingWt.toStringAsFixed(3),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:10),
                                            child: Text(
                                              gatData.uptoTodayCrushingWt.toStringAsFixed(3),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              // Container(
              //   color: verysmallgreen,
              //   padding: EdgeInsets.all(0.0),
              //   margin: EdgeInsets.all(5.0),
              //   child: Visibility(
              //     visible: !_isDateGreaterThanCurrentDate(selectedDate),
              //     child: Column(
              //       children: [
              //         Center(
              //           child: Container(
              //             margin: EdgeInsets.only(top: 10, left: 20, right: 10),
              //             padding: EdgeInsets.all(5),
              //             child: Text(
              //               'व्हरायटी नुसार  क्रशिग',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              //             ),
              //             decoration: BoxDecoration(
              //               color: darkgreen,
              //               border: Border.all(
              //                 color: Colors.black87,
              //                 width: 2.0,
              //               ),
              //               borderRadius: BorderRadius.circular(10.0),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: Container(
              //             // padding: EdgeInsets.all(5.0),
              //             child: Card(
              //               elevation: 50,
              //               shadowColor: Colors.black,
              //               color: verysmallgreen,
              //               child: FutureBuilder<VarietyWiseCrushingResponse?>(
              //                 future: _varietyTypeCrushingFuture,
              //                 builder: (context, snapshot) {
              //                   if (snapshot.connectionState == ConnectionState.waiting) {
              //                     // Loading state
              //                     return Container();
              //                   } else if (snapshot.hasError) {
              //                     return Center(
              //                       child: Text(
              //                         'Error loading data. Please try again.',
              //                         style: TextStyle(color: Colors.red),
              //                       ),
              //                     );
              //                   } else if (snapshot.hasData) {
              //                     // Data available
              //                     VarietyWiseCrushingResponse varietyWiseResponse = snapshot.data!;
              //                     Map<String, VarietyWiseCrushingData> varietyWiseCrushingBeanMap = varietyWiseResponse.varietyWiseCrushingBeanMap;
              //                     bool isToday = formattedDate == _formatDate(DateTime.now());
              //                     sortedVariety = varietyWiseCrushingBeanMap.keys.toList()..sort();
              //                     sortedVarietyCrushingData = Map.fromEntries(sortedVariety.map((varietyName) => MapEntry(varietyName, varietyWiseCrushingBeanMap[varietyName]!)));
              //
              //                     double totalTodayCrushing = varietyWiseCrushingBeanMap.values
              //                         .map((gatData) => gatData.todayCrushingWt)
              //                         .fold(0, (previous, current) => previous + current);
              //
              //                     double totalYesterdayCrushing = varietyWiseCrushingBeanMap.values
              //                         .map((gatData) => gatData.uptoTodayCrushingWt)
              //                         .fold(0, (previous, current) => previous + current);
              //                     return Container(
              //                       decoration: BoxDecoration(
              //                         // color: verysmallgreen, // Set your desired background color
              //                         border: Border.all(
              //                           color: Colors.black, // Change color as needed
              //                           width: 2.0, // Adjust width as needed
              //                         ),
              //                         borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
              //                       ),
              //                       child: DataTable(
              //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                         columns: [
              //                           DataColumn(
              //                             label: Text(
              //                               'व्हरायटी',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                           DataColumn(
              //                             label: Padding(
              //                               padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                               child: Text(
              //                                 'आज',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ),
              //                           DataColumn(
              //                             label: Text(
              //                               'आजअखेर',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                         ],
              //                         rows: [
              //                           ...sortedVarietyCrushingData.entries.map<DataRow>(
              //                                 (entry) {
              //                               String varietyName = entry.key;
              //                               VarietyWiseCrushingData gatData = entry.value;
              //                               return DataRow(
              //                                 cells: [
              //                                   DataCell(
              //                                     Text(
              //                                       varietyName,
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                     ),
              //                                   ),
              //                                   DataCell(
              //                                     Padding(
              //                                       padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                       child: Text(
              //                                         gatData.todayCrushingWt.toStringAsFixed(3),
              //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   DataCell(
              //                                     Text(
              //                                       gatData.uptoTodayCrushingWt.toStringAsFixed(3),
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                     ),
              //                                   ),
              //                                   // Add other DataCell widgets as needed
              //                                 ],
              //                               );
              //                             },
              //                           ),
              //                           // Additional row
              //                           DataRow(
              //                             cells: [
              //                               DataCell(
              //                                 Text(
              //                                   'एकूण',
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                 ),
              //                               ),
              //                               DataCell(
              //                                 Padding(
              //                                   padding: EdgeInsets.symmetric(horizontal: 0.0),
              //                                   child: Text(
              //                                     totalTodayCrushing.toStringAsFixed(3),
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                   ),
              //                                 ),
              //                               ),
              //                               DataCell(
              //                                 Text(
              //                                   totalYesterdayCrushing.toStringAsFixed(3),
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                 ),
              //                                 // Add other DataCell widgets as needed
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   } else {
              //                     // Placeholder for no data
              //                     return Center(
              //                       child: Text(
              //                         'No data available.',
              //                         style: TextStyle(color: Colors.black),
              //                       ),
              //                     );
              //                   }
              //                 },
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 20,
              ),

              Container(
                width: double.infinity,
                 margin: EdgeInsets.only(left:7,right:5),
                child: Visibility(
                  visible: !_isDateGreaterThanCurrentDate(selectedDate),
                  child: Container(
                    // color: verysmallgreen,
                    color: tabledata,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Align children vertically at the center
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 270,
                            margin: EdgeInsets.only(top: 10, left: 20, right: 10),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'वाहन  प्रकार वार  क्रशिग',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: darkgreen,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 250,
                          shadowColor: myColor,
                          color: tabledata,
                          child: Container(
                            width:double.infinity,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith((states) => myColor),
                              columns: [


                                DataColumn(
                                  label:
                                  //padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:15),
                                  Text(
                                    'वाहन',
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,

                                  ),

                                ),
                                DataColumn(
                                  label: Text(
                                    'आज',
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),

                                ),
                                DataColumn(
                                  label: Text(
                                    'आजअखेर',
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),

                                ),
                              ],
                              rows: [
                                ...vehicleCrushingBeanMap.entries.map<DataRow>(
                                      (entry) {
                                        VehicleTypeWarData vehicleData = entry.value;
                                        String vvehicleType = entry.key;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                              vvehicleType,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),

                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
                                            child: Text(
                                        vehicleData.todayWt.toStringAsFixed(3),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.0,vertical:10),
                                            child: Text(
                                              vehicleData.todateWt.toStringAsFixed(3),
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),



              // Container(
              //   color: verysmallgreen,
              //   padding: EdgeInsets.all(10.0),
              //   margin: EdgeInsets.all(10.0),
              //   child: Visibility(
              //     visible: !_isDateGreaterThanCurrentDate(selectedDate),
              //     child: Column(
              //       children: [
              //         Center(
              //           child: Container(
              //             margin: EdgeInsets.only(top: 10, left: 20, right: 10),
              //             padding: EdgeInsets.all(5),
              //             child: Text(
              //               'वाहन  प्रकार वार  क्रशिग',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              //             ),
              //             decoration: BoxDecoration(
              //               color: darkgreen,
              //               border: Border.all(
              //                 color: Colors.black87,
              //                 width: 2.0,
              //               ),
              //               borderRadius: BorderRadius.circular(10.0),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: Container(
              //
              //             child: Card(
              //               elevation: 50,
              //               shadowColor: Colors.black,
              //               color: verysmallgreen,
              //               child: FutureBuilder<VehicleTypeWarCrushingResponse?>(
              //                 future: _vehicleTypeCrushingFuture,
              //                 builder: (context, snapshot) {
              //                   if (snapshot.connectionState == ConnectionState.waiting) {
              //                     // Loading state
              //                     return Container();
              //                   } else if (snapshot.hasError) {
              //                     // Error state
              //                     return Center(
              //                       child: Text(
              //                         'Error loading data. Please try again.',
              //                         style: TextStyle(color: Colors.red),
              //                       ),
              //                     );
              //                   } else if (snapshot.hasData) {
              //                     VehicleTypeWarCrushingResponse vehicleWarResponse = snapshot.data!;
              //                     Map<String, VehicleTypeWarData> vehicleWarCrushingBeanMap = vehicleWarResponse.vehicleCrushingBeanMap;
              //                     bool isToday = formattedDate == _formatDate(DateTime.now());
              //                     sortedVehicleType = vehicleWarCrushingBeanMap.keys.toList()..sort();
              //                     Map<String, VehicleTypeWarData> sortedCaneTypeCrushingData =
              //                     Map.fromEntries(sortedVehicleType.map((vvehicleType) => MapEntry(vvehicleType, vehicleWarCrushingBeanMap[vvehicleType]!)));
              //                     double totalTodayCrushing = vehicleWarCrushingBeanMap.values.map((vehicleData) => vehicleData.todayWt).fold(0, (previous, current) => previous + current);
              //
              //                     double totaluptoTodayCrushing =
              //                     vehicleWarCrushingBeanMap.values.map((vehicleData) => vehicleData.todateWt).fold(0, (previous, current) => previous + current);
              //                     return Container(
              //                       decoration: BoxDecoration(
              //                         border: Border.all(
              //                           color: Colors.black, // Change color as needed
              //                           width: 2.0, // Adjust width as needed
              //                         ),
              //                         borderRadius: BorderRadius.circular(5.0), // Set your desired border radius
              //                       ),
              //                       child: DataTable(
              //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallgreen),
              //                         columns: [
              //                           DataColumn(
              //                             label: Text(
              //                               'वाहन',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                           DataColumn(
              //                             label: Text(
              //                               'आज',
              //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                             ),
              //                           ),
              //                           DataColumn(
              //                             label: Padding(
              //                               padding: EdgeInsets.symmetric(horizontal: 0.0), // Adjust the padding as needed
              //                               child: Text(
              //                                 'आजअखेर',
              //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                         rows: [
              //                           ...sortedVehicleType.map<DataRow>(
              //                                 (vvehicleType) {
              //                               VehicleTypeWarData vehicleData = vehicleWarCrushingBeanMap[vvehicleType]!;
              //                               return DataRow(
              //                                 cells: [
              //                                   DataCell(
              //                                     Text(
              //                                       vvehicleType,
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                     ),
              //                                   ),
              //                                   DataCell(
              //                                     Text(
              //                                       vehicleData.todayWt.toStringAsFixed(3),
              //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                     ),
              //                                   ),
              //                                   DataCell(
              //                                     Padding(
              //                                       padding: EdgeInsets.symmetric(horizontal: 0.0), // Adjust the padding as needed
              //                                       child: Text(
              //                                         vehicleData.todateWt.toStringAsFixed(3),
              //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               );
              //                             },
              //                           ),
              //                           // Add another DataRow
              //                           DataRow(
              //                             cells: [
              //                               DataCell(
              //                                 Text(
              //                                   'एकूण',
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                 ),
              //                               ),
              //                               DataCell(
              //                                 Text(
              //                                   totalTodayCrushing.toStringAsFixed(3),
              //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                 ),
              //                               ),
              //                               DataCell(
              //                                 Padding(
              //                                   padding: EdgeInsets.symmetric(horizontal: 0.0), // Adjust the padding as needed
              //                                   child: Text(
              //                                     totaluptoTodayCrushing.toStringAsFixed(3),
              //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   } else {
              //                     return Center();
              //                   }
              //                 },
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 65,
          margin: EdgeInsets.all(5),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: bottomNavBarColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,

            selectedFontSize: 15,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dataset_sharp,
                  color: _selectedIndex == 0 ? Colors.white : Colors.white,
                ),
                label: 'ऊस गाळप',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dataset_sharp,
                  color: _selectedIndex == 1 ? Colors.white : Colors.white,
                ),
                label: 'चा. ऊस नोंद',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dataset_sharp,
                  color: _selectedIndex == 2 ? Colors.white : Colors.white,
                ),
                label: 'पु. ऊस नोंद',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dataset_sharp,
                  color: _selectedIndex == 3 ? Colors.white : Colors.white,
                ),
                label: 'विक्री / साठा',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dataset_sharp,
                  color: _selectedIndex == 4 ? Colors.white : Colors.white,
                ),
                label: 'उत्पादन',
              ),
            ],
          ),
        ),

      ),
    );
  }
  @override
  void dispose(){
    super.dispose();

  }
  bool _isDateGreaterThanCurrentDate(DateTime? selectedDate) {
    DateTime currentDate = DateTime.now();
    return selectedDate != null && selectedDate.isAfter(currentDate);
  }
  static String mapShiftNo(String originalShiftNo) {
    switch (originalShiftNo) {
      case "128.0":
        return "12-8";
      case "84.0":
        return "8-4";
      case "412.0":
        return "4-12";
      default:
        return originalShiftNo;
    }
  }
  // Future<CrushingResponse> crushingReport1(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
  //   try {
  //    // String uri ="http://117.205.2.18:8082/FlutterMIS/Reportcontroller";
  //
  //     String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
  //     String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
  //     String uri = '$baseUrl/Reportcontroller';
  //     Map<String, dynamic> requestBody = {
  //       'action': "crushingreport",
  //       'mobileNo': mobileNo,
  //       'imei': imei,
  //       'randomString': randomString,
  //       'versionId': versionId,
  //       'chitBoyId': chitBoyId,
  //       'date': date,
  //       'YearCode': yearCode,
  //     };
  //     String jsonBody = jsonEncode(requestBody);
  //     var res = await http.post(
  //       Uri.parse(uri),
  //       body: jsonBody,
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (res.statusCode == 200) {
  //       Map<String, dynamic> data = jsonDecode(res.body);
  //       final CrushingResponse crushingResponse = CrushingResponse.fromJson(data);
  //       setState(() {
  //         double todayCrushing = crushingResponse.todayCrushing;
  //         double uptoTodayCrushing = crushingResponse.uptoTodayCrushing;
  //       });
  //       return crushingResponse;
  //     } else {
  //       throw Exception("Failed to load data: ${res.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //     // Return a default CrushingResponse in case of an error
  //     return CrushingResponse();
  //   }
  // }
  //




  Future<CrushingResponse> crushingReport1(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl = ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "crushingreport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        final CrushingResponse crushingResponse = CrushingResponse.fromJson(data);
        return crushingResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      // Return a default CrushingResponse in case of an error
      return CrushingResponse();
    }
  }

  Future<ShiftCrushingResponse> getShiftWiseCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl = ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "crushingReportshiftwise",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(res.body);

        log("responseData: ${responseData}");
        return ShiftCrushingResponse.fromJson(responseData);
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print('Error: $error');
      return ShiftCrushingResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        shiftWiseCrushingBeanMap: {},
        success: false,
        update: false,
      );
    }
  }









  // Future<ShiftCrushingResponse> getShiftWiseCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
  //   try {
  //     //String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";
  //
  //     String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
  //     String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
  //     String uri = '$baseUrl/Reportcontroller';
  //     Map<String, dynamic> requestBody = {
  //       'action': "crushingReportshiftwise",
  //       'mobileNo': mobileNo,
  //       'imei': imei,
  //       'randomString': randomString,
  //       'versionId': versionId,
  //       'chitBoyId': chitBoyId,
  //       'date': date,
  //       'YearCode': yearCode,
  //     };
  //     String jsonBody = jsonEncode(requestBody);
  //     var res = await http.post(
  //       Uri.parse(uri),
  //       body: jsonBody,
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (res.statusCode == 200) {
  //       Map<String, dynamic> responseData  = jsonDecode(res.body);
  //       setState(() {
  //         data = responseData;
  //       });
  //       return ShiftCrushingResponse.fromJson(data);
  //
  //     } else {
  //
  //       throw Exception("Failed to load data: ${res.statusCode}");
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     return ShiftCrushingResponse(
  //       nsugTypeId: 0,
  //       nlocationId: 0,
  //       shiftWiseCrushingBeanMap: {},
  //       success: false,
  //       update: false,
  //     );
  //   }
  // }


  Future<CaneYardResponse> getCaneYardCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
     // String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "caneyardshilakreport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);

        print("data is : ${data}");
        final CaneYardResponse caneYardResponse = CaneYardResponse.fromJson(data);
        Map<String, CaneYardCrushingData> caneYardCrushingBeanMap = caneYardResponse.caneTypeCrushingBeanMap;
        List<String> sortedHours = caneYardCrushingBeanMap.keys.toList()..sort();
        for (String vehicleType in sortedHours) {
          CaneYardCrushingData value = caneYardCrushingBeanMap[vehicleType]!;
          num cnt = value.cnt;
          num avgTonnage = value.avgTonnage;

        }
        return caneYardResponse;
      } else {

        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return CaneYardResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        caneTypeCrushingBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  static Future<HourlyCrushingReponse> getHourlyCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
     // String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "hourlyCrushingReport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        final HourlyCrushingReponse hourlyCrushingReponse = HourlyCrushingReponse.fromJson(data);
        Map<double, HourlyCrushingData> hourlyCrushingBeanMap = hourlyCrushingReponse.hourlyTypeCrushingBeanMap;
        List<double> sortedHours = hourlyCrushingBeanMap.keys.toList()..sort();
        for (double hour in sortedHours) {
          HourlyCrushingData value = hourlyCrushingBeanMap[hour]!;
          num crushingWt = value.crushingWt;
        }
        return hourlyCrushingReponse;
      } else {

        throw Exception("Failed to load data: ${res.statusCode}");
      }
    }
    catch (error) {
      print("Error: ${error}");
      return HourlyCrushingReponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        hourlyTypeCrushingBeanMap: {},
      );
    }
  }
  static Future<GatWiseCrushingResponse> getSectionWiseCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
     // String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "gatWiseCrushingReport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(res.body);

        log("responseData: ${responseData}");
        return GatWiseCrushingResponse.fromJson(responseData);
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
      // if (res.statusCode == 200) {
      //   Map<String, dynamic> data = jsonDecode(res.body);
      //   final GatWiseCrushingResponse gatWiseResponse =GatWiseCrushingResponse.fromJson(data);
      //   Map<String, GatWiseCrushingData> gatWiseCrushingBeanMap = gatWiseResponse.gatWiseTypeCrushingBeanMap;
      //   List<String> sortedSection = gatWiseCrushingBeanMap.keys.toList()..sort();
      //   for (String department in sortedSection) {
      //     GatWiseCrushingData value = gatWiseCrushingBeanMap[department]!;
      //     num todayCrushing = value.todayCrushing;
      //     num uptoTodayCrushingngWt = value.uptoTodayCrushingngWt;
      //   }
      //   return gatWiseResponse;
      // }
      //
      // else {
      //
      //   throw Exception("Failed to load data: ${res.statusCode}");
      // }
    } catch (error) {
      print("Error: ${error}");
      return GatWiseCrushingResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        gatWiseTypeCrushingBeanMap: {},
      );
    }
  }
  static Future<HangamWiseCrushingResponse> getHangamWiseCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
     // String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "hangamWiseCrushingReport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        final HangamWiseCrushingResponse hangamWiseResponse =HangamWiseCrushingResponse.fromJson(data);
        Map<String, HangamCrushingData> hangamWiseCrushingBeanMap = hangamWiseResponse.hangamCrushingBeanMap;
        List<String> sortedSection = hangamWiseCrushingBeanMap.keys.toList()..sort();
        for (String hangam in sortedSection) {
          HangamCrushingData value = hangamWiseCrushingBeanMap[hangam]!;
          num todayCrushing = value.todayCrushing;
          num uptoTodayCrushingngWt = value.uptoTodayCrushingngWt1;
        }
        return hangamWiseResponse ;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return HangamWiseCrushingResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        hangamCrushingBeanMap: {},

      );
    }
  }
  static Future<VarietyWiseCrushingResponse> getVarietyWiseCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "varietyWiseCrushingReport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        print("HangamWise Crushing : $data");
        final VarietyWiseCrushingResponse varietyWiseCrushingResponse =VarietyWiseCrushingResponse.fromJson(data);
        Map<String, VarietyWiseCrushingData> varietyWiseCrushingBeanMap = varietyWiseCrushingResponse.varietyWiseCrushingBeanMap;
        List<String> sortedSection = varietyWiseCrushingBeanMap.keys.toList()..sort();
        for (String varietyName in sortedSection) {
          VarietyWiseCrushingData value = varietyWiseCrushingBeanMap[varietyName]!;
          num todayCrushingWt = value.todayCrushingWt;
          num uptoTodayCrushingWt = value.uptoTodayCrushingWt;
        }
        return varietyWiseCrushingResponse ;
      } else {

        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return VarietyWiseCrushingResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        varietyWiseCrushingBeanMap: {},
      );
    }
  }

  static Future<VehicleTypeWarCrushingResponse> getVehicleWarCrushing(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
    //  String uri = "http://117.205.2.18:8082/FlutterMIS/Reportcontroller";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/Reportcontroller';
      Map<String, dynamic> requestBody = {
        'action': "vehicleWarCrushingReport",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': yearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        print("VehicleTypeWarCrushingResponse result: ${data}");
        final VehicleTypeWarCrushingResponse vehicleWarResponse = VehicleTypeWarCrushingResponse.fromJson(data);
        Map<String, VehicleTypeWarData> vehicleCrushingBeanMap = vehicleWarResponse.vehicleCrushingBeanMap;
        List<String> sortedVehicleList = vehicleCrushingBeanMap.keys.toList()..sort();
        for (String vvehicleType in sortedVehicleList) {
          VehicleTypeWarData value = vehicleCrushingBeanMap[vvehicleType]!;
          num todayWt = value.todayWt;
          num todateWt = value.todateWt;
        }
        return vehicleWarResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return VehicleTypeWarCrushingResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        vehicleCrushingBeanMap: {},
      );
    }
  }
}






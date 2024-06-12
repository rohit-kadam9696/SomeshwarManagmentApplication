import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:SomeshwarManagementApp/pojo/month_hangam_cane_chalu_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import '../pojo/crushing_shiftwiseReport.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../pojo/month_variety_cane_chalu_response.dart';
import '../pojo/section_hangam_cane_chalu_response.dart';
import '../pojo/variety_hangam_cane_chalu_response.dart';
import '../progress_bar/animated_circular_progressbar.dart';
import '../ui/cha_us_nond.dart';
import '../ui/data_table.dart';
import '../ui/production_page.dart';
import '../ui/punar_us_nond.dart';
import '../ui/us_galap_activity.dart';
import '../ui/vikrisath_page.dart';

// Separate Stateful Widget Class
class ChaluUsNondWidget extends StatefulWidget {
  @override
  _ChaluUsNondWidgetWidgetState createState() => _ChaluUsNondWidgetWidgetState();
}

class _ChaluUsNondWidgetWidgetState extends State<ChaluUsNondWidget> {
  // State variables and methods go here

  // static Color darkyellow = const Color(0xFFF5E54F);
  // static Color smallyellow = const Color(0xFFFFF176);
  // static Color verysmallyellow = const Color(0xFFFFF59D);



  static Color darkyellow = Color(0xFFFFC104);
  static const Color smallyellow = Color(0xFFFFDD78);
  static const Color verysmallyellow = Color(0xFFFFECB2);

  late String chitBoyId;
  late String randomString;
  late String mobileNo;
  static String identifier = 'Identifier not available';
  static const Color brownColor = Color(0xFFB08401);

  late Future<VarietyHangamCaneResponse?> _varietyHangamCrushingFuture = Future.value();
  late Future<GatHangamCurrentCaneResponse?> _sectionHangamCrushingFuture = Future.value();
  late Future<MonthHangamCurrentCaneResponse?> _monthHangamCrushingFuture= Future.value();
  late Future<MonthVarietyCurrentCaneResponse?> _monthVarietyCrushingFuture = Future.value();




  Map<String, VarietyHangamCaneData> varietyHangamCaneBeanMap={};
  Map<String, GatHangamCaneData> gatHangamCaneBeanMap={};
  Map<String, MonthHangamCurrentData> monthHangamCaneBeanMap={};
  Map<String, MonthVarietyCurrentData> monthVarietyCaneBeanMap={};
  void initState() {
    super.initState();
    initData();

  }
  Future<void> initData() async {
    fetchData();
  }
  Future<void> fetchData() async {
    //  String randomString = await PreferencesHelper.getStoredUniqstring();


    // String chitBoyId = await PreferencesHelper.getStoredChitboyid();
    // String versionId = await AppInfo.getVersionId();
    // String mobileNo = await PreferencesHelper.getStoredMobileNo();
    // String YearCode = await PreferencesHelper.getstoreValuesInSharedPrefYearCode();
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String yearCode = await SharedPreferencesHelper.getYearCode();

    await callToApi(randomString, chitBoyId, versionId, mobileNo);
    _getDeviceInfo();
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
  Future<void> callToApi(String randomString, String chitBoyId, String versionId, String mobileNo) async {
    // String randomString = await PreferencesHelper.getStoredUniqstring();
    // String chitBoyId = await PreferencesHelper.getStoredChitboyid();
    // String versionId = await AppInfo.getVersionId();
    // String mobileNo = await PreferencesHelper.getStoredMobileNo();
    // String YearCode = await PreferencesHelper.getstoreValuesInSharedPrefYearCode();
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String yearCode = await SharedPreferencesHelper.getYearCode();


    _varietyHangamCrushingFuture = getVarietyHangamCaneCurrentNond(randomString, chitBoyId, identifier, versionId, mobileNo);
    _sectionHangamCrushingFuture=getGatHangamCaneCurrentNond(randomString, chitBoyId, identifier, versionId, mobileNo);
    _monthHangamCrushingFuture=getMonthHangamCaneCurrentNond(randomString, chitBoyId, identifier, versionId, mobileNo);
    _monthVarietyCrushingFuture=getMonthVarietyHangamCaneCurrentNond(randomString, chitBoyId, identifier, versionId, mobileNo);


    final varietyHangamCrushing= await _varietyHangamCrushingFuture;
    if (varietyHangamCrushing != null) {
      setState(() {
        varietyHangamCaneBeanMap = varietyHangamCrushing.varietyHangamCaneBeanMap;
       // sortedHourlyCrushingData = Map.fromEntries(varietyHangamCrushing.hourlyTypeCrushingBeanMap.entries.toList()..sort());
      });
      // Handling shift-wise data
      varietyHangamCrushing.varietyHangamCaneBeanMap.forEach((resourceName ,vhData) {
      });
    }


    final gatHangamCrushing= await _sectionHangamCrushingFuture;
    if (gatHangamCrushing != null) {
      setState(() {
        gatHangamCaneBeanMap = gatHangamCrushing.gatHangamCaneBeanMap;
        // sortedHourlyCrushingData = Map.fromEntries(varietyHangamCrushing.hourlyTypeCrushingBeanMap.entries.toList()..sort());
      });
      // Handling shift-wise data
      gatHangamCrushing.gatHangamCaneBeanMap.forEach((resourceName ,ghData) {
      });
    }


    final monthHangamCrushing= await _monthHangamCrushingFuture;
    if (monthHangamCrushing != null) {
      setState(() {
        monthHangamCaneBeanMap = monthHangamCrushing.monthHangamCaneBeanMap;
        // sortedHourlyCrushingData = Map.fromEntries(varietyHangamCrushing.hourlyTypeCrushingBeanMap.entries.toList()..sort());
      });
      // Handling shift-wise data
      monthHangamCrushing.monthHangamCaneBeanMap.forEach((resourceName ,mhData) {
      });
    }


    final monthVarietyCrushing= await _monthVarietyCrushingFuture;
    if (monthVarietyCrushing != null) {
      setState(() {
        monthVarietyCaneBeanMap = monthVarietyCrushing.monthVarietyCaneBeanMap;

      });

      monthVarietyCrushing.monthVarietyCaneBeanMap.forEach((resourceName ,mvData) {
      });
    }


  }
  void changeScreen() {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Navigator.pushReplacementNamed(context, '/usgalapPage');
    });
  }
  List<Widget> _screens = [
    UsGalapPage(),
    ChaUsNodPage(),
    PunarUsNodPage(),
    VikriSathaPage(),
    ProductionPage(),
  ];
  int _selectedIndex = 0;
  Color bottomNavBarColor = darkyellow;
  static const Color darkRed = Color(0xFFF44236);
  static const Color darkBlue = Color(0xFF008596);
  static const Color darkBlue1 = Color(0xFF2196F3);
  static Color darkgreen = const Color(0xFF4CAF50);


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
          // Navigate to the third page
          break;
        case 3:
          updateNavBarColor(darkRed);
          setState(() {
            bottomNavBarColor = darkRed;
          });
          // Navigate to the fourth page
          break;
        case 4:
          updateNavBarColor(darkBlue1);
          setState(() {
            bottomNavBarColor = darkBlue1;
          });
          // Navigate to the fifth page
          break;

        default:
        // Default case
          setState(() {
            bottomNavBarColor = darkgreen;
          });
      }
    }
  }

  void updateNavBarColor(Color color) {
    setState(() {
      bottomNavBarColor = color;
    });
  }




  Widget someshowarHeading() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: AppBar(
          leading: Container(
            margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            padding: EdgeInsets.only(right: 2.0, bottom: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: smallyellow,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_circle_left_outlined),
              onPressed: () {
                if (mounted) {
                  changeScreen();
                }
              },
              color: Colors.black,
              iconSize: 30.0,
            ),
          ),
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
          backgroundColor: brownColor,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 2.0, bottom: 5),
              margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: smallyellow,
              ),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  String randomString = await SharedPreferencesHelper.getUniqString();
                  String chitBoyId = await SharedPreferencesHelper.getChitboyId();
                  String versionId = await AppInfo.getVersionId();
                  String mobileNo = await SharedPreferencesHelper.getMobileNo();
                  String yearCode = await SharedPreferencesHelper.getYearCode();

                  await callToApi(randomString, chitBoyId, versionId, mobileNo);
                  setState(() {});
                },
                color: Colors.black,
                iconSize: 30.0,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(right: 2.0, bottom: 5),
            //   margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: smallyellow,
            //   ),
            //   child: IconButton(
            //     icon: Icon(Icons.arrow_circle_right_outlined), // Change this icon as per your requirement
            //     onPressed: () {
            //      if(mounted){
            //        Navigator.push(
            //          context,
            //          MaterialPageRoute(builder: (context) => PunarUsNodPage()),
            //        );
            //      }
            //     },
            //     color: Colors.black,
            //     iconSize: 30.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget cmahinaHangamUsNondTitle(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(5),
      child: Text(
        'व्हरायटी / हंगामवार ऊस नोंद माहिती',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
        color: darkyellow,
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2.0,
        // ),
        borderRadius: BorderRadius.circular(10.0),
      ),

    );
  }

  Widget cmahinaHangamUsNondColumnDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(

        //width:double.infinity,
        margin: EdgeInsets.only(left:10,right:10),

          child: Column(
            children: [
              SizedBox(height: 20),
              Card(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(12.0),
                // ),
                elevation: 200,
                shadowColor:smallyellow,
                color: verysmallyellow,
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(
                       color: verysmallyellow,
                    //   width: 2.0,
                    // ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
                    columns: [
                      DataColumn(
                        label: Text(
                          'व्हरायटी',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'अडसाली',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'पु. हंगाम',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'चा.हंगाम',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'खोडवा',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'एकूण',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      ...varietyHangamCaneBeanMap.entries.map<DataRow>(
                            (entry) {
                          String resourceName = entry.key;
                          VarietyHangamCaneData vhData = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  resourceName,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  vhData.value1.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    vhData.value2.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    vhData.value3.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    vhData.value4.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    vhData.value5.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // DataRow(
                      //   cells: [
                      //     DataCell(
                      //       Text(
                      //         'एकूण',
                      //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Text(
                      //         value1Total.toStringAsFixed(2),
                      //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: Text(
                      //           value2Total.toStringAsFixed(2),
                      //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Text(
                      //         value3Total.toStringAsFixed(2),
                      //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: Text(
                      //           value4Total.toStringAsFixed(2),
                      //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: Text(
                      //           value5Total.toStringAsFixed(2),
                      //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }




  // Widget cmahinaHangamUsNondColumnDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //
  //       child: Container(
  //         // color: verysmallyellow,
  //         padding: EdgeInsets.all(5),
  //         child: Column(
  //           children: [
  //             SizedBox(height: 20),
  //             Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //               ),
  //               elevation: 50,
  //               shadowColor: Colors.black,
  //               color: verysmallyellow,
  //               child: FutureBuilder<VarietyHangamCaneResponse?>(
  //                 future: _varietyHangamCrushingFuture,
  //                 builder: (context, AsyncSnapshot<VarietyHangamCaneResponse?> snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                    return Container();
  //
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   }
  //                   else if (snapshot.hasData) {
  //
  //                     VarietyHangamCaneResponse vhResponse = snapshot.data!;
  //                     Map<String, VarietyHangamCaneData> vhCrushingBeanMap = vhResponse.varietyHangamCaneBeanMap;
  //
  //                     double value1Total = vhCrushingBeanMap.values
  //                         .map((vhData) => vhData.value1)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value2Total = vhCrushingBeanMap.values
  //                         .map((vhData) => vhData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value3Total = vhCrushingBeanMap.values
  //                         .map((vhData) => vhData.value3)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value4Total = vhCrushingBeanMap.values
  //                         .map((vhData) => vhData.value4)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value5Total = vhCrushingBeanMap.values
  //                         .map((vhData) => vhData.value5)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'व्हरायटी',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'अडसाली',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'पु. हंगाम',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'चा.हंगाम',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'खोडवा',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'एकूण',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...vhCrushingBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               VarietyHangamCaneData vhData = entry.value;
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       resourceName,
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       vhData.value1.toStringAsFixed(2),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value2.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value3.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value4.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value5.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           ),
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
  //                                   value1Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     value2Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value3Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     value4Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     value5Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }
  //
  //                   else {
  //                     return Container();
  //                   }
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //     ),
  //   );
  // }





  Widget inBetweenSizeBox(){
    return SizedBox(height: 10,);
  }

  Widget gatHangamWarCurrentCaneTitle(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(5),
      child: Text(
        'गट / हंगामवार ऊस नोंद माहिती',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
        color: darkyellow,
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2.0,
        // ),
        borderRadius: BorderRadius.circular(10.0),
      ),

    );
  }

  Widget csectionHangamUsNondColumnDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left:10,right:10),

          child: Column(
            children: [
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 200,
                shadowColor: smallyellow,
                color: verysmallyellow,
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(
                      color: verysmallyellow,
                    //   width: 2.0,
                    // ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
                    columns: [
                      DataColumn(
                        label: Text(
                          'गट',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'अडसाली',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'पु. हंगाम',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'चा.हंगाम',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Text(
                            'खोडवा',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'एकूण',
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      ...gatHangamCaneBeanMap.entries.map<DataRow>(
                            (entry) {
                          String resourceName = entry.key;
                          GatHangamCaneData ghData = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  resourceName,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                              ),
                              DataCell(
                                Text(
                                  ghData.value1.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    ghData.value2.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    ghData.value3.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    ghData.value4.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    ghData.value5.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // DataRow(
                      //   cells: [
                      //     DataCell(
                      //       Text(
                      //         'एकूण',
                      //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Text(
                      //         value1Total.toStringAsFixed(2),
                      //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: Text(
                      //           value2Total.toStringAsFixed(2),
                      //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Text(
                      //         value3Total.toStringAsFixed(2),
                      //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: Text(
                      //           value4Total.toStringAsFixed(2),
                      //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //     DataCell(
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: Text(
                      //           value5Total.toStringAsFixed(2),
                      //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),

      ),
    );
  }












  // Widget csectionHangamUsNondColumnDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //
  //       child: Container(
  //         //  color: verysmallyellow,
  //         padding: EdgeInsets.all(5),
  //         child: Column(
  //           children: [
  //             SizedBox(height: 20),
  //             Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //               ),
  //               elevation: 50,
  //               shadowColor: Colors.black,
  //               color: verysmallyellow,
  //               child: FutureBuilder<GatHangamCurrentCaneResponse?>(
  //                 future: _sectionHangamCrushingFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     GatHangamCurrentCaneResponse ghResponse = snapshot.data!;
  //                     Map<String, GatHangamCaneData> ghCrushingBeanMap = ghResponse.gatHangamCaneBeanMap;
  //
  //                     double value1Total = ghCrushingBeanMap.values
  //                         .map((ghData) => ghData.value1)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value2Total = ghCrushingBeanMap.values
  //                         .map((ghData) => ghData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value3Total = ghCrushingBeanMap.values
  //                         .map((ghData) => ghData.value3)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value4Total = ghCrushingBeanMap.values
  //                         .map((ghData) => ghData.value4)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value5Total = ghCrushingBeanMap.values
  //                         .map((ghData) => ghData.value5)
  //                         .fold(0, (previous, current) => previous + current);
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'गट',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'अडसाली',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'पु. हंगाम',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'चा.हंगाम',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'खोडवा',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'एकूण',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...ghCrushingBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               GatHangamCaneData ghData = entry.value;
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       resourceName,
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       ghData.value1.toStringAsFixed(2),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value2.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value3.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value4.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value5.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           ),
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
  //                                   value1Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     value2Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value3Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     value4Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     value5Total.toStringAsFixed(2),
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
  //                     return Container();
  //                   }
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget mahinaHangamCurrentCaneTitle(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(5),
      child: Text(
        'महिना / हंगामवार ऊस नोंद माहिती',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
        color: darkyellow,
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2.0,
        // ),
        borderRadius: BorderRadius.circular(10.0),
      ),

    );
  }

  Widget cmonthHangamUsNondColumnDetails(Map<String, MonthHangamCurrentData> monthHangamCaneBeanMap) {
    List<MapEntry<String, MonthHangamCurrentData>> sortedEntries =
        monthHangamCaneBeanMap.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    double value1Total = monthHangamCaneBeanMap.values
        .map((mhData) => mhData.value1)
        .fold(0, (previous, current) => previous + current);

    double value2Total = monthHangamCaneBeanMap.values
        .map((mhData) => mhData.value2)
        .fold(0, (previous, current) => previous + current);

    double value3Total = monthHangamCaneBeanMap.values
        .map((mhData) => mhData.value3)
        .fold(0, (previous, current) => previous + current);

    double value4Total = monthHangamCaneBeanMap.values
        .map((mhData) => mhData.value4)
        .fold(0, (previous, current) => previous + current);

    double value5Total = monthHangamCaneBeanMap.values
        .map((mhData) => mhData.value5)
        .fold(0, (previous, current) => previous + current);

    sortedEntries.add(
      MapEntry(
        'एकूण',
        MonthHangamCurrentData(
          value1: value1Total,
          value2: value2Total,
          value3: value3Total,
          value4: value4Total,
          value5: value5Total,
          resourceName: 'एकूण',
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),

        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 200,
              shadowColor: smallyellow,
              color: verysmallyellow,
              child: Container(
               // padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: verysmallyellow,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => smallyellow),
                  columns: [
                    DataColumn(
                      label: Text(
                        'महिना',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'अडसाली',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                      //  padding: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'पु. हंगाम',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'चा.हंगाम',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                       padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'खोडवा',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                       padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'एकूण',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: sortedEntries.map<DataRow>(
                    (entry) {
                      String resourceName = entry.key;
                      MonthHangamCurrentData mhData = entry.value;
                      bool isTotalRow = resourceName == 'एकूण';
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              resourceName,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                          DataCell(
                            Text(
                              mhData.value1.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ),
                          DataCell(
                            Padding(
                              //padding: EdgeInsets.symmetric(horizontal: 15.0),
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: Text(
                                mhData.value2.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                             // padding: EdgeInsets.symmetric(horizontal: 15.0),
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: Text(
                                mhData.value3.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              //padding: EdgeInsets.symmetric(horizontal: 15.0),
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: Text(
                                mhData.value4.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              //padding: EdgeInsets.symmetric(horizontal: 15.0),
                              padding: EdgeInsets.symmetric(horizontal: 0.0),
                              child: Text(
                                mhData.value5.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mahinaVarietyCurrentCaneTitle(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(5),
      child: Text(
        'महिना / व्हरायटी वार  ऊस नोंद माहिती',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
        color: darkyellow,
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2.0,
        // ),
        borderRadius: BorderRadius.circular(10.0),
      ),

    );
  }


  Widget cmonthVarietyUsNondColumnDetails(Map<String, MonthVarietyCurrentData> monthVarietyCaneBeanMap) {
    List<MapEntry<String, MonthVarietyCurrentData>> sortedEntries = monthVarietyCaneBeanMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    double value1Total = monthVarietyCaneBeanMap.values
        .map((mvData) => mvData.value1)
        .fold(0, (previous, current) => previous + current);

    double value2Total = monthVarietyCaneBeanMap.values
        .map((mvData) => mvData.value2)
        .fold(0, (previous, current) => previous + current);

    double value3Total = monthVarietyCaneBeanMap.values
        .map((mvData) => mvData.value3)
        .fold(0, (previous, current) => previous + current);

    double value4Total = monthVarietyCaneBeanMap.values
        .map((mvData) => mvData.value4)
        .fold(0, (previous, current) => previous + current);

    double value5Total = monthVarietyCaneBeanMap.values
        .map((mvData) => mvData.value5)
        .fold(0, (previous, current) => previous + current);
    sortedEntries.add(
      MapEntry(
        'एकूण',
        MonthVarietyCurrentData(
          value1: value1Total,
          value2: value2Total,
          value3: value3Total,
          value4: value4Total,
          value5: value5Total,
          resourceName: 'एकूण',
        ),
      ),
    );


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        //color:smallyellow,
        margin: EdgeInsets.symmetric(horizontal: 5),
        //padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
             SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 200,
              shadowColor: smallyellow,
              color: verysmallyellow,
              child: Container(

                decoration: BoxDecoration(
                  color: verysmallyellow,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
                  columns: [
                    DataColumn(
                      label: Text(
                        'महिना',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'CO-86032',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'CO-265',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                      //  padding: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'VSI-10001',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'इतर',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'एकूण',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: sortedEntries.map<DataRow>(
                        (entry) {
                          String resourceName = entry.key;
                          MonthVarietyCurrentData mvData = entry.value;
                          bool isTotalRow = resourceName == 'एकूण';
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              resourceName,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
                            ),
                          ),
                          DataCell(
                            Text(
                              mvData.value1.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                mvData.value2.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                mvData.value3.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                mvData.value4.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                mvData.value5.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }

  // Widget cmonthVarietyUsNondColumnDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //
  //       child: Container(
  //         //color: verysmallyellow,
  //         padding: EdgeInsets.all(5),
  //         child: Column(
  //           children: [
  //
  //             SizedBox(height: 20),
  //             Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12.0),
  //               ),
  //               elevation: 50,
  //               shadowColor: Colors.black,
  //               color: verysmallyellow,
  //               child: FutureBuilder<MonthVarietyCurrentCaneResponse?>(
  //                 future: _monthVarietyCrushingFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   }
  //                   else if (snapshot.hasData) {
  //                     MonthVarietyCurrentCaneResponse mvResponse = snapshot.data!;
  //                     Map<String, MonthVarietyCurrentData> mvCrushingBeanMap = mvResponse.monthVarietyCaneBeanMap;
  //                     double value1Total = mvCrushingBeanMap.values
  //                         .map((mvData) => mvData.value1)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value2Total = mvCrushingBeanMap.values
  //                         .map((mvData) => mvData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value3Total = mvCrushingBeanMap.values
  //                         .map((mvData) => mvData.value3)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value4Total = mvCrushingBeanMap.values
  //                         .map((mvData) => mvData.value4)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value5Total = mvCrushingBeanMap.values
  //                         .map((mvData) => mvData.value5)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     List<MapEntry<String, MonthVarietyCurrentData>> sortedEntries = mvCrushingBeanMap.entries.toList()
  //                       ..sort((a, b) => a.key.compareTo(b.key));
  //
  //                     sortedEntries.add(
  //                       MapEntry(
  //                         'एकूण',
  //                         MonthVarietyCurrentData(
  //                           value1: value1Total,
  //                           value2: value2Total,
  //                           value3: value3Total,
  //                           value4: value4Total,
  //                           value5: value5Total,
  //                           resourceName: 'एकूण',
  //                         ),
  //                       ),
  //                     );
  //
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'महिना ',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'CO-86032',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'CO-265',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'VSI-10001',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'इतर',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'एकूण',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: sortedEntries.map<DataRow>((entry) {
  //                           String resourceName = entry.key;
  //                           MonthVarietyCurrentData mvData = entry.value;
  //                           bool isTotalRow = resourceName == 'एकूण';
  //                           return DataRow(
  //                             cells: [
  //                               DataCell(
  //                                 Text(
  //                                   resourceName,
  //                                   style: TextStyle(fontSize: 15, fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   mvData.value1.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15, fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     mvData.value2.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     mvData.value3.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     mvData.value4.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                   child: Text(
  //                                     mvData.value5.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15, fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal),
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
  //                     return Container();
  //                   }
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
               width:double.infinity,
          child: Column(
            children: [
              someshowarHeading(),
              cmahinaHangamUsNondTitle(),
              cmahinaHangamUsNondColumnDetails(),
              inBetweenSizeBox(),
              gatHangamWarCurrentCaneTitle(),
              inBetweenSizeBox(),
              csectionHangamUsNondColumnDetails(),
              inBetweenSizeBox(),
              mahinaHangamCurrentCaneTitle(),
              inBetweenSizeBox(),
              // cmonthHangamUsNondColumnDetails(),
             // cmonthHangamUsNondColumnDetails(monthHangamCurrentCaneResponse),
              cmonthHangamUsNondColumnDetails(monthHangamCaneBeanMap),

              inBetweenSizeBox(),
              mahinaVarietyCurrentCaneTitle(),
              inBetweenSizeBox(),
              cmonthVarietyUsNondColumnDetails(monthVarietyCaneBeanMap),
            ],
          ),
        ),
      ),

    );

  }
  static Future<VarietyHangamCaneResponse> getVarietyHangamCaneCurrentNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo,) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/CurrentCaneNond";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/CurrentCaneNond';
      Map<String, dynamic> requestBody = {
        'action': "varietyhangamusnond",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
      };
      String jsonBody = jsonEncode(requestBody);

      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        final VarietyHangamCaneResponse varietyHangamCaneResponse = VarietyHangamCaneResponse.fromJson(data);
        Map<String, VarietyHangamCaneData>varietyHangamCaneBeanMap = varietyHangamCaneResponse.varietyHangamCaneBeanMap;
        List<String> sortedVarieties = varietyHangamCaneBeanMap.keys.toList()..sort();
        for (String variety in sortedVarieties) {
          VarietyHangamCaneData value = varietyHangamCaneBeanMap[variety]!;
          double value1 = value.value1;
          double value2 = value.value2;
          double value3 = value.value3;
          double value4 = value.value4;
          double value5 = value.value5;
          String resourceName = value.resourceName;
        }
        return varietyHangamCaneResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return VarietyHangamCaneResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        varietyHangamCaneBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  Future<GatHangamCurrentCaneResponse> getGatHangamCaneCurrentNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo) async {
    try {
   //   String uri = "http://117.205.2.18:8082/FlutterMIS/CurrentCaneNond";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/CurrentCaneNond';
      Map<String, dynamic> requestBody = {
        'action': "gathangamusnond",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        // print("GatHangamCane: ${data}");
        final GatHangamCurrentCaneResponse gatHangamCurrentCaneResponse = GatHangamCurrentCaneResponse.fromJson(data);
        Map<String, GatHangamCaneData>gatHangamCaneBeanMap = gatHangamCurrentCaneResponse.gatHangamCaneBeanMap;
        List<String> sortedGat = gatHangamCaneBeanMap.keys.toList()..sort();
        for (String section in sortedGat) {
          GatHangamCaneData value = gatHangamCaneBeanMap[section]!;
          double value1 = value.value1;
          double value2 = value.value2;
          double value3 = value.value3;
          double value4 = value.value4;
          double value5 = value.value5;
          String resourceName = value.resourceName;
        }
        return gatHangamCurrentCaneResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return GatHangamCurrentCaneResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        gatHangamCaneBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  Future<MonthHangamCurrentCaneResponse> getMonthHangamCaneCurrentNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/CurrentCaneNond";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/CurrentCaneNond';
      Map<String, dynamic> requestBody = {
        'action': "monthhangamusnond",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        final MonthHangamCurrentCaneResponse monthHangamCurrentCaneResponse = MonthHangamCurrentCaneResponse.fromJson(data);
        Map<String, MonthHangamCurrentData>monthHangamCaneBeanMap = monthHangamCurrentCaneResponse.monthHangamCaneBeanMap;
        List<String> sortmonth = monthHangamCaneBeanMap.keys.toList()..sort();
        for (String month in sortmonth) {
          MonthHangamCurrentData value = monthHangamCaneBeanMap[month]!;
          double value1 = value.value1;
          double value2 = value.value2;
          double value3 = value.value3;
          double value4 = value.value4;
          double value5 = value.value5;
          String resourceName = value.resourceName;
        }
        return monthHangamCurrentCaneResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return MonthHangamCurrentCaneResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        monthHangamCaneBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  Future<MonthVarietyCurrentCaneResponse> getMonthVarietyHangamCaneCurrentNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo) async {
    try {
    //  String uri = "http://117.205.2.18:8082/FlutterMIS/CurrentCaneNond";
      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/CurrentCaneNond';
      Map<String, dynamic> requestBody = {
        'action': "monthvarietyusnond",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        final MonthVarietyCurrentCaneResponse monthVarietyCurrentCaneResponse = MonthVarietyCurrentCaneResponse.fromJson(data);
        Map<String, MonthVarietyCurrentData> monthVarietyCaneBeanMap = monthVarietyCurrentCaneResponse.monthVarietyCaneBeanMap;
        List<String> sortMonth = monthVarietyCaneBeanMap.keys.toList()..sort();
        for (String month in sortMonth) {
          MonthVarietyCurrentData value = monthVarietyCaneBeanMap[month]!;
          double value1 = value.value1;
          double value2 = value.value2;
          double value3 = value.value3;
          double value4 = value.value4;
          double value5 = value.value5;
          String resourceName = value.resourceName;
        }
        return monthVarietyCurrentCaneResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return MonthVarietyCurrentCaneResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        monthVarietyCaneBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
}


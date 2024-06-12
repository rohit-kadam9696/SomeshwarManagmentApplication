import 'package:SomeshwarManagementApp/ui/vikrisath_page.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../pojo/month_hangam_cane_chalu_response.dart';
import '../pojo/month_variety_cane_chalu_response.dart';
import '../pojo/pudil_variety_hangam_response.dart';
import '../pojo/section_hangam_cane_chalu_response.dart';
import '../progress_bar/animated_circular_progressbar.dart';
import '../ui/punar_us_nond.dart';
class PudilUsNond extends StatefulWidget {
  const PudilUsNond({super.key});

  @override
  State<PudilUsNond> createState() => _PudilUsNondState();
}

class _PudilUsNondState extends State<PudilUsNond> {

  late Future<PurviCaneNondVhangamResponse?> _varietyHangamCrushingFuture = Future.value();
  late Future<GatHangamCurrentCaneResponse?> _sectionHangamCrushingFuture = Future.value();
  late Future<MonthHangamCurrentCaneResponse?> _monthHangamCrushingFuture = Future.value();
  late Future<MonthVarietyCurrentCaneResponse?> _monthVarietyCrushingFuture = Future.value();


  Map<String, PurviVarietyHangamCaneData> purviVarietyHangamCaneBeanMap={};
  Map<String, GatHangamCaneData> gatHangamCaneBeanMap={};
  Map<String, MonthHangamCurrentData> monthHangamCaneBeanMap={};
  Map<String, MonthVarietyCurrentData> monthVarietyCaneBeanMap={};




  static const Color topBottom = Color(0xFF008596);
  static Color darkBlue = const Color(0xFF5AE2F5);
  //static Color smalldarkBlue = const Color(0xFF75DDEB);
  static Color smalldarkBlue = const Color(0xFF5AE2F5).withOpacity(0.8);

  // static Color verysmalldarkBlue = const Color(0xFFB4EBF2);
  static Color verysmalldarkBlue = const Color(0xFF75DDEB).withOpacity(0.8);

  late String chitBoyId;
  late String randomString;
  late String mobileNo;
  static String identifier = 'Identifier not available';

  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    fetchData();
  }

  Future<void> fetchData() async {
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
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
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    _varietyHangamCrushingFuture = getPudhilVarietyHangamCaneNond(randomString, chitBoyId, identifier, versionId, mobileNo);
    _sectionHangamCrushingFuture = getPudhilGatHangamCaneNond(randomString, chitBoyId, identifier, versionId, mobileNo);
    _monthHangamCrushingFuture = getMonthHangamCaneCurrentNond(randomString, chitBoyId, identifier, versionId, mobileNo);
    _monthVarietyCrushingFuture = getPudhilMonthVarietyHangamCaneNond(randomString, chitBoyId, identifier, versionId, mobileNo);

    final varietyHangamCrushing= await _varietyHangamCrushingFuture;
    if (varietyHangamCrushing != null) {
      setState(() {
        purviVarietyHangamCaneBeanMap = varietyHangamCrushing.purviVarietyHangamCaneBeanMap;

      });

      varietyHangamCrushing.purviVarietyHangamCaneBeanMap.forEach((resourceName ,mvData) {
      });
    }
    final sectionHangamCrushing= await _sectionHangamCrushingFuture;
    if (sectionHangamCrushing != null) {
      setState(() {
        gatHangamCaneBeanMap = sectionHangamCrushing.gatHangamCaneBeanMap;

      });

      sectionHangamCrushing.gatHangamCaneBeanMap.forEach((resourceName ,mvData) {
      });
    }

    final monthHangamCrushing= await _monthHangamCrushingFuture;
    if (monthHangamCrushing != null) {
      setState(() {
        monthHangamCaneBeanMap = monthHangamCrushing.monthHangamCaneBeanMap;

      });

      monthHangamCrushing.monthHangamCaneBeanMap.forEach((resourceName ,mvData) {
      });
    }


    final monthVarietyCaneCrushing= await _monthVarietyCrushingFuture;
    if (monthVarietyCaneCrushing != null) {
      setState(() {
        monthVarietyCaneBeanMap = monthVarietyCaneCrushing.monthVarietyCaneBeanMap;

      });

      monthVarietyCaneCrushing.monthVarietyCaneBeanMap.forEach((resourceName ,mvData) {
      });
    }




  }
  void changeScreen() {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Navigator.pushReplacementNamed(context, '/chaUsNond');
    });
  }

  Widget someshowarHeading() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: Container(
        margin: EdgeInsets.only(top: 20),

        child: AppBar(

          leading: Container(

            padding: EdgeInsets.only(right: 2.0, bottom: 5,),
            margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: smalldarkBlue,

            ),
            child: IconButton(

              icon: Icon(Icons.arrow_circle_left_outlined,),
              onPressed: () {
                if(mounted){
                  changeScreen();
                }
              },
              color: Colors.white,
              iconSize: 30.0,
            ),
          ),
          title: Container(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: Text(
              'श्री सोमेश्वर स.सा.का.लि',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          backgroundColor: topBottom,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 1.0, bottom: 5),
              margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: smalldarkBlue,
              ),
              child: IconButton(

                icon: Icon(Icons.refresh),
                onPressed: () async {
                  String randomString = await SharedPreferencesHelper.getUniqString();
                  String chitBoyId = await SharedPreferencesHelper.getChitboyId();
                  String versionId = await AppInfo.getVersionId();
                  String mobileNo = await SharedPreferencesHelper.getMobileNo();
                  await callToApi(randomString, chitBoyId, versionId, mobileNo);
                  setState(() {

                  });
                },
                color: Colors.white,
                iconSize: 30.0,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(right: 2.0, bottom: 5),
            //   margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: smalldarkBlue,
            //   ),
            //   child: IconButton(
            //     icon: Icon(Icons.arrow_circle_right_outlined), // Change this icon as per your requirement
            //     onPressed: () {
            //       if(mounted){
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => VikriSathaPage()),
            //         );
            //       }
            //     },
            //     color: Colors.white,
            //     iconSize: 30.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }


  Widget pvarietyHangamUsNondTitle() {
    return Card(
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      color: darkBlue,
      shadowColor:smalldarkBlue,
      child: Padding(
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
      ),
    );
  }


  // Widget pvarietyHangamUsNondColumnDetails() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //
  //       child: Container(
  //         // color: verysmalldarkBlue,
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
  //               color: verysmalldarkBlue,
  //               child: FutureBuilder<PurviCaneNondVhangamResponse?>(
  //                 future: _varietyHangamCrushingFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     PurviCaneNondVhangamResponse vhResponse = snapshot.data!;
  //                     Map<String, PurviVarietyHangamCaneData> vhCrushingBeanMap = vhResponse.purviVarietyHangamCaneBeanMap;
  //
  //                     double value1Total = vhCrushingBeanMap.values.map((vhData) => vhData.value1).fold(0, (previous, current) => previous + current);
  //
  //                     double value2Total = vhCrushingBeanMap.values.map((vhData) => vhData.value2).fold(0, (previous, current) => previous + current);
  //
  //                     double value3Total = vhCrushingBeanMap.values.map((vhData) => vhData.value3).fold(0, (previous, current) => previous + current);
  //
  //                     double value4Total = vhCrushingBeanMap.values.map((vhData) => vhData.value4).fold(0, (previous, current) => previous + current);
  //
  //                     double value5Total = vhCrushingBeanMap.values.map((vhData) => vhData.value5).fold(0, (previous, current) => previous + current);
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((
  //                             states) => smalldarkBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'व्हरायटी',
  //                               style: TextStyle(fontSize: 16,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'अडसाली',
  //                               style: TextStyle(fontSize: 16,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'पु. हंगाम',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'चा.हंगाम',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'खोडवा',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'एकूण',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...vhCrushingBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               PurviVarietyHangamCaneData vhData = entry.value;
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       resourceName,
  //                                       style: TextStyle(fontSize: 15,
  //                                           fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       vhData.value1.toStringAsFixed(2),
  //                                       style: TextStyle(fontSize: 15,
  //                                           fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value2.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value3.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value4.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         vhData.value5.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           ),
  //
  //                           DataRow(
  //                             cells: [
  //                               DataCell(
  //                                 Text(
  //                                   'एकूण',
  //                                   style: TextStyle(fontSize: 15,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value1Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 15.0),
  //                                   child: Text(
  //                                     value2Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value3Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 15.0),
  //                                   child: Text(
  //                                     value4Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 15.0),
  //                                   child: Text(
  //                                     value5Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
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
  //
  //     ),
  //   );
  // }



  Widget pvarietyHangamUsNondColumnDetails(Map<String, PurviVarietyHangamCaneData> vhCrushingBeanMap) {
    double value1Total = vhCrushingBeanMap.values.map((vhData) => vhData.value1).fold(0, (previous, current) => previous + current);
    double value2Total = vhCrushingBeanMap.values.map((vhData) => vhData.value2).fold(0, (previous, current) => previous + current);
    double value3Total = vhCrushingBeanMap.values.map((vhData) => vhData.value3).fold(0, (previous, current) => previous + current);
    double value4Total = vhCrushingBeanMap.values.map((vhData) => vhData.value4).fold(0, (previous, current) => previous + current);
    double value5Total = vhCrushingBeanMap.values.map((vhData) => vhData.value5).fold(0, (previous, current) => previous + current);

    List<MapEntry<String, PurviVarietyHangamCaneData>> sortedEntries = vhCrushingBeanMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    sortedEntries.add(
      MapEntry(
        'एकूण',
        PurviVarietyHangamCaneData(
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
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmalldarkBlue,
              color: verysmalldarkBlue,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smalldarkBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'व्हरायटी',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'अडसाली',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'पु. हंगाम',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'चा.हंगाम',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'खोडवा',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: sortedEntries.map<DataRow>(
                        (entry) {
                      String resourceName = entry.key;
                      PurviVarietyHangamCaneData vhData = entry.value;
                      bool isTotalRow = resourceName == 'एकूण';
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              resourceName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              vhData.value1.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                vhData.value2.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                vhData.value3.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                vhData.value4.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                vhData.value5.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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

  Widget inBetweenSizeBox() {
    return SizedBox(height: 10,);
  }

  Widget gatHangamWarCurrentCaneTitle() {
    return Card(
      margin: EdgeInsets.only(top: 20),
      elevation: 5, // Adjust elevation as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      color: darkBlue,
      shadowColor:smalldarkBlue,
        child: Padding(

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
        ),

    );
  }



  // Widget psectionHangamUsNondColumnDetails() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //  color: verysmalldarkBlue,
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
  //               color: verysmalldarkBlue,
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
  //                     double value1Total = ghCrushingBeanMap.values.map((ghData) => ghData.value1).fold(0, (previous, current) => previous + current);
  //
  //                     double value2Total = ghCrushingBeanMap.values.map((ghData) => ghData.value2).fold(0, (previous, current) => previous + current);
  //
  //                     double value3Total = ghCrushingBeanMap.values.map((ghData) => ghData.value3).fold(0, (previous, current) => previous + current);
  //
  //                     double value4Total = ghCrushingBeanMap.values.map((ghData) => ghData.value4).fold(0, (previous, current) => previous + current);
  //
  //                     double value5Total = ghCrushingBeanMap.values.map((ghData) => ghData.value5).fold(0, (previous, current) => previous + current);
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((
  //                             states) => smalldarkBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'गट',
  //                               style: TextStyle(fontSize: 16,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'अडसाली',
  //                               style: TextStyle(fontSize: 16,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'पु.हंगाम',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'चा.हंगाम',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'खोडवा',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'एकूण',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
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
  //
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       resourceName,
  //                                       style: TextStyle(fontSize: 15,
  //                                           fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       ghData.value1.toStringAsFixed(2),
  //                                       style: TextStyle(fontSize: 15,
  //                                           fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value2.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value3.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(
  //                                           horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value4.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 15.0),
  //                                       child: Text(
  //                                         ghData.value5.toStringAsFixed(2),
  //                                         style: TextStyle(fontSize: 15,
  //                                             fontWeight: FontWeight.normal),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               );
  //                             },
  //                           ),
  //
  //                           DataRow(
  //                             cells: [
  //                               DataCell(
  //                                 Text(
  //                                   'एकूण',
  //                                   style: TextStyle(fontSize: 15,
  //                                       fontWeight: FontWeight.bold),),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value1Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 15.0),
  //                                   child: Text(
  //                                     value2Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value3Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 15.0),
  //                                   child: Text(
  //                                     value4Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 15.0),
  //                                   child: Text(
  //                                     value5Total.toStringAsFixed(2),
  //                                     style: TextStyle(fontSize: 15,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 ),
  //                               ),
  //
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



  Widget psectionHangamUsNondColumnDetails(Map<String, GatHangamCaneData> gatHangamCaneBeanMap) {
    double value1Total = gatHangamCaneBeanMap.values.map((vhData) => vhData.value1).fold(0, (previous, current) => previous + current);
    double value2Total = gatHangamCaneBeanMap.values.map((vhData) => vhData.value2).fold(0, (previous, current) => previous + current);
    double value3Total = gatHangamCaneBeanMap.values.map((vhData) => vhData.value3).fold(0, (previous, current) => previous + current);
    double value4Total = gatHangamCaneBeanMap.values.map((vhData) => vhData.value4).fold(0, (previous, current) => previous + current);
    double value5Total = gatHangamCaneBeanMap.values.map((vhData) => vhData.value5).fold(0, (previous, current) => previous + current);

    List<MapEntry<String, GatHangamCaneData>> sortedEntries = gatHangamCaneBeanMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    sortedEntries.add(
      MapEntry(
        'एकूण',
        GatHangamCaneData(
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
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmalldarkBlue,
              color: verysmalldarkBlue,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smalldarkBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'गट',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'अडसाली',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'पु.हंगाम',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'चा.हंगाम',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'खोडवा',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: sortedEntries.map<DataRow>(
                        (entry) {
                          String resourceName = entry.key;

                          GatHangamCaneData ghData = entry.value;
                      bool isTotalRow = resourceName == 'एकूण';
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              resourceName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              ghData.value1.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                ghData.value2.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                ghData.value3.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                ghData.value4.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                ghData.value5.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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

  Widget pmahinaVarietyCurrentCaneTitle() {
    return Card(
      margin: EdgeInsets.only(top: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      color:darkBlue,

      child: Padding(
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
      ),
    );
  }


  Widget pmonthHangamUsNondColumnDetails(Map<String, MonthHangamCurrentData> monthHangamCaneBeanMap) {
    double value1Total = monthHangamCaneBeanMap.values.map((vhData) => vhData.value1).fold(0, (previous, current) => previous + current);
    double value2Total = monthHangamCaneBeanMap.values.map((vhData) => vhData.value2).fold(0, (previous, current) => previous + current);
    double value3Total = monthHangamCaneBeanMap.values.map((vhData) => vhData.value3).fold(0, (previous, current) => previous + current);
    double value4Total = monthHangamCaneBeanMap.values.map((vhData) => vhData.value4).fold(0, (previous, current) => previous + current);
    double value5Total = monthHangamCaneBeanMap.values.map((vhData) => vhData.value5).fold(0, (previous, current) => previous + current);

    List<MapEntry<String, MonthHangamCurrentData>> sortedEntries = monthHangamCaneBeanMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

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
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmalldarkBlue,
              color: verysmalldarkBlue,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smalldarkBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'महिना',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'अडसाली',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'पु.हंगाम',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'चा.हंगाम',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'खोडवा',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: sortedEntries.map<DataRow>(
                        (entry) {
                          String resourceName = entry.key;
                          MonthHangamCurrentData mvData = entry.value;

                      bool isTotalRow = resourceName == 'एकूण';
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              resourceName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              mvData.value1.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                mvData.value2.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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

  // Widget pmonthHangamUsNondColumnDetails() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //  color: verysmalldarkBlue,
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
  //               color: verysmalldarkBlue,
  //               child: FutureBuilder<MonthHangamCurrentCaneResponse?>(
  //                 future: _monthHangamCrushingFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     MonthHangamCurrentCaneResponse mhResponse = snapshot
  //                         .data!;
  //                     Map<String,
  //                         MonthHangamCurrentData> mhCrushingBeanMap = mhResponse
  //                         .monthHangamCaneBeanMap;
  //
  //                     double value1Total = mhCrushingBeanMap.values
  //                         .map((mhData) => mhData.value1)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value2Total = mhCrushingBeanMap.values
  //                         .map((mhData) => mhData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value3Total = mhCrushingBeanMap.values
  //                         .map((mhData) => mhData.value3)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value4Total = mhCrushingBeanMap.values
  //                         .map((mhData) => mhData.value4)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value5Total = mhCrushingBeanMap.values
  //                         .map((mhData) => mhData.value5)
  //                         .fold(0, (previous, current) => previous + current);
  //                     List<MapEntry<String, MonthHangamCurrentData>> sortedEntries = mhCrushingBeanMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  //                     sortedEntries.add(
  //                       MapEntry(
  //                         'एकूण',
  //                         MonthHangamCurrentData(
  //                           value1: value1Total,
  //                           value2: value2Total,
  //                           value3: value3Total,
  //                           value4: value4Total,
  //                           value5: value5Total,
  //                           resourceName: 'एकूण',
  //                         ),
  //                       ),
  //                     );
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smalldarkBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'महिना',
  //                               style: TextStyle(fontSize: 16,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'अडसाली',
  //                               style: TextStyle(fontSize: 16,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'पु. हंगाम',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'चा.हंगाम',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'खोडवा',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 20.0),
  //                               child: Text(
  //                                 'एकूण',
  //                                 style: TextStyle(fontSize: 16,
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: sortedEntries.map<DataRow>((entry) {
  //                           String resourceName = entry.key;
  //                           MonthHangamCurrentData mvData = entry.value;
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



  Widget pmonthVarietyUsNondColumnDetails(Map<String, MonthVarietyCurrentData> monthVarietyCaneBeanMap) {
    double value1Total = monthVarietyCaneBeanMap.values.map((vhData) => vhData.value1).fold(0, (previous, current) => previous + current);
    double value2Total = monthVarietyCaneBeanMap.values.map((vhData) => vhData.value2).fold(0, (previous, current) => previous + current);
    double value3Total = monthVarietyCaneBeanMap.values.map((vhData) => vhData.value3).fold(0, (previous, current) => previous + current);
    double value4Total = monthVarietyCaneBeanMap.values.map((vhData) => vhData.value4).fold(0, (previous, current) => previous + current);
    double value5Total = monthVarietyCaneBeanMap.values.map((vhData) => vhData.value5).fold(0, (previous, current) => previous + current);

    List<MapEntry<String, MonthVarietyCurrentData>> sortedEntries = monthVarietyCaneBeanMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

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
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmalldarkBlue,
              color: verysmalldarkBlue,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smalldarkBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'महिना',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'CO-86032',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'CO-265',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'VSI-10001',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'इतर',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
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
                            fontWeight: FontWeight.bold,
                          ),
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
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              mvData.value1.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                mvData.value2.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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
                                  fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
                                ),
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



  // Widget pmonthVarietyUsNondColumnDetails() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         // color: verysmalldarkBlue,
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
  //               color: verysmalldarkBlue,
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
  //
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
  //                     // Sort the entries based on resourceName in ascending order
  //                     List<MapEntry<String, MonthVarietyCurrentData>> sortedEntries = mvCrushingBeanMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
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
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smalldarkBlue),
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


  Widget pmahinaHangamCurrentCaneTitle() {
    return Card(
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      color: darkBlue.withOpacity(0.9), // Adjust opacity for a fainter color
      child: Padding(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              someshowarHeading(),
              inBetweenSizeBox(),
              pvarietyHangamUsNondTitle(),
              inBetweenSizeBox(),
             // pvarietyHangamUsNondColumnDetails(),
              pvarietyHangamUsNondColumnDetails(purviVarietyHangamCaneBeanMap),
              inBetweenSizeBox(),
              gatHangamWarCurrentCaneTitle(),
              inBetweenSizeBox(),
              //psectionHangamUsNondColumnDetails(),
              psectionHangamUsNondColumnDetails(gatHangamCaneBeanMap),
              inBetweenSizeBox(),
              pmahinaHangamCurrentCaneTitle(),
              inBetweenSizeBox(),
              pmonthHangamUsNondColumnDetails(monthHangamCaneBeanMap),
              inBetweenSizeBox(),
              pmahinaVarietyCurrentCaneTitle(),
              inBetweenSizeBox(),
              pmonthVarietyUsNondColumnDetails(monthVarietyCaneBeanMap),
            ],
          ),
        ),
      ),
    );
  }
  static Future<PurviCaneNondVhangamResponse> getPudhilVarietyHangamCaneNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo,) async {
    try {
     // String uri = "http://117.205.2.18:8082/FlutterMIS/PurviCaneNondController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/PurviCaneNondController';
      Map<String, dynamic> requestBody = {
        'action': "purvvarietyhangamusnond",
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
        final PurviCaneNondVhangamResponse purviCaneNondVhangamResponse = PurviCaneNondVhangamResponse.fromJson(data);
        Map<String,
            PurviVarietyHangamCaneData> purviVarietyHangamCaneBeanMap = purviCaneNondVhangamResponse.purviVarietyHangamCaneBeanMap;
        List<String> sortedVarieties = purviVarietyHangamCaneBeanMap.keys.toList()..sort();
        for (String variety in sortedVarieties) {
          PurviVarietyHangamCaneData value = purviVarietyHangamCaneBeanMap[variety]!;
          double value1 = value.value1;
          double value2 = value.value2;
          double value3 = value.value3;
          double value4 = value.value4;
          double value5 = value.value5;
          String resourceName = value.resourceName;
        }
        return PurviCaneNondVhangamResponse.fromJson(data);
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return PurviCaneNondVhangamResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        purviVarietyHangamCaneBeanMap: {},
      );
    }
  }

  static Future<GatHangamCurrentCaneResponse> getPudhilGatHangamCaneNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/PurviCaneNondController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/PurviCaneNondController';
      Map<String, dynamic> requestBody = {
        'action': "purvgathangamusnond",
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
  static Future<MonthHangamCurrentCaneResponse> getMonthHangamCaneCurrentNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/PurviCaneNondController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/PurviCaneNondController';
      Map<String, dynamic> requestBody = {
        'action': "pudhilmonthhangamusnond",
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

  static Future<MonthVarietyCurrentCaneResponse> getPudhilMonthVarietyHangamCaneNond(String randomString, String chitBoyId, String imei, String versionId, String mobileNo) async {
    try {
    //  String uri = "http://117.205.2.18:8082/FlutterMIS/PurviCaneNondController";
      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/PurviCaneNondController';
      Map<String, dynamic> requestBody = {
        'action':"pudhilmonthvarietyusnond",
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






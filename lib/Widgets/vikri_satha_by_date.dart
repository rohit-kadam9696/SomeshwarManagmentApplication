import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SomeshwarManagementApp/pojo/vikri_satha_response_report1.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../pojo/subsubstance_response.dart';
import '../pojo/sugar_sale_response.dart';
import '../pojo/sugar_stock_response.dart';
import '../progress_bar/animated_circular_progressbar.dart';
class VikriSathaWidget extends StatefulWidget {
  const VikriSathaWidget({super.key});

  @override
  State<VikriSathaWidget> createState() => _VikriSathaWidgetState();
}

class _VikriSathaWidgetState extends State<VikriSathaWidget> {
  late DateTime selectedDate=DateTime.now();
  late String formattedDate = "";
  late String chitBoyId;
  late String randomString;
  late String mobileNo;
  static String identifier = 'Identifier not available';
  late Future<VikriSatha1Response?> _vikriSathaFuture = Future.value();
  late Future<SugarSaleResponse?> _sugarSaleFuture = Future.value();
  late Future<SugarStockResponse?> _sugarStockFuture = Future.value();
  late Future<SubSubstanceResponse?> _substanceSaleFuture = Future.value();


   Map<String, SugarSaleData> sugarSaleBeanMap={};
   Map<String, SugarStockData> sugarStockBeanMap={};
   Map<String, SubSubstanceData> subSubstanceBeanMap={};
    Map<String, VikriSathaData> vikriSathaSugarBeanMap={};
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

    if (selectedDate.isBefore(DateTime.now()) || selectedDate.isAtSameMomentAs(DateTime.now())) {
      await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode);
      //await getHourlyCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
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
      firstDate: currentDate.subtract(Duration(days: 365)), // Allow selection of past dates within the last year
      lastDate: currentDate,
    );
    if (picked == null) {
      setState(() {
        selectedDate = currentDate;
        formattedDate = _formatDate(currentDate);
      });
      await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode);
    } else if (picked.isBefore(currentDate) || picked.isAtSameMomentAs(currentDate)) {
      setState(() {
        selectedDate = picked;
        formattedDate = _formatDate(selectedDate);
      });
      await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode);
      // await getHourlyCrushing(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
    }

  }
  Future<void> fetchDataForDate(String randomString, String chitBoyId, String versionId, String mobileNo, String YearCode) async {
    // String randomString = await PreferencesHelper.getStoredUniqstring();
    // String chitBoyId = await PreferencesHelper.getStoredChitboyid();
    // String versionId = await AppInfo.getVersionId();
    // String mobileNo = await PreferencesHelper.getStoredMobileNo();
    // String YearCode = await PreferencesHelper.getstoreValuesInSharedPrefYearCode();


    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String YearCode = await SharedPreferencesHelper.getYearCode();



    _vikriSathaFuture=getVikriSathaReport1(randomString, chitBoyId, identifier, versionId,formattedDate, mobileNo,YearCode);
    _sugarSaleFuture=getSugarSaleReport(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
    _sugarStockFuture=getSugarStockData(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
    _substanceSaleFuture=getSubSubstanceData(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);





    final suagrSaleCrushing= await _sugarSaleFuture;
    if (suagrSaleCrushing != null) {
      setState(() {
        sugarSaleBeanMap = suagrSaleCrushing.sugarSaleBeanMap;

      });

      suagrSaleCrushing.sugarSaleBeanMap.forEach((resourceName ,mvData) {
      });
    }

    final suagrStockCrushing= await _sugarStockFuture;
    if (suagrStockCrushing != null) {
      setState(() {
        sugarStockBeanMap = suagrStockCrushing.sugarStockBeanMap;

      });

      suagrStockCrushing.sugarStockBeanMap.forEach((resourceName ,mvData) {
      });
    }

    final subSubstanceSale= await _substanceSaleFuture;
    if (subSubstanceSale != null) {
      setState(() {
        subSubstanceBeanMap = subSubstanceSale.subSubstanceBeanMap;

      });

      subSubstanceSale.subSubstanceBeanMap.forEach((resourceName ,mvData) {
      });
    }
    final vikriSathaSugar= await _vikriSathaFuture;
    if (vikriSathaSugar != null) {
      setState(() {
        vikriSathaSugarBeanMap = vikriSathaSugar.vikriSathaSugarBeanMap;

      });

      vikriSathaSugar.vikriSathaSugarBeanMap.forEach((resourceName ,mvData) {
      });
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
  void changeScreen() {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Navigator.pushReplacementNamed(context, '/puUsNond');
    });
  }

  static const Color darkRed = Color(0xFFF44236);
  static const Color smallRed = Color(0xFFFA8E8E);
  static const Color verysmallRed = Color(0xFFFFCDD2);
  Widget someshowarHeading() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: Container(
        margin: EdgeInsets.only(top: 20,),
        child: AppBar(
          title: Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'श्री सोमेश्वर स.सा.का.लि',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          backgroundColor: darkRed,
          leading: Container(
            padding: EdgeInsets.only( bottom: 5),
            margin: EdgeInsets.only(bottom: 10.0, left: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: smallRed,
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  await _selectDate(context);
                  setState(() {});
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
                color: smallRed,
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
                  setState((){});
                },
                color: Colors.white,
                iconSize: 30.0,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(right: 2.0, left: 2, bottom: 5),
            //   margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: smallRed,
            //   ),
            //   child: IconButton(
            //     icon: Icon(Icons.arrow_circle_left_outlined),
            //     onPressed: () {
            //      if(mounted)
            //        {
            //          changeScreen();
            //        }
            //     },
            //     color: Colors.white,
            //     iconSize: 30.0,
            //   ),
            // ),
            // Additional IconButton

          ],
        ),
      ),
    );
  }

  // Widget someshowarHeading() {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(80.0),
  //     child: Container(
  //       margin: EdgeInsets.only(top: 20,),
  //       child: AppBar(
  //         title: Container(
  //           padding: EdgeInsets.only(left: 10),
  //           child: Text(
  //             'श्री सोमेश्वर स.सा.का.लि',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 25,
  //             ),
  //           ),
  //         ),
  //         backgroundColor: darkRed,
  //         leading: Container(
  //           padding: EdgeInsets.only( bottom: 5),
  //           margin: EdgeInsets.only(bottom: 10.0, left: 8.0),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             //color: Colors.blue,
  //             // color: Color(0xFFADD8E6),
  //             color:smallRed,
  //             //Color(0xFF000080),
  //           ),
  //           child: Center(
  //             child: IconButton(
  //               icon: Icon(Icons.calendar_today),
  //               onPressed: () async {
  //                 await _selectDate(context);
  //                 setState(() {});
  //               },
  //               color: Colors.white,
  //               iconSize: 30.0,
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           Container(
  //             padding: EdgeInsets.only(right: 2.0,left:2,bottom:5),
  //             margin: EdgeInsets.only(bottom: 10.0,right:10.0),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: smallRed,
  //             ),
  //             child: IconButton(
  //               icon: Icon(Icons.refresh),
  //               onPressed: () async {
  //                 // String randomString = await PreferencesHelper.getStoredUniqstring();
  //                 // String chitBoyId = await PreferencesHelper.getStoredChitboyid();
  //                 // String versionId = await AppInfo.getVersionId();
  //                 // String mobileNo = await PreferencesHelper.getStoredMobileNo();
  //                 // String YearCode = await PreferencesHelper.getstoreValuesInSharedPrefYearCode();
  //                 String randomString = await SharedPreferencesHelper.getUniqString();
  //                 String chitBoyId = await SharedPreferencesHelper.getChitboyId();
  //                 String versionId = await AppInfo.getVersionId();
  //                 String mobileNo = await SharedPreferencesHelper.getMobileNo();
  //                 String YearCode = await SharedPreferencesHelper.getYearCode();
  //                 await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode);
  //                 setState((){});
  //               },
  //               color: Colors.white,
  //               iconSize: 30.0,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget cmahinaHangamUsNondTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkRed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      elevation:5,
      shadowColor:darkRed,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'उपपदार्थ साठा [${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget inBetweenSizeBox() {
    return SizedBox(height: 5,);
  }

  // Widget vikriStahaReport1Details(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         // color: verysmallRed,
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
  //               color: verysmallRed,
  //               child: FutureBuilder<VikriSatha1Response?>(
  //                 future: _vikriSathaFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     VikriSatha1Response vsResponse = snapshot.data!;
  //                     Map<String, VikriSathaData> vhCrushingBeanMap = vsResponse.vikriSathaSugarBeanMap;
  //                     double value2Total = vhCrushingBeanMap.values
  //                         .map((vhData) => vhData.value2)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'उपपदार्थ',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'साठा',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //
  //                         ],
  //                         rows: [
  //                           ...vhCrushingBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               VikriSathaData vhData = entry.value;
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
  //                                       vhData.value2.toStringAsFixed(2),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //
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
  //                                   value2Total.toStringAsFixed(2),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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






  // Widget sugarSaleReportDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //  color: verysmallRed,
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
  //               color: verysmallRed,
  //               child: FutureBuilder<SugarSaleResponse?>(
  //                 future: _sugarSaleFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     SugarSaleResponse sugarSaleRes = snapshot.data!;
  //                     Map<String, SugarSaleData> suagrSaleBeanMap = sugarSaleRes.sugarSaleBeanMap;
  //                     double todayQtyTotal = suagrSaleBeanMap.values.map((suagarSaleData) => suagarSaleData.todayQty).fold(0, (previous, current) => previous + current);
  //                     double todateQtyTotal = suagrSaleBeanMap.values
  //                         .map((suagarSaleData) => suagarSaleData.todateQty)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double avgQtyTotal = suagrSaleBeanMap.values
  //                         .map((suagarSaleData) => suagarSaleData.todateAvgRate)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'साखर ग्रेड',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'आजची विक्री ',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'आजअखेर विक्री',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'सरासरी दर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...suagrSaleBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String gradeName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               SugarSaleData suagarSaleData = entry.value;
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       gradeName,
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       suagarSaleData.todayQty.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       suagarSaleData.todateQty.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       suagarSaleData.todateAvgRate.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
  //                                   todayQtyTotal.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   todateQtyTotal.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   avgQtyTotal.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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





  Widget vikriStahaReport1Details(Map<String, VikriSathaData> vikriSathaSugarBeanMap) {
    double value2Total = vikriSathaSugarBeanMap.values
                           .map((vhData) => vhData.value2)
        .fold(0, (previous, current) => previous + current);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmallRed,
              color: verysmallRed,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
                  columns: [
                    DataColumn(
                      label: Text(
                        'उपपदार्थ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'साठा',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),


                  ],
                  rows: [
                    ...vikriSathaSugarBeanMap.entries.map<DataRow>(
                          (entry) {
                            String resourceName = entry.key;

                        VikriSathaData vhData = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                resourceName,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0), // Adjust the horizontal padding as needed
                                child: Text(
                                  vhData.value2.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'एकूण',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              value2Total.toStringAsFixed(2),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget sugarSaleReportDetails(Map<String, SugarSaleData> sugarSaleBeanMap) {
    double todayQtyTotal = sugarSaleBeanMap.values.map((suagarSaleData) => suagarSaleData.todayQty).fold(0, (previous, current) => previous + current);
                      double todateQtyTotal = sugarSaleBeanMap.values
                        .map((suagarSaleData) => suagarSaleData.todateQty)
                         .fold(0, (previous, current) => previous + current);

                       double avgQtyTotal = sugarSaleBeanMap.values
                             .map((suagarSaleData) => suagarSaleData.todateAvgRate)
                             .fold(0, (previous, current) => previous + current);


    List<MapEntry<String, SugarSaleData>> sortedEntries = sugarSaleBeanMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));



    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmallRed,
              color: verysmallRed,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
                  columns: [
                    DataColumn(
                      label: Text(
                        'साखर ग्रेड',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आजची विक्री',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'आजअखेर विक्री',
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
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'सरासरी दर',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                  rows: [
                    ...sugarSaleBeanMap.entries.map<DataRow>(
                          (entry) {
                        String gradeName = entry.key;
                        //  String shift1 = mapShiftNo(shiftNo);
                        SugarSaleData suagarSaleData = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                gradeName,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                suagarSaleData.todayQty.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                suagarSaleData.todateQty.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                suagarSaleData.todateAvgRate.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'एकूण',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            todayQtyTotal.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            todateQtyTotal.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            avgQtyTotal.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }





  Widget sakharVikriHeading(){
    // return Container(
    //   margin: EdgeInsets.only(top: 20),
    //   padding: EdgeInsets.all(5),
    //   child: Text(
    //     'साखर विक्री [${formattedDate}]',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white,
    //     ),
    //   ),
    //   decoration: BoxDecoration(
    //     color: darkRed,
    //     border: Border.all(
    //       color: Colors.black,
    //       width: 2.0,
    //     ),
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    // );

    return Card(
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      color: darkRed,
      elevation:5,
      shadowColor:smallRed,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'साखर विक्री [${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }




  Widget sugarStockHeading(){
    // return Container(
    //   margin: EdgeInsets.only(top: 20),
    //   padding: EdgeInsets.all(5),
    //   child: Text(
    //     'साखर साठा [${formattedDate}]',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white,
    //     ),
    //   ),
    //   decoration: BoxDecoration(
    //     color: darkRed,
    //     border: Border.all(
    //       color: Colors.black,
    //       width: 2.0,
    //     ),
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    // );


    return Card(
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      color: darkRed,
      elevation:5,
      shadowColor:smallRed,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'साखर साठा [${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }






  // Widget sugarStockReportDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         // color: verysmallRed,
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
  //               color: verysmallRed,
  //               child: FutureBuilder<SugarStockResponse?>(
  //                 future: _sugarStockFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     SugarStockResponse sugarStockRes = snapshot.data!;
  //                     Map<String, SugarStockData> suagrStockBeanMap = sugarStockRes.sugarStockBeanMap;
  //                     double totalBal = suagrStockBeanMap.values
  //                         .map((suagarStockata) => suagarStockata.bal)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'साखर ग्रेड',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 50.0), // Adjust the horizontal padding as needed
  //                               child: Text(
  //                                 'साखर साठा',
  //                                 style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...suagrStockBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String vgradeName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               SugarStockData suagarStockata = entry.value;
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       vgradeName,
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Padding(
  //                                       padding: EdgeInsets.symmetric(horizontal: 50.0), // Adjust the horizontal padding as needed
  //                                       child: Text(
  //                                         suagarStockata.bal.toStringAsFixed(3),
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
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 50.0),
  //                                   child: Text(
  //                                     totalBal.toStringAsFixed(3),
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




  Widget sugarStockReportDetails(Map<String, SugarStockData> sugarStockBeanMap) {
    double totalBal = sugarStockBeanMap.values
        .map((suagarStockdata) => suagarStockdata.bal)
        .fold(0, (previous, current) => previous + current);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verysmallRed,
              color: verysmallRed,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
                  columns: [
                    DataColumn(
                      label: Text(
                        'साखर ग्रेड',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'साखर साठा',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),


                  ],
                  rows: [
                    ...sugarStockBeanMap.entries.map<DataRow>(
                          (entry) {
                        String vgradeName = entry.key;
                        //  String shift1 = mapShiftNo(shiftNo);
                        SugarStockData suagarStockata = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                vgradeName,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0), // Adjust the horizontal padding as needed
                                child: Text(
                                  suagarStockata.bal.toStringAsFixed(3),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'एकूण',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              totalBal.toStringAsFixed(3),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }












  Widget upSubstanceVikriHeading(){
    // return Container(
    //   margin: EdgeInsets.only(top: 20),
    //   padding: EdgeInsets.all(5),
    //   child: Text(
    //     'उपपदार्थ विक्री [${formattedDate}]',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white,
    //     ),
    //   ),
    //   decoration: BoxDecoration(
    //     color: darkRed,
    //     border: Border.all(
    //       color: Colors.black,
    //       width: 2.0,
    //     ),
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    // );

    return Card(
      margin: EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      color: darkRed,
      elevation:5,
      shadowColor:smallRed,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'उपपदार्थ विक्री [${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  // Widget subSubstanceSaleReportDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         // color: verysmallRed,
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
  //               color: verysmallRed,
  //               child: FutureBuilder<SubSubstanceResponse?>(
  //                 future: _substanceSaleFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     SubSubstanceResponse substanceSaleRes = snapshot.data!;
  //                     Map<String, SubSubstanceData> substanceSaleBeanMap = substanceSaleRes.subSubstanceBeanMap;
  //                     double todayTotal = substanceSaleBeanMap.values
  //                         .map((substancedata) => substancedata.today)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double todateTotal = substanceSaleBeanMap.values
  //                         .map((substancedata) => substancedata.todate)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double todateRateTotal = substanceSaleBeanMap.values
  //                         .map((substancedata) => substancedata.todateRate)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'उपपदार्थ',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'आजची विक्री',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //
  //                             label: Text(
  //                               'आजअखेर विक्री',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                           DataColumn(
  //                             label: Text(
  //                               'सरासरी दर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...substanceSaleBeanMap.entries.map<DataRow>(
  //                                 (entry) {
  //                               String perticular = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               SubSubstanceData substancedata = entry.value;
  //                               return DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                     Text(
  //                                       perticular,
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       substancedata.today.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //
  //                                     Text(
  //                                       substancedata.todate.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //
  //                                     Text(
  //                                       substancedata.todateRate.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
  //                                   todayTotal.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   todateTotal.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   todateRateTotal.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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


  Widget subSubstanceSaleReportDetails( Map<String, SubSubstanceData> subSubstanceBeanMap) {
    double todayTotal = subSubstanceBeanMap.values
        .map((substancedata) => substancedata.today)
        .fold(0, (previous, current) => previous + current);

    double todateTotal = subSubstanceBeanMap.values
        .map((substancedata) => substancedata.todate)
        .fold(0, (previous, current) => previous + current);

    double todateRateTotal = subSubstanceBeanMap.values
        .map((substancedata) => substancedata.todateRate)
        .fold(0, (previous, current) => previous + current);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // margin: EdgeInsets.only(top: 5),
        // padding: EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor:verysmallRed,
              color: verysmallRed,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2.0,
                  // ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallRed),
                  columns: [
                    DataColumn(
                      label: Text(
                        'उपपदार्थ',
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: const EdgeInsets.only(right:20),
                        child: Text(
                          'आजची विक्री',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(

                      label: Text(
                        'आजअखेर विक्री',
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Padding(

                        padding: const EdgeInsets.only(right:10),
                        child: Text(
                          'सरासरी दर',
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    ...subSubstanceBeanMap.entries.map<DataRow>(
                          (entry) {
                        String perticular = entry.key;
                        SubSubstanceData substancedata = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                perticular,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                substancedata.today.toStringAsFixed(3),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(

                              Text(
                                substancedata.todate.toStringAsFixed(3),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(

                              Text(
                                substancedata.todateRate.toStringAsFixed(3),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'एकूण',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            todayTotal.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            todateTotal.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            todateRateTotal.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          someshowarHeading(),
          sakharVikriHeading(),
          inBetweenSizeBox(),
          sugarSaleReportDetails(sugarSaleBeanMap),
          inBetweenSizeBox(),
          sugarStockHeading(),
          inBetweenSizeBox(),
          sugarStockReportDetails(sugarStockBeanMap),
          inBetweenSizeBox(),
          upSubstanceVikriHeading(),
          inBetweenSizeBox(),
          subSubstanceSaleReportDetails(subSubstanceBeanMap),
          inBetweenSizeBox(),
          cmahinaHangamUsNondTitle(),
          inBetweenSizeBox(),
          vikriStahaReport1Details(vikriSathaSugarBeanMap),
        ],
      ),
    );
  }
  static Future<VikriSatha1Response> getVikriSathaReport1(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async
  {
    try {
     // String uri = "http://117.205.2.18:8082/FlutterMIS/VikriSathaController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/VikriSathaController';
      Map<String, dynamic> requestBody = {
        'action': "vikrisatha1",
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
        final VikriSatha1Response vikriSatha1Response = VikriSatha1Response.fromJson(data);
        Map<String, VikriSathaData>vikriSathaBeanMap = vikriSatha1Response.vikriSathaSugarBeanMap;
        List<String> sortedVikri = vikriSathaBeanMap.keys.toList()..sort();
        for (String vikri in sortedVikri) {
          VikriSathaData value = vikriSathaBeanMap[vikri]!;
          double value2 = value.value2;
          String resourceName = value.resourceName;
        }
        return vikriSatha1Response;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return VikriSatha1Response(
        nsugTypeId: 0,
        nlocationId: 0,
        vikriSathaSugarBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  static Future<SugarSaleResponse> getSugarSaleReport(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/VikriSathaController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/VikriSathaController';
      Map<String, dynamic> requestBody = {
        'action': "sugarsale",
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
        final SugarSaleResponse sugarSaleResponse = SugarSaleResponse.fromJson(data);
        Map<String, SugarSaleData> sugarSaleBeanMap = sugarSaleResponse.sugarSaleBeanMap;
        List<String> sortedGradeName = sugarSaleBeanMap.keys.toList()..sort();
        for (String grade in sortedGradeName) {
          SugarSaleData value = sugarSaleBeanMap[grade]!;
          double todayQty = value.todayQty;
          double todateQty=value.todateQty;
          double todateAvgRate=value.todateAvgRate;
          String gradeName = value.gradeName;
        }
        return sugarSaleResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return SugarSaleResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        sugarSaleBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  static Future<SugarStockResponse> getSugarStockData(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/VikriSathaController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/VikriSathaController';
      Map<String, dynamic> requestBody = {
        'action': "sugarstock",
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
        print("upadarth satha: $data");
        final SugarStockResponse sugarStockResponse = SugarStockResponse.fromJson(data);
        Map<String, SugarStockData> sugarStockBeanMap = sugarStockResponse.sugarStockBeanMap;
        List<String> sortedGradeName = sugarStockBeanMap.keys.toList()..sort();
        for (String grade in sortedGradeName) {
          SugarStockData value = sugarStockBeanMap[grade]!;
          String vgradeName =value.vgradeName;
          double bal=value.bal;
        }
        return sugarStockResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return SugarStockResponse(
        sugarStockBeanMap: {},
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
      );
    }
  }
  static Future<SubSubstanceResponse> getSubSubstanceData(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
    //  String uri = "http://117.205.2.18:8082/FlutterMIS/VikriSathaController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/VikriSathaController';
      Map<String, dynamic> requestBody = {
        'action': "subsubstancesale",
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
        print("SubSubstanceResponse: ${data}");
        final SubSubstanceResponse substanceResponse = SubSubstanceResponse.fromJson(data);
        Map<String, SubSubstanceData> substanceBeanMap = substanceResponse.subSubstanceBeanMap;
        List<String> sortedPerticular = substanceBeanMap.keys.toList()..sort();
        for (String perticul in sortedPerticular) {
          SubSubstanceData value = substanceBeanMap[perticul]!;
          String perticular =value.perticular;
          double today=value.today;
          double todate=value.todate;
          double todateRate=value.todateRate;
        }
        return SubSubstanceResponse.fromJson(data);
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return SubSubstanceResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        subSubstanceBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
}


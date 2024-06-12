import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:SomeshwarManagementApp/pojo/bheavyResponse.dart';
import 'package:SomeshwarManagementApp/ui/home_page.dart';
import 'package:SomeshwarManagementApp/ui/production_page.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../alertDialog/alert_dialog.dart';
import '../appInfo/app_info.dart';
import '../pojo/cheavyResponse.dart';
import '../pojo/power_production_response.dart';
import '../pojo/productionResponse.dart';
import '../pojo/subSubstanceProduction.dart';
import '../pojo/syrup_utpadan_response.dart';
import '../progress_bar/animated_circular_progressbar.dart';

class ProductionWidget extends StatefulWidget {
  const ProductionWidget({super.key});

  @override
  State<ProductionWidget> createState() => _ProductionWidgetState();
}

class _ProductionWidgetState extends State<ProductionWidget> with TickerProviderStateMixin {
  late DateTime selectedDate;
  late String formattedDate = "";
  late String chitBoyId;
  late String randomString;
  late String mobileNo;
  static String identifier = 'Identifier not available';
  String date = '';
  AnimationController? _controller;

  bool _animationCompleted = false;
  late Future<ProductionResponse?> _productionFuture = Future.value();
  late Future<SubSubstanceProductionResp?> _subSubstanceFuture = Future.value();
  late Future<BheavyResponse?> _bHeavyFuture = Future.value();
  late Future<CheavyResponse?> _cHeavyFuture = Future.value();
  late Future<SyrupUtpadanResponse?> _syrupFuture = Future.value();
  late Future<PowerProductionResponse?> _powerproductionFuture = Future.value();

  Map<String, ProductionSugarData> productionSugarBeanMap = {};
  Map<String, ProductionSubSubstanceData> productionSubSubstanceBeanMap={};
  Map<String, BHeavyProductionData> bheavyProductionBeanMap = {};
  Map<String, CHeavyProductionData> cheavyProductionBeanMap = {};
  Map<String, SyrupUtpadanData> syrupProductionBeanMap={};
   Map<String, PowerProductionData> powerProductionSugarBeanMap={};
  Timer? _timer;
  void initState() {
    super.initState();
    initData();
    selectedDate = DateTime.now();

  }
  Future<void> initData() async {
    fetchData();
  }
  Future<void> fetchData() async {
    void initState() {
      super.initState();
      initData();
      selectedDate = DateTime.now();
      _controller = AnimationController(
        vsync: this,
      //  duration:
      );

      Future.delayed(Duration(seconds: 10), () {
        _controller?.forward();
      });

      _controller?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _animationCompleted = true;
            _startTimer();
          });
        }
      });
    }
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String YearCode = await SharedPreferencesHelper.getYearCode();
    selectedDate = DateTime.now();
    formattedDate = _formatDate(selectedDate);
    if (selectedDate.isBefore(DateTime.now()) || selectedDate.isAtSameMomentAs(DateTime.now())) {
      await fetchDataForDate(randomString, chitBoyId, versionId, mobileNo, YearCode);
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
    }
  }
  Future<void> fetchDataForDate(String randomString, String chitBoyId, String versionId, String mobileNo, String YearCode) async {

    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String YearCode = await SharedPreferencesHelper.getYearCode();



    _productionFuture=getSugarProduction(randomString, chitBoyId, identifier, versionId,formattedDate, mobileNo,YearCode);
    _subSubstanceFuture=getSubSubstanceProduction(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
    _bHeavyFuture=getBheavyProductionDetails(randomString, chitBoyId, identifier, versionId,formattedDate, mobileNo, YearCode);
    _cHeavyFuture=getCheavyProductionDetails(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
    _syrupFuture=getSyrupProductionDetails(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);
    _powerproductionFuture=getPowerProductionDetails(randomString, chitBoyId, identifier, versionId, formattedDate, mobileNo, YearCode);



    final  productionSugarResponse= await _productionFuture;
    if (productionSugarResponse != null) {
      setState(() {
        productionSugarBeanMap = productionSugarResponse.productionSugarBeanMap;

      });

      productionSugarResponse.productionSugarBeanMap.forEach((resourceName ,mvData) {
      });
    }

    final  subSubstanceResponse= await _subSubstanceFuture;
    if (subSubstanceResponse != null) {
      setState(() {
        productionSubSubstanceBeanMap = subSubstanceResponse.productionSubSubstanceBeanMap;

      });

      subSubstanceResponse.productionSubSubstanceBeanMap.forEach((resourceName ,psData) {
      });
    }



    final  cHeavyResponse= await _cHeavyFuture;
    if (cHeavyResponse != null) {
      setState(() {
        cheavyProductionBeanMap = cHeavyResponse.cheavyProductionBeanMap;

      });

      cHeavyResponse.cheavyProductionBeanMap.forEach((resourceName ,psData) {
      });
    }




    final  bHeavyResponse= await _bHeavyFuture;
    if (bHeavyResponse != null) {
      setState(() {
        bheavyProductionBeanMap = bHeavyResponse.bheavyProductionBeanMap;

      });

      bHeavyResponse.bheavyProductionBeanMap.forEach((resourceName ,psData) {
      });
    }


    final  powerproductionResponse= await _powerproductionFuture;
    if (powerproductionResponse != null) {
      setState(() {
        powerProductionSugarBeanMap = powerproductionResponse.powerProductionSugarBeanMap;

      });

      powerproductionResponse.powerProductionSugarBeanMap.forEach((resourceName ,psData) {
      });
    }
    final  syrupResponse= await _syrupFuture;
    if (syrupResponse != null) {
      setState(() {
        syrupProductionBeanMap = syrupResponse.syrupProductionBeanMap;

      });

      syrupResponse.syrupProductionBeanMap.forEach((resourceName ,psData) {
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
      Navigator.pushReplacementNamed(context, '/vikriSatha');
    });
  }
  static const Color darkBlue = Color(0xFF2196F3);
  static const Color smallBlue = Color(0xFF8BC6F7);
  static const Color verySmallBlue = Color(0xFFC3E1FA);


  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 5), () {
      if (mounted) { // Check if the widget is still mounted before setting the state
        setState(() {
          _animationCompleted = true;
        });
      }
    });
  }

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
          backgroundColor: darkBlue,
          leading: Container(
            padding: EdgeInsets.only( bottom: 5),
            margin: EdgeInsets.only(bottom: 10.0, left: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:smallBlue,

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
                color: smallBlue,
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
            Container(
              padding: EdgeInsets.only(right: 2.0,left:2,bottom:5),
              margin: EdgeInsets.only(bottom: 10.0,right:10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: smallBlue,
              ),
              child:IconButton(

                icon: Icon(Icons.logout,color: Colors.black,),
                onPressed: () async {

                  AlertDialogUtils.showAlertWithTwoButtons(

                    context: context,
                    message: 'तुम्हाला लॉग आऊट करायचं आहे का?',
                    onOkPressed: () {

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset("assets/animations/Animation - 1712216217114.json",controller: _controller, // Assign the controller to control the animation
                                    onLoaded: (composition) {
                                      print("Animation duration: ${composition.duration}");
                                      _controller?.duration = composition.duration!;
                                    },),
                                  SizedBox(height: 20),
                                  Text(
                                    'Success',

                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 5), () {
                        setState(() {
                          SharedPreferencesHelper.clearUserData();
                           Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);


                        });

                      });

                      // Future.delayed(Duration(seconds: 2), () {
                      //   if (Navigator.canPop(context)) {
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => HomePage()),
                      //
                      //
                      //     );
                      //   }
                      //
                      //
                      // });
                    },
                    onCancelPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProductionPage()),
                      );

                    },
                  );


                  // await SharedPreferencesHelper.clearUserData();
                  //   Navigator.pushReplacementNamed(context, '/home');

                },
                color: Colors.white,
                iconSize: 30.0,
              ),


              // IconButton(
              //   icon: Icon(Icons.arrow_circle_right,color: Colors.black,),
              //   onPressed: () async {
              //     if(mounted){
              //       changeScreenRight();
              //     }
              //   },
              //   color: Colors.white,
              //   iconSize: 30.0,
              // ),
            ),
          ],
        ),
      ),
    );
  }
  Widget suagrProductionTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

      ),
      elevation:5,
      shadowColor:darkBlue,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'साखर उत्पादन [${formattedDate}]',
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
    return SizedBox(height: 10,);
  }


  //
  // Widget suagrProductionDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //color: verySmallBlue,
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
  //               color: verySmallBlue,
  //               child: FutureBuilder<ProductionResponse?>(
  //                 future: _productionFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     ProductionResponse prResponse = snapshot.data!;
  //                     Map<String, ProductionSugarData> prodSugarBeanMap = prResponse.productionSugarBeanMap;
  //                     double value2Total = prodSugarBeanMap.values
  //                         .map((psData) => psData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value1Total = prodSugarBeanMap.values
  //                         .map((psData) => psData.value1)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'तपशील',
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
  //                             label: Text(
  //                               'आजअखेर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...prodSugarBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               ProductionSugarData psData = entry.value;
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
  //                                       psData.value1.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       psData.value2.toStringAsFixed(3),
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
  //                                   value1Total.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value2Total.toStringAsFixed(3),
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
  //
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }



  Widget suagrProductionDetails(Map<String, ProductionSugarData> productionSugarBeanMap) {
    double value2Total = productionSugarBeanMap.values
        .map((psData) => psData.value2)
        .fold(0, (previous, current) => previous + current);

    double value1Total = productionSugarBeanMap.values
        .map((psData) => psData.value1)
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verySmallBlue,
              color: verySmallBlue,
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
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'तपशील',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आज',
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
                          'आजअखेर',
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
                    ...productionSugarBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
                          (entry) {
                        String resourceName = entry.key;
                        //  String shift1 = mapShiftNo(shiftNo);
                        ProductionSugarData psData = entry.value;
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
                                psData.value1.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                psData.value2.toStringAsFixed(3),
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
                            value1Total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            value2Total.toStringAsFixed(3),
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






















  Widget subSubstanceProductionTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: darkBlue,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'उपपदार्थ उत्पादन(एकत्रित) \n [${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 2,

        ),
      ),
    );
  }


  // Widget subSubstanceProductionDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //  color: verySmallBlue,
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
  //               color: verySmallBlue,
  //               child: FutureBuilder<SubSubstanceProductionResp?>(
  //                 future: _subSubstanceFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     SubSubstanceProductionResp prResponse = snapshot.data!;
  //                     Map<String, ProductionSubSubstanceData> prodSugarBeanMap = prResponse.productionSubSubstanceBeanMap;
  //                     double value2Total = prodSugarBeanMap.values
  //                         .map((psData) => psData.value2)
  //                         .fold(0, (previous, current) => previous + current!);
  //
  //                     double value1Total = prodSugarBeanMap.values
  //                         .map((psData) => psData.value1)
  //                         .fold(0, (previous, current) => previous + current!);
  //                     return Container(
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 2.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(5.0),
  //                       ),
  //                       child: DataTable(
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'तपशील',
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
  //                             label: Text(
  //                               'आजअखेर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...prodSugarBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               //  String shift1 = mapShiftNo(shiftNo);
  //                               ProductionSubSubstanceData psData = entry.value;
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
  //                                       psData.value1.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       psData.value2.toStringAsFixed(3),
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
  //                                   value1Total.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value2Total.toStringAsFixed(3),
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



  Widget subSubstanceProductionDetails(  Map<String, ProductionSubSubstanceData> productionSubSubstanceBeanMap) {
    double value2Total = productionSubSubstanceBeanMap.values
        .map((psData) => psData.value2)
        .fold(0, (previous, current) => previous + current!);

    double value1Total = productionSubSubstanceBeanMap.values
        .map((psData) => psData.value1)
        .fold(0, (previous, current) => previous + current!);

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
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verySmallBlue,
              color: verySmallBlue,
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
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'तपशील',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आज',
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
                          'आजअखेर',
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
                    ...productionSubSubstanceBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
                          (entry) {
                            String resourceName = entry.key;
                            ProductionSubSubstanceData psData = entry.value;
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
                                psData.value1.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                psData.value2.toStringAsFixed(3),
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
                            value1Total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            value2Total.toStringAsFixed(3),
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




  Widget subSubstanceProductionBheavyTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: darkBlue,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'उपपदार्थ उत्पादन(B हेवी पासून)\n[${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // Set maxLines to 1
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Widget bHeavyProductionDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         // color: verySmallBlue,
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
  //               color: verySmallBlue,
  //               child: FutureBuilder<BheavyResponse?>(
  //                 future: _bHeavyFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     BheavyResponse bheavyResponse = snapshot.data!;
  //                     Map<String, BHeavyProductionData> heavyBeanMap = bheavyResponse.bheavyProductionBeanMap;
  //                     double value2Total = heavyBeanMap.values
  //                         .map((psData) => psData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value1Total = heavyBeanMap.values
  //                         .map((psData) => psData.value1)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'तपशील',
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
  //                             label: Text(
  //                               'आजअखेर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...heavyBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               BHeavyProductionData psData = entry.value;
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
  //                                       psData.value1.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       psData.value2.toStringAsFixed(3),
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
  //                                   value1Total.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value2Total.toStringAsFixed(3),
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


  Widget bHeavyProductionDetails(Map<String, BHeavyProductionData> bheavyProductionBeanMap) {
    double value2Total = bheavyProductionBeanMap.values
        .map((psData) => psData.value2)
        .fold(0, (previous, current) => previous + current);

    double value1Total = bheavyProductionBeanMap.values
        .map((psData) => psData.value1)
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verySmallBlue,
              color: verySmallBlue,
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
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'तपशील',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आज',
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
                          'आजअखेर',
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
                    ...bheavyProductionBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
                          (entry) {
                        String resourceName = entry.key;
                        BHeavyProductionData psData = entry.value;
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
                                psData.value1.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                psData.value2.toStringAsFixed(3),
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
                            value1Total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            value2Total.toStringAsFixed(3),
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





  Widget productionCheavyTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: darkBlue,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'उपपदार्थ उत्पादन(C हेवी पासून)\n[${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // Set maxLines to 1
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Widget cHeavyProductionDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //  color: verySmallBlue,
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
  //               color: verySmallBlue,
  //               child: FutureBuilder<CheavyResponse?>(
  //                 future: _cHeavyFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     CheavyResponse cheavyResponse = snapshot.data!;
  //                     Map<String, CHeavyProductionData> cheavyBeanMap = cheavyResponse.cheavyProductionBeanMap;
  //                     double value2Total = cheavyBeanMap.values
  //                         .map((psData) => psData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value1Total = cheavyBeanMap.values
  //                         .map((psData) => psData.value1)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'तपशील',
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
  //                             label: Text(
  //                               'आजअखेर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...cheavyBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               CHeavyProductionData psData = entry.value;
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
  //                                       psData.value1.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       psData.value2.toStringAsFixed(3),
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
  //                                   value1Total.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value2Total.toStringAsFixed(3),
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



  Widget cHeavyProductionDetails(Map<String, CHeavyProductionData> cheavyProductionBeanMap) {
    double value2Total = cheavyProductionBeanMap.values
        .map((psData) => psData.value2)
        .fold(0, (previous, current) => previous + current);

    double value1Total = cheavyProductionBeanMap.values
        .map((psData) => psData.value1)
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verySmallBlue,
              color: verySmallBlue,
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
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'तपशील',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आज',
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
                          'आजअखेर',
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
                    ...cheavyProductionBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
                          (entry) {
                            String resourceName = entry.key;
                            CHeavyProductionData psData = entry.value;
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
                                psData.value1.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                psData.value2.toStringAsFixed(3),
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
                            value1Total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            value2Total.toStringAsFixed(3),
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


  Widget subSubstanceProductionSyrupTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: darkBlue,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'उपपदार्थ उत्पादन(सिरप पासून)\n[${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // Set maxLines to 1
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }


  // Widget subSubstanceProductionSyrupDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         // color: verySmallBlue,
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
  //               color: verySmallBlue,
  //               child: FutureBuilder<SyrupUtpadanResponse?>(
  //                 future: _syrupFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     SyrupUtpadanResponse syrupResponse = snapshot.data!;
  //                     Map<String, SyrupUtpadanData> syrupBeanMap = syrupResponse.syrupProductionBeanMap;
  //                     double value2Total = syrupBeanMap.values
  //                         .map((psData) => psData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value1Total = syrupBeanMap.values
  //                         .map((psData) => psData.value1)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'तपशील',
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
  //                             label: Text(
  //                               'आजअखेर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...syrupBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               SyrupUtpadanData psData = entry.value;
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
  //                                       psData.value1.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       psData.value2.toStringAsFixed(3),
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
  //                                   value1Total.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value2Total.toStringAsFixed(3),
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



  Widget subSubstanceProductionSyrupDetails(Map<String, SyrupUtpadanData> syrupProductionBeanMap) {
    double value2Total = syrupProductionBeanMap.values
        .map((psData) => psData.value2)
        .fold(0, (previous, current) => previous + current);

    double value1Total = syrupProductionBeanMap.values
        .map((psData) => psData.value1)
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verySmallBlue,
              color: verySmallBlue,
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
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'तपशील',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आज',
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
                          'आजअखेर',
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
                    ...syrupProductionBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
                          (entry) {
                            String resourceName = entry.key;
                            SyrupUtpadanData psData = entry.value;
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
                                psData.value1.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                psData.value2.toStringAsFixed(3),
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
                            value1Total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            value2Total.toStringAsFixed(3),
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


  // Widget powerProductionTitle(){
  //   return Container(
  //     margin: EdgeInsets.only(top: 20),
  //     padding: EdgeInsets.all(5),
  //     child: Text(
  //       'वीज उत्पादन [${formattedDate}]',
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         fontSize: 20,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //         // Set maxLines to 1
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ),
  //
  //     decoration: BoxDecoration(
  //       color: darkBlue,
  //       border: Border.all(
  //         color: Colors.black,
  //         width: 2.0,
  //       ),
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //
  //   );
  // }

  Widget powerProductionTitle(){
    return Card(
      margin: EdgeInsets.only(top: 20),
      color: darkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      shadowColor: darkBlue,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'वीज उत्पादन [${formattedDate}]',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // Set maxLines to 1
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Widget powerProductionDetails(){
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Container(
  //       margin: EdgeInsets.only(top: 5),
  //       child: Container(
  //         //color: verySmallBlue,
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
  //               color: verySmallBlue,
  //               child: FutureBuilder<PowerProductionResponse?>(
  //                 future: _powerproductionFuture,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else if (snapshot.hasData) {
  //                     PowerProductionResponse powerResponse = snapshot.data!;
  //                     Map<String, PowerProductionData> powerBeanMap = powerResponse.powerProductionSugarBeanMap;
  //                     double value2Total = powerBeanMap.values
  //                         .map((psData) => psData.value2)
  //                         .fold(0, (previous, current) => previous + current);
  //
  //                     double value1Total = powerBeanMap.values
  //                         .map((psData) => psData.value1)
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
  //                         headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
  //                         columns: [
  //                           DataColumn(
  //                             label: Text(
  //                               'तपशील',
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
  //                             label: Text(
  //                               'आजअखेर',
  //                               style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                         rows: [
  //                           ...powerBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
  //                                 (entry) {
  //                               String resourceName = entry.key;
  //                               PowerProductionData psData = entry.value;
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
  //                                       psData.value1.toStringAsFixed(3),
  //                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
  //                                     ),
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       psData.value2.toStringAsFixed(3),
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
  //                                   value1Total.toStringAsFixed(3),
  //                                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               DataCell(
  //                                 Text(
  //                                   value2Total.toStringAsFixed(3),
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


  Widget powerProductionDetails(Map<String, PowerProductionData> powerProductionSugarBeanMap) {
    double value2Total = powerProductionSugarBeanMap.values
        .map((psData) => psData.value2)
        .fold(0, (previous, current) => previous + current);

    double value1Total = powerProductionSugarBeanMap.values
        .map((psData) => psData.value1)
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              shadowColor:verySmallBlue,
              color: verySmallBlue,
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
                  headingRowColor: MaterialStateColor.resolveWith((states) => smallBlue),
                  columns: [
                    DataColumn(
                      label: Text(
                        'तपशील',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'आज',
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
                          'आजअखेर',
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
                    ...powerProductionSugarBeanMap.entries.where((entry) => entry.key != date).map<DataRow>(
                          (entry) {
                            String resourceName = entry.key;
                            PowerProductionData psData = entry.value;
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
                                psData.value1.toStringAsFixed(3),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                              ),
                            ),
                            DataCell(
                              Text(
                                psData.value2.toStringAsFixed(3),
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
                            value1Total.toStringAsFixed(3),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            value2Total.toStringAsFixed(3),
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(

          child: Column(
            children: [
              someshowarHeading(),
              suagrProductionTitle(),
              inBetweenSizeBox(),
              suagrProductionDetails(productionSugarBeanMap),
              inBetweenSizeBox(),
              subSubstanceProductionTitle(),
              inBetweenSizeBox(),
              subSubstanceProductionDetails(productionSubSubstanceBeanMap),
              inBetweenSizeBox(),
              subSubstanceProductionBheavyTitle(),
              inBetweenSizeBox(),
              bHeavyProductionDetails(bheavyProductionBeanMap),
              inBetweenSizeBox(),
              productionCheavyTitle(),
              inBetweenSizeBox(),
              cHeavyProductionDetails(cheavyProductionBeanMap),
              inBetweenSizeBox(),
              subSubstanceProductionSyrupTitle(),
              inBetweenSizeBox(),
              subSubstanceProductionSyrupDetails(syrupProductionBeanMap),
              inBetweenSizeBox(),
              powerProductionTitle(),
              inBetweenSizeBox(),
              powerProductionDetails(powerProductionSugarBeanMap),
            ],
          ),
        ),
      ),

    );
  }
  static Future<ProductionResponse?> getSugarProduction(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String YearCode) async {
    try {
      //  String uri = "http://117.205.2.18:8082/FlutterMIS/ProductionController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/ProductionController';
      Map<String, dynamic> requestBody = {
        'action': "sugarProduction",
        'mobileNo': mobileNo,
        'imei': imei,
        'randomString': randomString,
        'versionId': versionId,
        'chitBoyId': chitBoyId,
        'date': date,
        'YearCode': YearCode,
      };
      String jsonBody = jsonEncode(requestBody);
      var res = await http.post(
        Uri.parse(uri),
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        List<String> excludedFields = ["24-FEB-24", "Crush rate with stopages"];
        Map<String, dynamic> sugarProductionBeanMap = Map.from(data['productionSugarBeanMap']);
        for (String field in excludedFields) {
          sugarProductionBeanMap.remove(field);
        }
        data['productionSugarBeanMap'] = sugarProductionBeanMap;

        final ProductionResponse sugarProductionResponse = ProductionResponse.fromJson(data);

        return sugarProductionResponse;
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
      return ProductionResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        productionSugarBeanMap: {},
        success: false,
        update: false,
      );
    }
  }
  static Future<SubSubstanceProductionResp> getSubSubstanceProduction(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      // String uri = "http://117.205.2.18:8082/FlutterMIS/ProductionController";
      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/ProductionController';
      Map<String, dynamic> requestBody = {
        'action': "subSubstanceProduction",
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
        if (res.body.isNotEmpty) {
          Map<String, dynamic> data = jsonDecode(res.body);
          final SubSubstanceProductionResp substanceResponse = SubSubstanceProductionResp.fromJson(data);
          return substanceResponse;
        } else {
          throw Exception("Empty response body");
        }
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return SubSubstanceProductionResp(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        productionSubSubstanceBeanMap: {},
      );
    }
  }

  static Future<BheavyResponse> getBheavyProductionDetails(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/ProductionController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/ProductionController';
      Map<String, dynamic> requestBody = {
        'action': "heavyProduction",
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
        if (res.body.isNotEmpty) {
          Map<String, dynamic> data = jsonDecode(res.body);
          final BheavyResponse bheavyResponse = BheavyResponse.fromJson(data);
          print("b heavyResposnse is: ${data}");
          return bheavyResponse;
        } else {
          throw Exception("Empty response body");
        }
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return BheavyResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        bheavyProductionBeanMap: {},
      );
    }
  }
  static Future<CheavyResponse> getCheavyProductionDetails(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      //String uri = "http://117.205.2.18:8082/FlutterMIS/ProductionController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/ProductionController';
      Map<String, dynamic> requestBody = {
        'action': "cHeavyProduction",
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
        if (res.body.isNotEmpty) {
          Map<String, dynamic> data = jsonDecode(res.body);
          final CheavyResponse cheavyResponse = CheavyResponse.fromJson(data);
          print("c heavyResposnse is: ${data}");
          return cheavyResponse;
        } else {
          throw Exception("Empty response body");
        }
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return CheavyResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        cheavyProductionBeanMap: {},

      );
    }
  }
  static Future<PowerProductionResponse> getPowerProductionDetails(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      // String uri = "http://117.205.2.18:8082/FlutterMIS/ProductionController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/ProductionController';
      Map<String, dynamic> requestBody = {
        'action': "powerProduction",
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
        if (res.body.isNotEmpty) {
          Map<String, dynamic> data = jsonDecode(res.body);
          final PowerProductionResponse powerProductionResponse = PowerProductionResponse.fromJson(data);
          print("powerProductionResponse is: ${data}");
          return powerProductionResponse;
        } else {
          throw Exception("Empty response body");
        }
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return PowerProductionResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        powerProductionSugarBeanMap: {},



      );
    }
  }
  static Future<SyrupUtpadanResponse> getSyrupProductionDetails(String randomString, String chitBoyId, String imei, String versionId, String date, String mobileNo, String yearCode) async {
    try {
      // String uri = "http://117.205.2.18:8082/FlutterMIS/ProductionController";

      String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
      String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
      String uri = '$baseUrl/ProductionController';
      Map<String, dynamic> requestBody = {
        'action': "syrupProduction",
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
        if (res.body.isNotEmpty) {
          Map<String, dynamic> data = jsonDecode(res.body);
          final SyrupUtpadanResponse syrupResponse = SyrupUtpadanResponse.fromJson(data);
          print("syrupResponse is: ${data}");
          return syrupResponse;
        } else {
          throw Exception("Empty response body");
        }
      } else {
        throw Exception("Failed to load data: ${res.statusCode}");
      }
    } catch (error) {
      print("Error: ${error}");
      return SyrupUtpadanResponse(
        nsugTypeId: 0,
        nlocationId: 0,
        success: false,
        update: false,
        syrupProductionBeanMap: {},


      );
    }
  }

}


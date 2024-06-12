import 'dart:convert';
import 'package:SomeshwarManagementApp/Api_client/api_response.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:SomeshwarManagementApp/pojo/login_response.dart';
import 'package:SomeshwarManagementApp/pojo/main_response.dart';
import 'package:SomeshwarManagementApp/ui/otp_activity.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import '../constant/random_string.dart';
import '../constant/snackbar_apierror.dart';
import '../constantfunction/constant_function.dart';
import '../progress_bar/dynamic_circular_bar.dart';
import '../progress_bar/progress_bar.dart';

import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginResponse loginResponse = LoginResponse();
  MainResponse mainResponse = MainResponse();

  List<String> key = ['chitBoyId', 'uniquestring'];
  List<String> value = ['', '0'];
  static String identifier = 'Identifier not available';
  TextEditingController mobileno = TextEditingController();

  String selectedRadioButtonValue = '1'; // Default factory selection
  String baseUrl = "";

  Future<void> submit() async {
    if(mobileno.text=="")return;
    var appSignatureId= await SmsAutoFill().getAppSignature;
    Map sendOtpData={
      "mobile_number":mobileno.text,
      "app_signature_id":appSignatureId,
    };
    print("sendOtpData: ${sendOtpData}");
  }

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
    _loadBaseUrl();
    _loadSelectedRadioButtonValue();
  }

  Future<String> _loadBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBaseUrl = prefs.getString('baseUrl') ?? ""; // Retrieve base URL from shared preferences
    return savedBaseUrl;
  }
  Future<void> _updateBaseUrl() async {
    setState(() {
      baseUrl = ApiResponse.determineBaseUrl(selectedRadioButtonValue); // Determine base URL based on selected factory
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', baseUrl);
  }


  Future<void> _loadSelectedRadioButtonValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadioButtonValue = prefs.getString('selectedRadioButtonValue') ?? '1';
    });
  }

  Future<void> _saveSelectedRadioButtonValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedRadioButtonValue', value);
  }

  Future<void> saveChitBoyIdToPrefs(String ? chitBoyId) async {
    if (chitBoyId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('chitBoyId', chitBoyId);
    } else {
      // Handle the case where chitBoyId is null, if needed
      print("chitBoyId is null. Cannot save to SharedPreferences.");
    }
  }
  Future<void> saveRandomStringToPref(String ? randomString) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('randomString', randomString);
    if (randomString != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('randomString', randomString);
    } else {
      // Handle the case where chitBoyId is null, if needed
      print("randomString is null. Cannot save to SharedPreferences.");
    }
  }

  Future<String?> getChitBoyIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('chitBoyId');
  }
  // Future<void> saveMobileNo(String mobileno) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mobileNo', mobileno);
  // }
  static Color lightBlue = Color(0xFFADD8E6);


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
  DateTime? currentBackPressTime;
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
        ),
      );
      return false;
    } else {
      SystemNavigator.pop();
      return true;
    }
  }

  static Color lavender = Color(0xFFE6E6FA);
  static Color teal = Color(0xFF008080);
  static  Color coral = Color(0xFFFF7F50);
  static  Color mintGreen = Color(0xFF98FF98);



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                // Handle back button presse
                exit(0);
              },
              icon: Icon(Icons.arrow_back, color: Colors.green, size: 25),
            ),
            title: Text(
              'सोमेश्वर मॅनेजमेंट अ‍ॅप',
              style: TextStyle(
                fontSize: 25,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  _showSettingsDialog(context);
                },
                icon: Icon(Icons.settings, color: Colors.green, size: 25),
              ),
            ],
          ),
        ),


        body: OrientationBuilder(
          builder: (context, orientation) {
            return Stack(
              children: [
                Image.asset(
                  "assets/images/someshwarnew.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.only(top: 120,left: 10,right: 10),
                    child: Align(

                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 1.0,
                        // height: orientation == Orientation.portrait ? 400 : 300,
                        height: 420,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: mintGreen, width: 2.0),
                          ),
                          // color: Colors.white,
                          color:Colors.white,
            shadowColor:lavender,


            elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,

                                        border: Border.all(color: Colors.green,width: 3)
                                    ),
                                    child: ClipOval(child: Lottie.asset('assets/animations/loginanim.json',width: 150,height: 150,)
                                    )

                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Text(

                                    'लॉग इन ',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 30,

                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green,
                                      // Change the border color as needed
                                      width: 2.0, // Adjust the border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the border radius
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: mobileno,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                      labelText: "Enter 10 digit Mobile No",
                                      hintText: "मोबाइल क्रमांक",
                                      border: InputBorder.none, // Remove the default border
                                    ),
                                  ),

                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextButton(
                                    onPressed: () async {
                                      setState(() {

                                      });
                                      submit();
                                      String phoneno = mobileno.text;
                                      if (phoneno.isEmpty) {
                                        double height = 220.0;
                                        String mobileNoEmptyMsg = "कृपया मोबाइल क्रमांक टाका.";
                                        print("Please Enter Mobile Number");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(
                                                    10), // Adjust the border radius
                                                border: Border.all(
                                                  color: Colors.greenAccent,
                                                  width: 2.0, // Adjust the border width
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  "कृपया मोबाइल क्रमांक टाका.",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        );
                                      }
                                      else if (phoneno.length < 10) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(
                                                    10), // Adjust the border radius
                                                border: Border.all(
                                                  color: Colors.greenAccent,
                                                  width: 2.0, // Adjust the border width
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  "फोन नंबर चुकीचा आहे.",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        );
                                      }
                                      else if (phoneno.length > 12) {

                                        toastification.show(
                                          context: context,
                                          title: Text('Hello, world!'),
                                          autoCloseDuration: const Duration(seconds: 5),
                                          alignment: Alignment.topRight,
                                          direction: TextDirection.ltr,
                                          animationDuration: const Duration(milliseconds: 300),

                                          icon: const Icon(Icons.check),
                                          primaryColor: Colors.green,
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          borderRadius: BorderRadius.circular(12),
                                        );

                                      }
                                      else {
                                        //DynamicCircularProgress();
                                        //CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.yellow);
                                        ProgressDialog.loadProgressDialog(context);
                                        await _getDeviceInfo();
                                        String versionId = await AppInfo.getVersionId();
                                        setState(() {
                                          //saveMobileNo(phoneno);
                                        });

                                        String chitBoyId = "";
                                        String randomString = "";
                                        String selectedRadioButtonId = this.selectedRadioButtonValue;
                                        doLogin(phoneno, identifier, randomString, versionId, chitBoyId,selectedRadioButtonId);
                                        submit();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomePage()),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'लॉग इन',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('सर्वर निवडा',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blue),)),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,


                        border: Border.all(color: Colors.green,width: 3)
                    ),
                    child: ClipOval(child: Lottie.asset('assets/animations/serverselection.json',width: 150,height: 150,)
                    )

                ),
                RadioListTile<String>(
                  title: Text('एअरटेल',style: TextStyle(
                    color: Colors.black,
                    fontSize: 16// Example text color
                  ),),
                  value: '1',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),
                RadioListTile<String>(
                  title: Text('बी.एस.एन.एल.',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '2',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),

                RadioListTile<String>(
                  title: Text('एअरटेल Debug',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '3',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),
                RadioListTile<String>(
                  title: Text('बी.एस.एन.एल. Debug',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '4',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),

                RadioListTile<String>(
                  title: Text('वाय-फाय १ (172)',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '5',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),
                RadioListTile<String>(
                  title: Text('वाय-फाय २ (192)',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '6',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),

                RadioListTile<String>(
                  title: Text('वाय-फाय Debug १ (172',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '7',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),
                RadioListTile<String>(
                  title: Text('वाय-फाय Debug २ (192)',style: TextStyle(
                      color: Colors.black,
                      fontSize: 16// Example text color
                  ),),
                  value: '8',
                  groupValue: selectedRadioButtonValue,
                  onChanged: (value) async {
                    setState(() {
                      selectedRadioButtonValue = value!;
                      print("selected value: ${selectedRadioButtonValue}");
                      _updateBaseUrl(); // Update base URL when radio button selection changes
                    });
                    await _saveSelectedRadioButtonValue(value!);
                  },
                ),


                SizedBox(height: 10),

                Text('Base URL: $baseUrl'),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> doLogin(String mobileno, String imei, String randomString, String versionId, String chitBoyId,String selectedRadioButtonValue) async {
    if (mobileno.isNotEmpty) {
      try {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          print("No internet connectivity");
          return;
        }
         // String uri = "http://117.205.2.18:8082/FlutterMIS/app_login";
  //String value=await SharedPreferencesHelper.getSelectedRadioButtonValue();

        String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
        print("selectedRadioButtonValue IS: ${selectedRadioButtonValue}");
        String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
        String uri = '$baseUrl/app_login';
        print("uri is : ${uri}");

        Map<String, dynamic> requestBody = {
          'action': "Login",
          'mobileno': mobileno,
          'imei': imei,
          'randomString': randomString,
          'versionId': versionId,
          'chitBoyId': chitBoyId,
        };

        String json = jsonEncode(requestBody);
        var res = await http.post(
          Uri.parse(uri),
          body: json,
          headers: {'Content-Type': 'application/json'},
        );
        double customHeight = 220.0;
        if (res.statusCode == 200) {
          var jsondecode = jsonDecode(res.body);
          if (jsondecode.containsKey("success") && jsondecode["success"] == true) {
            String chitBoyId = jsondecode["chitBoyId"];
            String randomString = jsondecode["uniquestring"];
            String mobileno = jsondecode["mobileno"];


            await SharedPreferencesHelper.storeValuesInSharedPref(chitBoyId, randomString, mobileno, imei);




            String storedMobileNo = await SharedPreferencesHelper.getMobileNo();
            String oldPin = await SharedPreferencesHelper.getLoginPin();

            // Update the state with the obtained values
            setState(() {
              storedMobileNo = storedMobileNo;
              oldPin = oldPin;
            });

            // Navigate to the next screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OtpActivity(
                  imei: imei,
                  randomString: randomString,
                  versionId: versionId,
                  chitBoyId: chitBoyId,
                  //selectedRadioButtonValue:selectedRadioButtonValue,
                ),
              ),
            );
          } else {
            String servererrormsg = jsondecode['se']['msg'];
            SnackbarHelper.showSnackbar(
              context,
              msg: servererrormsg,
              height: customHeight,
            );
          }
        } else {
          // Handle other status codes or errors
          print('Error: ${res.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    } else {
      print("Please Fill All Details");
    }
  }

//   Future<void> doLogin(String mobileno, String imei, String randomString,
//       String versionId, String chitBoyId) async {
// // List<String> data
//     if (mobileno.isNotEmpty) {
//       try {
//         var connectivityResult = await Connectivity().checkConnectivity();
//
//         if (connectivityResult == ConnectivityResult.none) {
//           print("No internet connectivity");
//           return;
//         }
// //117.205.2.18
//         String uri = "http://117.205.2.18:8082/FlutterMIS/app_login";
//         Map<String, dynamic> requestBody = {
//           'action': "Login",
//           'mobileno': mobileno,
//           'imei': imei,
//           'randomString': randomString,
//           'versionId': versionId,
//           //'data': data,
//           'chitBoyId': chitBoyId,
//         };
//
//         String json = jsonEncode(requestBody);
//         var res = await http.post(
//           Uri.parse(uri),
//           body: json,
//           headers: {'Content-Type': 'application/json'},
//         );
//
//         double customHeight = 220.0;
//
//         if (res.statusCode == 200) {
//           var jsondecode = jsonDecode(res.body);
//
//
//           if (jsondecode.containsKey("success") &&
//               jsondecode["success"] == true) {
//             String chitBoyId = jsondecode["chitBoyId"];
//             String randomString = jsondecode["uniquestring"];
//             String mobileno = jsondecode["mobileno"];
//
//             ConstantFunction cf = new ConstantFunction();
//             setState(() async {
//               // PreferencesHelper.storeValuesInSharedPreferences(
//               //     chitBoyId, randomString, mobileno, imei);
//               // PreferencesHelper.getStoredMobileNo();
//               // PreferencesHelper.getOldPinFromSharedPreferences();
//                SharedPreferencesHelper.storeValuesInSharedPref(chitBoyId, randomString, mobileno, imei);
//
//                String storedMobileNo = await SharedPreferencesHelper.getMobileNo();
//                print('Stored Mobile Number: $storedMobileNo');
//
//                // Retrieve old PIN from SharedPreferences
//                String oldPin = await SharedPreferencesHelper.getLoginPin();
//                print('Old PIN: $oldPin');
//
//                storedMobileNo = storedMobileNo;
//                oldPin = oldPin;
//             });
//
//             print("JSONRESPONSE:==> $jsondecode");
//             try {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       OtpActivity(
//                         imei: imei,
//                         randomString: randomString,
//                         versionId: versionId,
//                         chitBoyId: chitBoyId,
//                       ),
//                 ),
//               );
//             } catch (e, s) {
//               print(s);
//             }
//           } else {
//             String servererrormsg = jsondecode['se']['msg'];
//             SnackbarHelper.showSnackbar(
//               context,
//               msg: servererrormsg,
//               height: customHeight,
//             );
//           }
//         } else {
//           // Handle other status codes or errors
//           print('Error: ${res.statusCode}');
//         }
//       } catch (error) {
//         print('Error: $error');
//       }
//     } else {
//       print("Please Fill All Details");
//     }
//   }


}







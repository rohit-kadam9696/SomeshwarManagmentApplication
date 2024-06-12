import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SomeshwarManagementApp/SharedPrefrence/shared_pref2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:SomeshwarManagementApp/appInfo/app_info.dart';
import 'package:SomeshwarManagementApp/ui/authnticate2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import '../constant/snackbar_apierror.dart';
import 'bottom_nav_activity.dart';
import 'dart:convert' as convert;

import 'otp_activity.dart';

class ForgotPinActivity extends StatefulWidget {
  const ForgotPinActivity({super.key});

  @override
  State<ForgotPinActivity> createState() => _ForgotPinActivityState();
}

class _ForgotPinActivityState extends State<ForgotPinActivity> {

  TextEditingController _otpcontroller = TextEditingController();
  TextEditingController newpinController = TextEditingController();
  TextEditingController reenternewpinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resendOtpCAll();
    _otpcontroller.addListener(() {moveNewPin();});
    newpinController.addListener(() { moveConfirm();});
    reenternewpinController.addListener(() { setConfirm();});

  }

  Future<void> resendOtpCAll() async {
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String imei = await SharedPreferencesHelper.getImei();
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();
    resendOtp(mobileNo, chitBoyId, imei, randomString, versionId);
  }

  @override
  void dispose(){
    super.dispose();
  }
  Future<void> resendOtp(String mobileno, String chitBoyId, String imei,
      String randomString, String versionId) async {
    if (mobileno.isNotEmpty) {
      try {
        // var connectivityResult = await Connectivity().checkConnectivity();
        String uri = "http://103.162.65.78:8082/FlutterMIS/app_login";
        Map<String, dynamic> requestBody = {
          'action': 'resendotp',
          'mobileno': mobileno,
          'chitBoyId': chitBoyId,
          'imei': imei,
          'randomString': randomString,
          'versionId': versionId,
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
          if (jsondecode.containsKey("success") &&
              jsondecode["success"] == true) {
            String chitBoyId = jsondecode["slipboycode"];
            String randomString = jsondecode["uniquestring"];
            String mobileno = jsondecode['mobileno'];
            SharedPreferencesHelper.storeValuesInSharedPref(
                chitBoyId, randomString, mobileno, imei);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => OtpActivity(
            //       imei: imei,
            //       randomString: randomString,
            //       versionId: versionId,
            //       chitBoyId: chitBoyId,
            //     ),
            //   ),
            // );
          } else {
            String servererrormsg = jsondecode['se']['msg'];
            SnackbarHelper.showSnackbar(
              context,
              msg: servererrormsg,
              height: customHeight,
            );
          }
        } else {
          print('Error: ${res.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    } else {
      print("Please Fill All Details");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
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
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.width * 1.5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  ' पिन विसरलात',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Container(

                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2.0, // Adjust the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: _otpcontroller,
                                  //  onChanged: (value) =>moveNewPin(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 40),
                                    labelText: "ओ.टी.पी टाका.",
                                    //hintText: "ओ.टी.पी टाका.",
                                    border: InputBorder
                                        .none, // Remove the default border
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2.0, // Adjust the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: newpinController,
                                  //onChanged: (value) =>moveConfirm(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 40),
                                    labelText: "नवीन पिन टाका.",
                                    //   hintText: "नवीन पिन टाका.",
                                    border: InputBorder
                                        .none, // Remove the default border
                                  ),
                                ),
                              ),
                              SizedBox(height: 2,),
                              Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2.0, // Adjust the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the border radius
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: reenternewpinController,
                                  // onChanged: (value) =>setConfirm(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 40),
                                    labelText: "नवीन पिन पुन्हा टाका.",
                                    //hintText: "नवीन पिन पुन्हा टाका.",
                                    border: InputBorder
                                        .none, // Remove the default border
                                  ),
                                ),
                              ),
                              SizedBox(height: 2,),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: TextButton(
                                  onPressed: () {
                                    String otp = _otpcontroller.text.toString();
                                    String newPin = newpinController.text
                                        .toString();
                                    String reenterPin = reenternewpinController
                                        .text.toString();
                                    if (otp.isEmpty || newPin.isEmpty ||
                                        reenterPin.isEmpty) {
                                      if (otp.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                // Adjust the border radius
                                                border: Border.all(
                                                  color: Colors.greenAccent,
                                                  // Adjust the border color
                                                  width:
                                                  2.0, // Adjust the border width
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  "कृपया आपला जुना पिन टाका. ",
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
                                      else if (newPin.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                // Adjust the border radius
                                                border: Border.all(
                                                  color: Colors.greenAccent,
                                                  // Adjust the border color
                                                  width:
                                                  2.0, // Adjust the border width
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  "कृपया आपला नवीन पिन टाका.",
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
                                      else if (reenterPin.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Container(
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                // Adjust the border radius
                                                border: Border.all(
                                                  color: Colors.greenAccent,
                                                  // Adjust the border color
                                                  width:
                                                  2.0, // Adjust the border width
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                child: Text(
                                                  "कृपया आपला नवीन पिन पुन्हा टाका.",
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
                                    }
                                    CircularProgressIndicator();
                                    performSetPin();
                                    try {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthenticateController(),
                                      ),
                                      );
                                    } catch (e, s) {
                                      print(s);
                                    }
                                  },
                                  child: Text(' पिन बदला ',
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
              ],
            );
          },
        ),
      ),
    );
  }
  void moveNewPin() {
    String oldloginpin = _otpcontroller.text;
    if (oldloginpin.length >= 5) {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
  void setConfirm() {
    String confirmloginpin = reenternewpinController.text;
    if (confirmloginpin.length == 4) {
      performSetPin();
    }
  }
  void moveConfirm() {
    String loginpin = newpinController.text;
    if (loginpin.length == 4) {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
  void performSetPin() async {
    String loginpins = newpinController.text.toString();
    String confirmpins = reenternewpinController.text.toString();
    String forgototptext = _otpcontroller.text.toString();
    String mobileNo = await SharedPreferencesHelper.getMobileNo();
    String imei = await SharedPreferencesHelper.getImei();
    String randomString = await SharedPreferencesHelper.getUniqString();
    String chitBoyId = await SharedPreferencesHelper.getChitboyId();
    String versionId = await AppInfo.getVersionId();

    if (loginpins.length == 4 && confirmpins.length == 4 && loginpins == confirmpins) {
      final bool isNumber = RegExp(r'^[0-9]+$').hasMatch(forgototptext);
      final bool isGreaterLength = forgototptext.length >= 5;
      await SharedPreferencesHelper.setLoginPin(loginpins);
      if (isNumber && isGreaterLength) {
        try {
          String selectedRadioButtonValue = (await SharedPreferences.getInstance()).getString('selectedRadioButtonValue') ?? '1';
          String baseUrl =ApiResponse.determineBaseUrl(selectedRadioButtonValue);
          String uri = '$baseUrl/app_login';
          Map<String, dynamic> requestBody = {
            'action': 'verifyotp',
            'mobileno': mobileNo,
            'otp': forgototptext,
            'chitBoyId': chitBoyId,
            'imei': imei,
            'randomString': randomString,
            'versionId': versionId,
          };
          String json = jsonEncode(requestBody);
          var res = await http.post(
            Uri.parse(uri),
            body: json,
            headers: {'Content-Type': 'application/json'},
          );
          if (res.statusCode == 200) {
            var jsondecode = jsonDecode(res.body);
            print("verify otp  pin jsondecode is: ${jsondecode}");
            SharedPreferences prefs = await SharedPreferences.getInstance();
          } else {
            // Handle error response
          }
        } catch (e) {
          // Handle exceptions
        }
      } else {
        _otpcontroller.text = '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid OTP!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PINs do not match!'),
        ),
      );
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:telephony/telephony.dart';

import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import '../constant/snackbar_apierror.dart';
import '../constantfunction/constant_function.dart';
import 'change_pin_activity.dart';
import 'home_page.dart';


class OtpActivity extends StatefulWidget {
  final String imei;
  final String randomString;
  final String versionId;
  final String chitBoyId;

  const OtpActivity({
    required this.imei,
    required this.randomString,
    required this.versionId,
    required this.chitBoyId,
  });

  @override
  State<OtpActivity> createState() => _OtpActivityState();
}


class _OtpActivityState extends State<OtpActivity> with CodeAutoFill {
  String mobileno = '';
  late TextEditingController otpController;
  late TextEditingController countdownController;
  late TextEditingController resendController;
  late bool resendControllerVisible;
  late bool countdownControllerVisible;
  late Timer _timer;


  bool otpReceived = false;

  String codeValue = "";
  Telephony telephony = Telephony.instance;

  ObscureStyle customObscureStyle = ObscureStyle(
    isTextObscure: true, // Initially obscure text with '*'
    obscureText: '*',
  );
  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    countdownController = TextEditingController(text: 'vat paha');
    resendController = TextEditingController(text: 'ओ.टी.पी पुन्हा पाठवा.');
    resendControllerVisible = false;
    countdownControllerVisible = false;
    getMobileNoFromSharedpref();
    startCounter();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        codeValue =otpController.text ;
        otpReceived = true;
        customObscureStyle = ObscureStyle(
          isTextObscure: false, // Set to false to reveal OTP
          obscureText: '*', // Not necessary in this case, as isTextObscure is false
        );
      });
    });
    listenOtp();


    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address);
        print(message.body);

        String sms = message.body.toString();
        print("sms is: ${sms}");
        String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
        print("otpcode is: ${otpcode}");
        otpController.text = otpcode;

      //  otpController.set(otpcode.split(""));

      },
      listenInBackground: false,
    );

  }


  Future<void> listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP listen called");
  }

  @override
  void codeUpdated() {
    print("updated code $code");
    setState(() {
      print("codeUpdated");
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    countdownController.dispose();
    resendController.dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void startCounter() {
    const int countDownTime = 120; // seconds
    const int countDownInterval = 1; // seconds

    int remainingTime = countDownTime;

    _timer = Timer.periodic(Duration(seconds: countDownInterval), (timer) {
      if (remainingTime > 0) {
        int minutes = remainingTime ~/ 60;
        int seconds = remainingTime % 60;
        countdownController.text =
        'Resend in: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

        remainingTime -= countDownInterval;

        setState(() {
          resendControllerVisible = false;
          countdownControllerVisible = true;
        });
      } else {
        timer.cancel();
        setState(() {
          resendControllerVisible = true;
          countdownControllerVisible = false;
        });
      }
    });
  }

  Future<void> getMobileNoFromSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileno = prefs.getString('flutter.mobileNo') ?? '';
    });
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    margin: EdgeInsets.only(top: 80,bottom:170),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                     //   height: 420,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          elevation: 5,
                          margin: EdgeInsets.only(left:10,right:10),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView(
                              children: [
                                Container(

                                    margin: EdgeInsets.only(top: 10,left: 175),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                        border: Border.all(color: Colors.green,width: 3)
                                    ),
                                    child: ClipOval(child: Lottie.asset('assets/animations/otpanim.json',width: 280,height: 210)
                                    )

                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    'ओ.टी.पी. आपल्या $mobileno या क्रमांकवर पाठविला आहे. कृपया प्रतीक्षा करा.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      "कृपया मोबाइल क्रमांक बदला",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),

                                  child: PinFieldAutoFill(


                                    // decoration:BoxLooseDecoration(
                                    //
                                    //
                                    //   textStyle: const TextStyle(fontSize: 25, color: Colors.blue,fontWeight: FontWeight.bold),
                                    //   bgColorBuilder: FixedColorBuilder(Colors.white.withOpacity(0.4)),
                                    //  strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.4)),
                                    // ),
                                    decoration:CirclePinDecoration(
                                      obscureStyle: ObscureStyle(
                                        isTextObscure: !otpReceived, // Initially obscure text with '*'
                                        obscureText: '*', // Specify the character used to obscure the text
                                      ),
                                      strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.5)),
                                      textStyle: const TextStyle(fontSize: 25, color: Colors.blue,fontWeight: FontWeight.bold),
                                        bgColorBuilder: FixedColorBuilder(Colors.white.withOpacity(0.2)),
                                      strokeWidth: 3.0,

                                    ),

                                    controller: otpController,
                                    currentCode: codeValue,
                                    codeLength: 5,
                                    autoFocus: true,
                                    onCodeChanged: (code) {

                                      print("onCodeChanged $code");
                                      setState(() {

                                        codeValue = code.toString();

                                      });
                                    },
                                    onCodeSubmitted: (val) {
                                      print("onCodeSubmitted $val");
                                    },

                                  ),
                                ),
                                Visibility(
                                  visible: countdownControllerVisible,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 120),
                                    child: TextFormField(
                                      controller: countdownController,
                                      readOnly: true,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Open Sans',
                                        fontSize: 20,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: resendControllerVisible,
                                  child: TextButton(
                                    onPressed: () async {
                                      String randomString =
                                      await SharedPreferencesHelper
                                          .getUniqString();
                                      String chitBoyId =
                                      await SharedPreferencesHelper
                                          .getChitboyId();
                                      String versionId =
                                      await AppInfo.getVersionId();
                                      String mobileNo =
                                      await SharedPreferencesHelper
                                          .getMobileNo();
                                      String YearCode =
                                      await SharedPreferencesHelper
                                          .getYearCode();
                                      String imei =
                                      await SharedPreferencesHelper.getImei();
                                      resendOtp(mobileNo, chitBoyId, imei,
                                          randomString, versionId);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 70),
                                      child: TextFormField(
                                        controller: resendController,
                                        readOnly: true,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Open Sans',
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                  !countdownControllerVisible &&
                                      !resendControllerVisible,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'वाट पाहा',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: () async {
                                      String randomString =
                                      await SharedPreferencesHelper
                                          .getUniqString();
                                      String chitBoyId =
                                      await SharedPreferencesHelper
                                          .getChitboyId();
                                      String versionId =
                                      await AppInfo.getVersionId();
                                      String mobileNo =
                                      await SharedPreferencesHelper
                                          .getMobileNo();
                                      String YearCode =
                                      await SharedPreferencesHelper
                                          .getYearCode();
                                      String imei =
                                      await SharedPreferencesHelper.getImei();
                                      String enteredOtp = otpController.text;

                                      if (enteredOtp.isEmpty) {
                                        String msg =
                                            "कृपया ओ.टी.पी टाका. ";
                                        SnackbarHelper.showSnackBar2(
                                            context,
                                            msg: msg,
                                            height: 220);
                                      } else if (enteredOtp.length == 5) {
                                        fetchCorrectOtpFromServer(
                                            mobileNo,
                                            enteredOtp,
                                            chitBoyId,
                                            imei,
                                            randomString,
                                            versionId);
                                      } else if (enteredOtp.length !=
                                          5) {
                                        String msg =
                                            "कृपया योग्य ओ.टी.पी टाका ";
                                        SnackbarHelper.showSnackBar2(
                                            context,
                                            msg: msg,
                                            height: 220);
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        'पुष्टी करा',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
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
                                SizedBox(height: 10),
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

  Future<void> fetchCorrectOtpFromServer(String mobileno, String otp,
      String? chitBoyId, String imei, String randomString, String versionId) async {
    ConstantFunction cf = ConstantFunction();
    if (mobileno.isNotEmpty) {
      try {
        var connectivityResult = await Connectivity().checkConnectivity();
        String selectedRadioButtonValue =
            (await SharedPreferences.getInstance())
                .getString('selectedRadioButtonValue') ??
                '1';
        String baseUrl = ApiResponse.determineBaseUrl(selectedRadioButtonValue);
        String uri = '$baseUrl/app_login';

        Map<String, dynamic> requestBody = {
          'action': 'verifyotp',
          'mobileno': mobileno,
          'otp': otp,
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
            String randomString = jsondecode['uniquestring'];
            String slipboycode = jsondecode['slipboycode'];
            String mobileno = jsondecode['mobileno'];
            String yearCode = jsondecode['yearCode'];
            SharedPreferencesHelper.storeValuesInSharedPref(
                slipboycode, randomString, mobileno, imei);
            SharedPreferencesHelper.updateYearCode(yearCode);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePinActivity(),
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
          print('Error: ${res.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    } else {
      print("Please Fill All Details");
    }
  }

  Future<void> resendOtp(String mobileno, String chitBoyId, String imei,
      String randomString, String versionId) async {
    ConstantFunction cf = ConstantFunction();
    if (mobileno.isNotEmpty) {
      try {
        var connectivityResult = await Connectivity().checkConnectivity();
        String selectedRadioButtonValue =
            (await SharedPreferences.getInstance())
                .getString('selectedRadioButtonValue') ??
                '1';
        String baseUrl = ApiResponse.determineBaseUrl(selectedRadioButtonValue);
        String uri = '$baseUrl/app_login';
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpActivity(
                  imei: imei,
                  randomString: randomString,
                  versionId: versionId,
                  chitBoyId: chitBoyId,
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
          print('Error: ${res.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    } else {
      print("Please Fill All Details");
    }
  }
}


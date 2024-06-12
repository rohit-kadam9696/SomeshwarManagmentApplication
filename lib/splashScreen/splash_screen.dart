import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:SomeshwarManagementApp/ui/us_galap_activity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API_CALL/api_call.dart';
import '../Api_client/api_response.dart';
import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../appInfo/app_info.dart';
import '../pojo/crushing_response.dart';
import '../ui/authnticate2.dart';
import '../ui/bottom_nav_activity.dart';
import '../ui/change_pin_activity.dart';
import '../ui/home_page.dart';
import 'package:http/http.dart' as http;
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver, TickerProviderStateMixin{
  bool _loggedIn = false;
  static String identifier = 'Identifier not available';
  String chitBoyId = '';
  String uniqstring = '';
  String mobileNo = '';
  String imei = '';
  String pin='';
  double _position = 0.0;

  // late double todayCrushing;
  // late double uptoTodayCrushing;
  // Future<void> fetchData() async {
  //   try {
  //     // Replace these parameters with actual values or variables
  //     final response = await API.crushingReport1(
  //       'randomString',
  //       'chitBoyId',
  //       'imei',
  //       'versionId',
  //       'date',
  //       'mobileNo',
  //       'yearCode',
  //     );
  //     setState(() {
  //       todayCrushing = response.todayCrushing;
  //       uptoTodayCrushing = response.uptoTodayCrushing;
  //     });
  //
  //     // Navigate to the next screen or handle the data accordingly
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => UsGalapPage(
  //           todayCrushing: todayCrushing,
  //           uptoTodayCrushing: uptoTodayCrushing,
  //         ),
  //       ),
  //     );
  //   } catch (error) {
  //     print('Error: $error');
  //     // Handle the error, for example, show a snackbar or retry logic
  //   }
  // }



  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
    _getDeviceInfo();
    _timer = Timer.periodic(Duration(milliseconds: 40), (timer) {
      setState(() {
        _position += 1.0; // Adjust the speed by changing this value
        if (_position >= MediaQuery.of(context).size.width) {
          _position = 0.0;
        }
      });
    });
 //   fetchData();
    WidgetsBinding.instance!.addObserver(this);

  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLoggedInStatus(context);
    }
  }
  Future<void> _loadSharedPreferences() async {
    chitBoyId = await SharedPreferencesHelper.getChitboyId();
    uniqstring = await SharedPreferencesHelper.getUniqString();
    mobileNo = await SharedPreferencesHelper.getMobileNo();
    imei = await SharedPreferencesHelper.getImei();
    pin= await SharedPreferencesHelper.getLoginPin();

    print("pins is : ${pin}");
    String version = await AppInfo.getVersionId();
    setState(() {
      // Update the state variables with the obtained values
      chitBoyId = chitBoyId;
      uniqstring = uniqstring;
      mobileNo = mobileNo;
      imei = imei;
      pin=pin;
    });
    await Future.delayed(Duration(seconds: 3));
    await _checkLoggedInStatus(context);
  }

  // Future<void> _checkLoggedInStatus(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? mobileNo = prefs.getString('flutter.mobileNo');
  //   String? pin =   prefs.getString('flutter.loginPin');
  //
  //   print("my mobile no is: ${mobileNo}");
  //
  //   print("my pin no is: ${pin}");
  //
  //   // if (pin == null || pin.isEmpty) {
  //   //   // PIN is null or empty, navigate to a page for PIN setup
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(builder: (context) => ChangePinActivity()),
  //   //   );
  //   // } else if (mobileNo == null || mobileNo.isEmpty) {
  //   //   // Mobile number is null or empty, navigate to HomePage
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(builder: (context) => HomePage()),
  //   //   );
  //   // } else {
  //   //   // Mobile number is not null or empty and PIN is not null, user is logged in, navigate to AuthenticateActivity
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(builder: (context) => AuthenticateController()),
  //   //   );
  //   // }
  //
  //   // Navigator.pushReplacement(
  //   //         context,
  //   //         MaterialPageRoute(builder: (context) => AuthenticateController()),
  //   //       );
  //
  //
  //   // if (pin == null) {
  //   //   // PIN is null, navigate to a page for PIN setup
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(builder: (context) => ChangePinActivity()),
  //   //   );
  //   // } else if (mobileNo == null || mobileNo.isEmpty) {
  //   //   // Mobile number is null or empty, navigate to HomePage
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(builder: (context) => HomePage()),
  //   //   );
  //   // } else {
  //   //   // Mobile number is not null or empty and PIN is not null, user is logged in, navigate to BottomNav
  //   //   setState(() {
  //   //     _loggedIn = true;
  //   //   });
  //   //   Navigator.pushReplacement(
  //   //     context,
  //   //     MaterialPageRoute(builder: (context) => BottomNav()),
  //   //   );
  //   // }
  //   //
  //   if (mobileNo != null && mobileNo.isNotEmpty) {
  //     setState(() {
  //       _loggedIn = true;
  //     });
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()),);
  //   }
  //   else {
  //     // User has not logged in before
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   }
  //
  //   // Navigator.pushReplacement(
  //   //         context,
  //   //         MaterialPageRoute(builder: (context) => HomePage())
  //   // );
  // }

  Future<void> _checkLoggedInStatus(BuildContext context) async {
    if (!mounted) return; // Check if the state is still active

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNo = prefs.getString('flutter.mobileNo');
    String? pin = prefs.getString('flutter.loginPin');

    print("my mobile no is: ${mobileNo}");
    print("my pin no is: ${pin}");

    if (mounted) { // Check if the state is still active
      setState(() {
        // Update _loggedIn based on mobile number availability
        _loggedIn = mobileNo != null && mobileNo.isNotEmpty;
      });

      if (pin == null || pin.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChangePinActivity()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsGalapPage()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }




    // if (_loggedIn) {
    //   // If mobile number is not empty, navigate to LoginPinActivity
    //   if (pin == null || pin.isEmpty) {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChangePinActivity()));
    //   }
    //   // If pin is not empty, navigate to AuthanticateActivity
    //   else {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthenticateController()));
    //   }
    // } else {
    //   // If mobile number is empty, navigate to LoginActivity
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    // }
    // if (_loggedIn) {
    //   // Navigate to BottomNav if the user is logged in
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
    // } else {
    //   // Navigate to HomePage if the user is not logged in
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    // }
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
  static const Color smallRed = Color(0xFFFA8E8E);

  @override
  Widget build(BuildContext context) {
    // Your splash screen UI
    return Scaffold(
     // backgroundColor: darkGreen,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 35),
            child: Center(
              child: Lottie.asset(
                'assets/animations/backscreen.json',
                height: 225,
                width: 225,// Replace 'assets/background_animation.json' with your Lottie animation file path
                //fit: BoxFit.fitHeight,

              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: Container(
                    width: 185, // Set the desired width
                    height: 185, // Set the desired height
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Set the border color
                        width: 2, // Set the border width
                      ),
                    ),
                    child: ScaleTransition(
                      scale: _animation,
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Image.asset(
                            'lib/splashScreenImage/Logo Someshwar.png', // Adjust the path accordingly
                            height: 235,
                            width: 235,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(

            margin: EdgeInsets.only(top: 460,left: 80,right: 80),
            child: Lottie.asset(
              'assets/animations/hand.json',
              // Replace 'assets/background_animation.json' with your Lottie animation file path
              fit: BoxFit.cover,


            ),
          ),
          Positioned(
            left: _position + 80, // Adjust the left position as needed
            bottom: 50,
            child: Text(
              'श्री.सोमेश्वर मॅनेजमेंट अ‍ॅप',
              style: TextStyle(fontSize: 25, color: smallRed,fontWeight:FontWeight.bold),
            ),
          )


        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constant/snackbar_apierror.dart';
import 'change_pin_activity.dart';
import 'fogot_pin.dart';
class AuthenticateController extends StatefulWidget {
  @override
  _AuthenticateControllerState createState() => _AuthenticateControllerState();
}

class _AuthenticateControllerState extends State<AuthenticateController> {
  late LocalAuthentication auth;
  bool isDeviceSupport = false;
  List<BiometricType>? availableBiometrics;
  TextEditingController _pinController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_onPinChanged);
    auth = LocalAuthentication();
    deviceCapability();
    _authenticate(); // Call authentication method when activity is opened
  }
  @override
  void dispose() {
    _pinController.removeListener(_onPinChanged);
    _pinController.dispose();
    super.dispose();
  }
  void _onPinChanged() {
    String enteredPin = _pinController.text;
    if (enteredPin.length == 4) {
      validatePin();
    }
  }
  Future<bool> validatePin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myPin = prefs.getString('flutter.loginPin');
    print("Loginpin is: ${myPin}");
    String enteredPin = _pinController.text;

    print("enteredPin is: ${enteredPin}");

    if (enteredPin == myPin) {
      Navigator.pushReplacementNamed(context, '/usgalapPage');
      return true;
    }
    else {
            double customHeight=220.0;
            String msg="आपण चुकीचा पिन टाकत आहात.";
          SnackbarHelper.showSnackBar2(
        context,
        msg: msg,
        height: customHeight,
      );
      return false;
    }
  }

  void deviceCapability() async {
    final isCapable = await auth.isDeviceSupported();
    setState(() {
      isDeviceSupport = isCapable;
    });
  }
  Future<void> _authenticate() async {
    if (!mounted) return; // Check if the widget is still mounted

    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      print("biometric :$availableBiometrics");
      if (availableBiometrics!.contains(BiometricType.strong) ||
          availableBiometrics!.contains(BiometricType.fingerprint)) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Scan your fingerprint  to authenticate',
          options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
                signInTitle: 'Unlock Ideal Group', cancelButton: 'No thanks'),
            IOSAuthMessages(cancelButton: 'No thanks')
          ],
        );
        if (!mounted) return;
        if (didAuthenticate) {
          Navigator.pushReplacementNamed(context, '/usgalapPage');
        } else {
          setState(() {
            errorMessage = 'Authentication failed. Please try again.';
          });
        }
      } else if (availableBiometrics!.contains(BiometricType.weak) ||
          availableBiometrics!.contains(BiometricType.face)) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Scan your fingerprint  to authenticate',
          options: const AuthenticationOptions(stickyAuth: true),
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
                signInTitle: 'Unlock Ideal Group', cancelButton: 'No thanks'),
            IOSAuthMessages(cancelButton: 'No thanks')
          ],
        );
        if (!mounted) return;


        if (didAuthenticate) {
          Navigator.pushReplacementNamed(context, '/usgalapPage');
        } else {
          setState(() {
            errorMessage = 'Authentication failed. Please try again.';
          });
        }
      }
    } on PlatformException catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
      print("error: $e");
    }
  }

  // Future<void> _authenticate() async {
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //     print("biometric :$availableBiometrics");
  //     if (availableBiometrics!.contains(BiometricType.strong) ||
  //         availableBiometrics!.contains(BiometricType.fingerprint)) {
  //       final bool didAuthenticate = await auth.authenticate(
  //         localizedReason: 'Unlock your screen with PIN, Pattern, password, face, or fingerprint',
  //         options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
  //         authMessages: const <AuthMessages>[
  //           AndroidAuthMessages(
  //               signInTitle: 'Unlock Ideal Group', cancelButton: 'No thanks'),
  //           IOSAuthMessages(cancelButton: 'No thanks')
  //         ],
  //       );
  //       if (didAuthenticate) {
  //         // Navigate to home screen
  //         Navigator.pushReplacementNamed(context, '/home');
  //       } else {
  //         setState(() {
  //           errorMessage = 'Authentication failed. Please try again.';
  //         });
  //       }
  //     } else if (availableBiometrics!.contains(BiometricType.weak) ||
  //         availableBiometrics!.contains(BiometricType.face)) {
  //       final bool didAuthenticate = await auth.authenticate(
  //         localizedReason: 'Unlock your screen with PIN, Pattern, password, face, or fingerprint',
  //         options: const AuthenticationOptions(stickyAuth: true),
  //         authMessages: const <AuthMessages>[
  //           AndroidAuthMessages(
  //               signInTitle: 'Unlock Ideal Group', cancelButton: 'No thanks'),
  //           IOSAuthMessages(cancelButton: 'No thanks')
  //         ],
  //       );
  //       if (didAuthenticate) {
  //         // Navigate to home screen
  //         Navigator.pushReplacementNamed(context, '/home');
  //       } else {
  //         setState(() {
  //           errorMessage = 'Authentication failed. Please try again.';
  //         });
  //       }
  //     }
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       errorMessage = 'An error occurred: $e';
  //     });
  //     print("error: $e");
  //   }
  // }
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
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Authenticate'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
              controller: _pinController,
                decoration: InputDecoration(
                hintText: 'Enter PIN',
               border: OutlineInputBorder(),
                 ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                       onFieldSubmitted: (value) {
                         validatePin();
                       }
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForgotPinActivity()));
                        },
                        child: Text(
                          'पिन विसरलात',
                          style: TextStyle(fontSize: 15.0,color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '|',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(width: 8.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChangePinActivity()));
                        },
                        child: Text(
                          'पिन बदला',
                          style: TextStyle(fontSize: 15.0,color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView( // Wrap with SingleChildScrollView
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(

                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 120.0,
                            height: 120.0,
                            child: ElevatedButton(
                              onPressed: _authenticate,
                              child: Icon(
                                Icons.fingerprint,
                                size: 60.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Touch ID Authentication',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Use your fingerprint to authenticate.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(16.0),
              child: Text(
                'Note: Additional note text here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


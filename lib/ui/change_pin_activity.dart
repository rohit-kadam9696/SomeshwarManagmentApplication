import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SomeshwarManagementApp/splashScreen/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SharedPrefrence/shared_pref.dart';
import '../SharedPrefrence/shared_pref2.dart';
import '../constant/snackbar_apierror.dart';
import '../progress_bar/progress_bar.dart';
import 'authnticate2.dart';
import 'bottom_nav_activity.dart';

class ChangePinActivity extends StatefulWidget {
  // //const ChangePinActivity({super.key });
  // final String imei;
  // final String randomString;
  // final String versionId;
  // final String chitBoyId;

  // ChangePinActivity({
  //   // required this.imei,
  //   // required this.randomString,
  //   // required this.versionId,
  //   // required this.chitBoyId,
  // });

  ChangePinActivity();
  @override
  State<ChangePinActivity> createState() =>
      //_ChangePinActivityState(imei, randomString, versionId, chitBoyId);
  _ChangePinActivityState();
}


class _ChangePinActivityState extends State<ChangePinActivity> {




  TextEditingController newpinController=TextEditingController();
  TextEditingController reenternewpinController=TextEditingController();
  TextEditingController oldpinController=TextEditingController();


  late final String imei;
  late final String randomString;
  late final String versionId;
  late final String chitBoyId;

 // _ChangePinActivityState( this.imei, this.randomString, this.versionId, this.chitBoyId);
  _ChangePinActivityState();
  void initState() {
    super.initState();

    PreferencesHelper.getOldPinFromSharedPreferences().then((oldPin) {
      oldpinController.text = oldPin;
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
  @override
  void dispose(){
    super.dispose();
  }
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
                    margin: EdgeInsets.only(top: 120),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.width * 1.4,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,

                          elevation: 5,
                          margin: EdgeInsets.only(left: 10,right:10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [

                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,

                                        border: Border.all(color: Colors.green,width: 2)
                                    ),
                                    child: ClipOval(child: Lottie.asset('assets/animations/newPin.json',width: 120,height: 120,)
                                    )

                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    'नवीन पिन',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(12),
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
                                    maxLength: 4,
                                    onChanged: (value) =>moveConfirm(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                      labelText: "Enter new pin",
                                      hintText: " पिन पुन्हा टाका.",
                                      border: InputBorder.none, // Remove the default border
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
                                    maxLength: 4,
                                    keyboardType: TextInputType.phone,
                                    controller: reenternewpinController,
                                    onChanged: (value) =>setConfirm(),
                                    decoration: InputDecoration(

                                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 40),
                                      labelText: "Reenter new pin",
                                      hintText: "नवीन पिन पुन्हा टाका.",
                                      border: InputBorder.none, // Remove the default border
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2,),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextButton(
                                    onPressed: () {
                                      String newPin = newpinController.text.trim();
                                      String reenterPin = reenternewpinController.text.trim();

                                      if (newPin.isEmpty || reenterPin.isEmpty) {
                                        String msg = "कृपया आपला नवीन पिन टाका.";
                                        if (newPin.isEmpty) {
                                          SnackbarHelper.showSnackBar2(
                                            context,
                                            msg: msg,
                                            height: 220.0,
                                          );
                                        } else if (reenterPin.isEmpty) {
                                          msg = "कृपया आपला नवीन पिन पुन्हा टाका.";
                                          SnackbarHelper.showSnackBar2(
                                            context,
                                            msg: msg,
                                            height: 220.0,
                                          );
                                        }
                                        return; // Exit onPressed function if any field is empty
                                      }
                                      if (newPin != reenterPin) {
                                        String msg = "कृपया दोन्ही पिन सारखेच टाका.";
                                        SnackbarHelper.showSnackBar2(
                                          context,
                                          msg: msg,
                                          height: 220.0,
                                        );
                                        return; // Exit onPressed function if newPin and reenterPin do not match
                                      }
                                      String successMsg = "आपला पिन सफलतापूर्वक जतन केला गेला आहे.";
                                      SnackbarHelper.showSnackbar(
                                        context,
                                        msg: successMsg,
                                        height: 220.0,
                                      );
                                      performSetPin();
                                      try {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BottomNav(),
                                          ),
                                        );
                                      } catch (e, s) {
                                        print(s);
                                      }
                                    },
                                    child: Text(
                                      'पिन बदला',
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
  void setConfirm() {
    String confirmLoginPin = newpinController.text;
    if (confirmLoginPin.length == 4) {
      performSetPin();
    }
  }
  void moveConfirm() {
    String loginPin = reenternewpinController.text;
    if (loginPin.length == 4) {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Future<void> performSetPin() async {
    //  String oldPin = await SharedPreferencesHelper.getLoginPin();
   // String oldLoginPin = oldpinController.text;
    String loginPin = newpinController.text;
    String confirmLoginPin = reenternewpinController.text;
    // print("oldLoginPin $oldLoginPin");
    print("loginPin $loginPin");
    print("confirmLoginPin $confirmLoginPin");
    if (loginPin.length == 4 && confirmLoginPin.length == 4 && loginPin == confirmLoginPin) {
      await SharedPreferencesHelper.setLoginPin(loginPin);
      String msg="आपला पिन सफलतापूर्वक बदलेला आहे";
      SnackbarHelper.showSnackbar(context,msg: msg,height: 220.0);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>AuthenticateController()));// Store PIN using SharedPreferencesHelper

      // Navigate to the next screen or perform any other actions
    } else {
      // String msg="Error: New PIN and Confirm PIN do not match";
      showToast('Error: New PIN and Confirm PIN do not match');
      // SnackbarHelper.showSnackBar2(context,msg: msg,height: 220.0);
    }
  }
  void showToast(String message) {
    // Implement a toast-like notification
    print(message);
  }
}

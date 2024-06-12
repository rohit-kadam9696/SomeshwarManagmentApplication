import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  // static Future<void> saveChitBoyIdAndRandomStringToPrefs(String? chitBoyId,String ? uniquestring) async {
  //   if (chitBoyId != null && uniquestring != null) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('chitBoyId',chitBoyId);
  //     await prefs.setString('randomString',uniquestring);
  //   } else {
  //     print("chitBoyId OR RandomString become null. Cannot save to SharedPreferences.");
  //   }
  // }
  //
  //
  //
  // static Future<String?> getChitBoyIdFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('chitBoyId');
  //
  // }
  //
  // static Future<String?> getRandomStringFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('uniquestring');
  //
  // }
  // static Future<void> saveMobileNo(String mobileno) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mobileNo', mobileno);
  // }

  static Future<void> storeValuesInSharedPreferences(String chitboyid, String uniqstring,String mobileno,String imei) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('chitboyid', chitboyid);
    prefs.setString('uniqstring', uniqstring);
    prefs.setString('mobileno', mobileno);
    prefs.setString('imei', imei);
  }

  static Future<void> storeValuesInSharedPrefYearCode(String yearCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('yearCode', yearCode);
  }
  static Future<String>getstoreValuesInSharedPrefYearCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('yearCode') ?? 'No yearCode stored';

  }

  static Future<String> getStoredMobileNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobileno') ?? 'null';

  }
  static Future<String> getStoredChitboyid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('chitboyid') ?? 'No chitboyid stored';

  }
  static Future<String> getStoredUniqstring() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uniqstring') ?? 'No uniqstring stored';

  }
  static Future<String> getStoredImei() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('imei') ?? 'No imei stored';

  }
  static Future<void> saveLoginPin(String loginPin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginPin', loginPin);

  }
  // static Future<String> getStoredLoginPin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('user_pin') ?? 'No loginPin stored';
  //
  // }
static  Future<String> getOldPinFromSharedPreferences() async {
    try {
      // Retrieve old PIN from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? oldPin = prefs.getString('loginPin');
      return oldPin ?? ''; // Return empty string if oldPin is null
    } catch (e) {
      print('Error retrieving old PIN: $e');
      return ''; // Return empty string in case of an error
    }
  }
}
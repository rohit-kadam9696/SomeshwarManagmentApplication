import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _UNIQSTRING_KEY = 'flutter.uniqstring';
  static const String _CHITBOYID_KEY = 'flutter.chitboyid';
  static const String _YEARCODE_KEY = 'flutter.yearCode';
  static const String _MOBILENO_KEY = 'flutter.mobileNo';
  static const String _LOGINPIN_KEY = 'flutter.loginPin';
  static const String _IMEI_KEY = 'flutter.imei';

  static Future<void> initializeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_UNIQSTRING_KEY)) {
      prefs.setString(_UNIQSTRING_KEY, 'null');
    }
    if (!prefs.containsKey(_CHITBOYID_KEY)) {
      prefs.setString(_CHITBOYID_KEY, 'null');
    }
    if (!prefs.containsKey(_YEARCODE_KEY)) {
      prefs.setString(_YEARCODE_KEY, 'null');
    }
    if (!prefs.containsKey(_MOBILENO_KEY)) {
      prefs.setString(_MOBILENO_KEY, 'null');
    }
    if (!prefs.containsKey(_LOGINPIN_KEY)) {
      prefs.setString(_LOGINPIN_KEY, 'null');
    }
    if (!prefs.containsKey(_IMEI_KEY)) {
      prefs.setString(_IMEI_KEY, 'null');
    }
  }

  static Future<void> updateUniqString(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_UNIQSTRING_KEY, newValue);
  }

  static Future<void> storeValuesInSharedPref(
      String chitBoyId, String uniqstring, String mobileno, String imei) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_CHITBOYID_KEY, chitBoyId);
    prefs.setString(_UNIQSTRING_KEY, uniqstring);
    prefs.setString(_MOBILENO_KEY, mobileno);
    prefs.setString(_IMEI_KEY, imei);
  }

  static Future<void> updateChitboyId(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_CHITBOYID_KEY, newValue);
  }

  static Future<void> updateYearCode(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_YEARCODE_KEY, newValue);
  }

  static Future<void> updateMobileNo(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_MOBILENO_KEY, newValue);
  }

  static Future<void> setLoginPin(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_LOGINPIN_KEY, newValue);
  }

  static Future<void> updateImei(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_IMEI_KEY, newValue);
  }

  static Future<String> getUniqString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_UNIQSTRING_KEY) ?? 'null';
  }

  static Future<String> getChitboyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_CHITBOYID_KEY) ?? 'null';
  }

  static Future<String> getYearCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_YEARCODE_KEY) ?? 'null';
  }

  static Future<String> getMobileNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_MOBILENO_KEY) ?? 'null';
  }

  static Future<String> getLoginPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_LOGINPIN_KEY) ?? 'null';
  }

  static Future<String> getImei() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_IMEI_KEY) ?? 'null';
  }

  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_UNIQSTRING_KEY);
    prefs.remove(_CHITBOYID_KEY);
    prefs.remove(_YEARCODE_KEY);
    prefs.remove(_MOBILENO_KEY);
    prefs.remove(_LOGINPIN_KEY);
    prefs.remove(_IMEI_KEY);
  }
}

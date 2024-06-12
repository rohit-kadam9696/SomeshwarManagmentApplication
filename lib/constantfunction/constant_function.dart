
import 'package:shared_preferences/shared_preferences.dart';

class ConstantFunction{

  Future<List<String>> putSharedPrefValue(List<String> keyArray, List<String> valueArray) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int size = keyArray.length;
    for (int k = 0; k < size; k++) {
      prefs.setString(keyArray[k], valueArray[k]);
    }
    // After updating shared preferences, return the updated values
    List<String> updatedValues = List<String>.generate(size, (index) {
      return prefs.getString(keyArray[index]) ?? valueArray[index];
    });

    return updatedValues;
  }
  Future<void> removeSharedPrefValue(List<String> removalKeys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String key in removalKeys) {
      prefs.remove(key);
    }
  }

  Future<List<String>> getSharedPrefValue(List<String> keyArray, List<String> defaultArray) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int size = keyArray.length;
    List<String> valueArray = List<String>.generate(size, (index) {
      return prefs.getString(keyArray[index]) ?? defaultArray[index];
    });
    return valueArray;
  }
  Future<void> clearAllSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}
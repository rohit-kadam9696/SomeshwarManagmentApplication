

import 'package:package_info_plus/package_info_plus.dart';
class AppInfo {
  static Future<String> getVersionId() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
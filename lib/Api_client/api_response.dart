// import 'dart:convert' as convert;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// class APIClient {
//   static const Map<int, String> serverOptions = {
//     1: "http://ssssk1.3wdsoft.com:8082/FlutterMIS/",
//     // 2: "http://ssssk2.3wdsoft.com:8080/SomeshwarInternalWebSevices/",
//     // 3: "http://ssssk1.3wdsoft.com:8081/SomeshwarInternalWebSevices/",
//     // 4: "http://ssssk2.3wdsoft.com:8081/SomeshwarInternalWebSevices/",
//     // 5: "http://172.168.0.21:8080/SomeshwarInternalWebSevices/",
//     // 6: "http://192.168.0.21:8080/SomeshwarInternalWebSevices/",
//
//     //live url
//     2: "http://117.205.2.18:8082/FlutterMIS/app_login",
//     // 8: "http://192.168.0.21:8081/SomeshwarInternalWebSevices/",
//   };
//
//   static const Map<int, String> serverNames = {
//     1: "Debug Server",
//     // 2: "Debug Server 1",
//     // 3: "Debug Server 2",
//     // 4: "BSNL",
//     // 5: "Wi-Fi 1 (172)",
//     // 6: "Wi-Fi 2 (192)",
//     // 7: "Wi-Fi Debug 1 (172)",
//     // 8: "Wi-Fi Debug 2 (192)",
//
//   };
//
//   static const String defaultBaseUrl = "http://ssssk1.3wdsoft.com:8080/SomeshwarInternalWebSevices/";
//
//   static Future<String> getCurrentBaseUrl() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int selectedOption = prefs.getInt('selectedOption') ?? 1;
//     return serverOptions[selectedOption] ?? defaultBaseUrl;
//   }
//
//   static Future<void> saveSelectedOption(int option) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('selectedOption', option);
//   }
//
//   // static Future<void> doLogin(String mobileno, String imei, String randomString, String versionId, String chitBoyId) async {
//   //   String baseUrl = await getCurrentBaseUrl();
//   //   String uri = baseUrl + "app_login";
//   //
//   //   Map<String, dynamic> requestBody = {
//   //     'action': "Login",
//   //     'mobileno': mobileno,
//   //     'imei': imei,
//   //     'randomString': randomString,
//   //     'versionId': versionId,
//   //     'chitBoyId': chitBoyId,
//   //   };
//   //
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse(uri),
//   //       body: jsonEncode(requestBody),
//   //       headers: {'Content-Type': 'application/json'},
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       var jsonResponse = jsonDecode(response.body);
//   //       // Handle the response data accordingly
//   //     } else {
//   //       // Handle errors or other status codes
//   //       print('Error: ${response.statusCode}');
//   //     }
//   //   } catch (error) {
//   //     print('Error: $error');
//   //   }
//   // }
// }
//
//
class ApiResponse {
  static List<Map<String, String>> factoryConfigurations = [
    {'hostname': 'ssssk1.3wdsoft.com', 'port': '8080'}, // Factory 1 configuration
    {'hostname': 'ssssk2.3wdsoft.com', 'port': '8080'}, // Factory 2 configuration
    {'hostname': 'ssssk1.3wdsoft.com', 'port': '8081'}, // Factory 1 debug configuration
    {'hostname': 'ssssk2.3wdsoft.com', 'port': '8081'}, // Factory 2 debug configuration
    {'hostname': '117.205.2.18', 'port': '8082'}, // Factory 3 configuration
    // Add more configurations as needed
  ];

  static String determineBaseUrl(String sugarFactoryId) {
    int index = int.parse(sugarFactoryId) - 1; // Adjust index to match sugarFactoryId

    for (int i = index; i < factoryConfigurations.length; i++) {
      String hostname = factoryConfigurations[i]['hostname']!;
      String port = factoryConfigurations[i]['port']!;

      // Check if the URL is working
      if (isUrlWorking(hostname, port)) {
        return "http://$hostname:$port/FlutterMIS";
      }
    }

    // Return a default URL or handle the case when no working URL is found
    return "http://default-url.com";
  }

  static bool isUrlWorking(String hostname, String port) {
    // Implement logic to check if the URL is working
    // You can use HTTP requests to verify the URL's availability
    // For simplicity, let's assume all URLs are working for now
    return true;
  }
}

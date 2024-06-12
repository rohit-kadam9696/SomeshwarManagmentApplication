
import 'package:SomeshwarManagementApp/splashScreen/splash_screen.dart';
import 'package:SomeshwarManagementApp/ui/authnticate2.dart';
import 'package:SomeshwarManagementApp/ui/bottom_nav_activity.dart';
import 'package:SomeshwarManagementApp/ui/cha_us_nond.dart';
import 'package:SomeshwarManagementApp/ui/change_pin_activity.dart';
import 'package:SomeshwarManagementApp/ui/home_page.dart';
import 'package:SomeshwarManagementApp/ui/punar_us_nond.dart';
import 'package:SomeshwarManagementApp/ui/us_galap_activity.dart';
import 'package:SomeshwarManagementApp/ui/vikrisath_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _checkLoginFuture=Future.value();
  bool _loggedIn = false;
  String ? pin;

  @override
  void initState() {
    super.initState();
    _checkLoginFuture = _checkLoggedInStatus();
  }
  Future<void> _checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNo = prefs.getString('flutter.mobileNo');
    String? pin = prefs.getString('flutter.loginPin');
    if (mobileNo != null && mobileNo.isNotEmpty) {
      setState(() {
        _loggedIn = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _checkLoginFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _loggedIn ? SplashScreen() : HomePage();
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.blue,)));
          }
        },
      ),
      routes: {
         '/usgalapPage': (context) => UsGalapPage(),
        '/auth': (context) => _loggedIn ? SplashScreen() : HomePage(),
        '/home': (context) => HomePage(),
        '/loginPin': (context) => ChangePinActivity(),
        '/chaUsNond': (context) => ChaUsNodPage(),
        '/vikriSatha': (context) => VikriSathaPage(),
        '/puUsNond': (context) => PunarUsNodPage(),

       // '/changePin': (context) => _loggedIn && (pin == null || pin!.isEmpty) ? ChangePinActivity() : AuthenticateController(),
      },
    );
  }
}

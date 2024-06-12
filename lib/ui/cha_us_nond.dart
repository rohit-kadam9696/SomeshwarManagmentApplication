import 'package:SomeshwarManagementApp/ui/production_page.dart';
import 'package:SomeshwarManagementApp/ui/punar_us_nond.dart';
import 'package:SomeshwarManagementApp/ui/us_galap_activity.dart';
import 'package:SomeshwarManagementApp/ui/vikrisath_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SomeshwarManagementApp/Widgets/chalu_us_nond.dart';
import 'package:flutter/services.dart';
class ChaUsNodPage extends StatefulWidget {
  const ChaUsNodPage({super.key});

  @override
  State<ChaUsNodPage> createState() => _ChaUsNodPageState();
}

class _ChaUsNodPageState extends State<ChaUsNodPage> {
  static Color currentSection = const Color(0x626262);
  static Color aBackground = const Color(0xE5E5E5);
  static Color aSidebar = const Color(0x7C01FF);
  static Color aSoundButton = const Color(0xA93EF0);
  static Color aSoundLockedButton = const Color(0x555555);
  static Color lightRed = const Color(0xFFFFCDD2);
  static Color darkyellow = const Color(0xFFF5E54F);
  static Color smallyellow = const Color(0xFFFFF176);
  static Color verysmallyellow = const Color(0xFFFFF59D);
  //static const Color brownColor = Color(0xFF8B4513);

  Color bottomNavBarColor = brownColor;
   static Color darkgreen = const Color(0xFF4CAF50);
  static const Color brownColor = Color(0xFFB08401);
  static const Color darkRed = Color(0xFFF44236);
  static const Color darkBlue = Color(0xFF008596);
  static const Color darkBlue1 = Color(0xFF2196F3);


  List<Widget> _screens = [
    UsGalapPage(),
    ChaUsNodPage(),
    PunarUsNodPage(),
    VikriSathaPage(),
    ProductionPage(),
  ];
  int _selectedIndex = 0;


  void _onItemTapped(int selectedIndex) {
    if (selectedIndex < _screens.length) {
      setState(() {
        _selectedIndex = selectedIndex;
      });

      // Update color based on the selected index
      switch (selectedIndex) {
        case 0:
          updateNavBarColor(darkgreen);
          setState(() {
            bottomNavBarColor = darkgreen;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UsGalapPage()),
          );
          break;

        case 1:
          updateNavBarColor(brownColor);
          setState(() {
            bottomNavBarColor = brownColor;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChaUsNodPage()),
          );
          break;

        case 2:
          updateNavBarColor(darkBlue);
          setState(() {
            bottomNavBarColor = darkBlue;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PunarUsNodPage()),
          );
          break;
        case 3:
          updateNavBarColor(darkRed);
          setState(() {
            bottomNavBarColor = darkRed;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VikriSathaPage()),
          );
          break;
        case 4:
          updateNavBarColor(darkBlue1);
          setState(() {
            bottomNavBarColor = darkBlue1;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductionPage()),
          );
          break;

        default:
        // Default case
          setState(() {
            bottomNavBarColor = darkgreen;
          });
      }
    }
  }

  void updateNavBarColor(Color color) {
    setState(() {
      bottomNavBarColor = color;
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
    Widget build(BuildContext context) {
      return WillPopScope(

        onWillPop:_onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                ChaluUsNondWidget(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 65,
            margin: EdgeInsets.all(5),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: bottomNavBarColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,

              selectedFontSize: 15,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dataset_sharp,
                    color: _selectedIndex == 0 ? Colors.white : Colors.white,
                  ),
                  label: 'ऊस गाळप',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dataset_sharp,
                    color: _selectedIndex == 1 ? Colors.white : Colors.white,
                  ),
                  label: 'चा. ऊस नोंद',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dataset_sharp,
                    color: _selectedIndex == 2 ? Colors.white : Colors.white,
                  ),
                  label: 'पु. ऊस नोंद',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dataset_sharp,
                    color: _selectedIndex == 3 ? Colors.white : Colors.white,
                  ),
                  label: 'विक्री / साठा',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dataset_sharp,
                    color: _selectedIndex == 4 ? Colors.white : Colors.white,
                  ),
                  label: 'उत्पादन',
                ),
              ],
            ),
          ) ,
        ),
      );
    }


  }

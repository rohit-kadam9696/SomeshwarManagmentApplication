import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/production_page.dart';
import 'cha_us_nond.dart';
import 'punar_us_nond.dart';
import 'us_galap_activity.dart';
import 'vikrisath_page.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({Key? key}) : super(key: key);

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  static const Color darkRed = Color(0xFFF44236);
  static const Color smallRed = Color(0xFFFA8E8E);
  static const Color verysmallRed = Color(0xFFFFCDD2);
  static const Color darkgreen = Color(0xFF4CAF50);
  static const Color brownColor = Color(0xFFB08401);
  static const Color darkBlue = Color(0xFF008596);
  static const Color darkBlue1 = Color(0xFF2196F3);

  Color bottomNavBarColor = darkBlue1;
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
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              ProductionWidget(),
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
            currentIndex: _selectedIndex,
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
        ),
      ),
    );
  }
}

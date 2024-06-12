import 'package:SomeshwarManagementApp/ui/production_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SomeshwarManagementApp/ui/punar_us_nond.dart';
import 'package:SomeshwarManagementApp/ui/us_galap_activity.dart';
import 'package:SomeshwarManagementApp/ui/vikrisath_page.dart';

import 'cha_us_nond.dart';

class BottomNav extends StatefulWidget {
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  static Color darkgreen = const Color(0xFF4CAF50);
  static const Color brownColor = Color(0xFFB08401);
  static const Color darkRed = Color(0xFFF44236);
  static const Color darkBlue = Color(0xFF008596);
  static const Color darkBlue1 = Color(0xFF2196F3);


  PageController _pageController = PageController();
  List<Widget> _screens = [
    UsGalapPage(),
    ChaUsNodPage(),
    PunarUsNodPage(),
    VikriSathaPage(),
    ProductionPage(),
  ];
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    if (selectedIndex < _screens.length) {
      _pageController.jumpToPage(selectedIndex);
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
          break;

        case 1:
          updateNavBarColor(brownColor);
          setState(() {
            bottomNavBarColor = brownColor;
          });
          break;

        case 2:
          updateNavBarColor(darkBlue);
          setState(() {
            bottomNavBarColor = darkBlue;
          });
          break;
        case 3:
          updateNavBarColor(darkRed);
          setState(() {
            bottomNavBarColor =darkRed;
          });
          break;
        case 4:
          updateNavBarColor(darkBlue1);
          setState(() {
            bottomNavBarColor =darkBlue1;
          });
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

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Color bottomNavBarColor = darkgreen; // Initial color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
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
      ),
    );
  }
}

// class BottomNav extends StatefulWidget {
//   @override
//   State<BottomNav> createState() => _BottomNavState();
// }
//
// class _BottomNavState extends State<BottomNav> {
//   static Color darkgreen = const Color(0xFF4CAF50);
//   static const Color brownColor = Color(0xFFB08401);
//   static const Color darkRed = Color(0xFFF44236);
//   static const Color darkBlue = Color(0xFF008596);
//
//   PageController _pageController = PageController();
//   int _selectedIndex = 0;
//
//   void _onPageChanged(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   void _onItemTapped(int selectedIndex) {
//     _pageController.jumpToPage(selectedIndex);
//     setState(() {
//       _selectedIndex = selectedIndex;
//     });
//
//     // Navigate to UsGalapPage with selected index
//     Navigator.of(context).pop();
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsGalapPage(selectedIndex: selectedIndex)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: [
//           UsGalapPage(),
//           ChaUsNodPage(),
//           PunarUsNodPage(),
//           VikriSathaPage(),
//         ],
//         onPageChanged: _onPageChanged,
//         physics: const NeverScrollableScrollPhysics(),
//       ),
//       bottomNavigationBar: Container(
//         height: 65,
//         margin: EdgeInsets.all(5),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.black,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.white,
//           selectedFontSize: 15,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dataset_sharp),
//               label: 'ऊस गाळप',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dataset_sharp),
//               label: 'चा. ऊस नोंद',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dataset_sharp),
//               label: 'पु. ऊस नोंद',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dataset_sharp),
//               label: 'विक्री / साठा',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


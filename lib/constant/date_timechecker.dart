import 'package:flutter/material.dart'; // Adjust the import based on your project structure



import 'package:intl/intl.dart';

class DateTimeChecker {
  bool checkAutoDate(BuildContext context, bool openWarning) {
    int autoTime = DateTime.now().isUtc ? 1 : 0;
    if (autoTime != 1) {
      if (openWarning) {
        // Adjust the next line based on your project structure
        Navigator.push(context, MaterialPageRoute(builder: (context) => WrongTimeActivity(type: "1")));
      }
      return false;
    }
    return true;
  }

  bool checkServerDate(BuildContext context, bool openWarning, String serverDate) {
    DateFormat sdf = DateFormat("dd/MM/yyyy HH:mm:ss");
    DateTime calToday = DateTime.now();
    DateTime cal;
    try {
      cal = sdf.parse(serverDate);
      cal = cal.subtract(Duration(minutes: 15));
    } catch (e) {
      print(e.toString());
      return false;
    }
    if (cal.isAfter(calToday)) {
      if (openWarning) {
        // Adjust the next line based on your project structure
        Navigator.push(context, MaterialPageRoute(builder: (context) => WrongTimeActivity(date: serverDate, type: "2")));
      }
      return false;
    }
    return true;
  }
}

class WrongTimeActivity extends StatelessWidget {
  final String? type;
  final String? date;

  WrongTimeActivity({Key? key, this.type, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for WrongTimeActivity
    return Scaffold(
      appBar: AppBar(
        title: Text('Wrong Time'),
      ),
      body: Center(
        child: Text('Type: $type, Date: $date'),
      ),
    );
  }
}

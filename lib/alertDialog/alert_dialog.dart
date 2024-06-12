import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertDialogUtils {
  static void showAlertWithTwoButtons({
    required BuildContext context,
    required String message,
    required VoidCallback onOkPressed,
    required VoidCallback onCancelPressed,
    String okButtonText = 'YES',
    String cancelButtonText = 'NO',
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blue, width: 4.0), // Border color and width
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Alert...',
                style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Lottie.asset(
                'assets/animations/alertdialog.json',
                width: 150, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
              SizedBox(width: 10), // Adjust spacing as needed

            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: onCancelPressed,
              child: Text(cancelButtonText, style: TextStyle(fontSize: 15, color: Colors.blue)),
            ),
            TextButton(
              onPressed: onOkPressed,
              child: Text(okButtonText, style: TextStyle(fontSize: 15, color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}

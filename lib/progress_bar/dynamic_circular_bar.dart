import 'dart:math';

import 'package:flutter/material.dart';

class DynamicCircularProgress extends StatefulWidget {
  @override
  _DynamicCircularProgressState createState() => _DynamicCircularProgressState();
}

class _DynamicCircularProgressState extends State<DynamicCircularProgress> {
  Color progressColor = Colors.blue; // Initial color of the progress bar

  // Function to simulate server request
  void makeRequest() {
    // Simulating server request
    setState(() {
      // Change the progress color randomly
      progressColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    });

    // Simulating delay
    Future.delayed(Duration(seconds: 2), () {
      // Do something after delay (e.g., perform actions after server response)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(progressColor), // Dynamic progress color
              strokeWidth: 10.0,
              backgroundColor: Colors.grey[300],
            ),
            ElevatedButton(
              onPressed: makeRequest,
              child: Text('Hit Server'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Dynamic Circular Progress Example')),
      body: DynamicCircularProgress(),
    ),
  ));
}

import 'package:flutter/cupertino.dart';

import '../pojo/crushing_report.dart';

class ApiState extends StatefulWidget {
  @override
  _ApiStateState createState() => _ApiStateState();
}

class _ApiStateState extends State<ApiState> {
  CrushingReport? _crushingReport;

  

  void _updateState(CrushingReport? updatedReport) {
    setState(() {
      _crushingReport = updatedReport;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}
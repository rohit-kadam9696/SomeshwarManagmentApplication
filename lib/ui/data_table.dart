// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Import for date formatting
// import '../pojo/variety_hangam_cane_chalu_response.dart';
//
// class DataTableScreen extends StatefulWidget {
//   final VarietyHangamCaneResponse vhResponse;
//   final double value1Total;
//   final double value2Total;
//   final double value3Total;
//   final double value4Total;
//   final double value5Total;
//
//   final GatHangamCurrentCaneResponse ghResponse; // Second table data
//   final double ghValue1Total;
//   final double ghValue2Total;
//   final double ghValue3Total;
//   final double ghValue4Total;
//   final double ghValue5Total;
//
//   DataTableScreen({
//     required this.vhResponse,
//     required this.value1Total,
//     required this.value2Total,
//     required this.value3Total,
//     required this.value4Total,
//     required this.value5Total,
//     required this.ghResponse, // Second table data
//     required this.ghValue1Total,
//     required this.ghValue2Total,
//     required this.ghValue3Total,
//     required this.ghValue4Total,
//     required this.ghValue5Total,
//   });
//
//   @override
//   _DataTableScreenState createState() => _DataTableScreenState();
// }
//
// class _DataTableScreenState extends State<DataTableScreen> {
//   late DateTime selectedDate = DateTime.now();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2015, 8),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Table'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.date_range),
//             onPressed: () => _selectDate(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Column(
//           children: [
//             // First Table
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.black,
//                   width: 2.0,
//                 ),
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
//                 columns: [
//                   DataColumn(
//                     label: Text(
//                       'व्हरायटी',
//                       style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'अडसाली',
//                       style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'पु. हंगाम',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'चा.हंगाम',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'खोडवा',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'एकूण',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: [
//                   ...widget.vhResponse.varietyHangamCaneBeanMap.entries.map<DataRow>((entry) {
//                     String resourceName = entry.key;
//                     VarietyHangamCaneData vhData = entry.value;
//                     return DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             resourceName,
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             vhData.value1.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               vhData.value2.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               vhData.value3.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               vhData.value4.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               vhData.value5.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                   DataRow(
//                     cells: [
//                       DataCell(
//                         Text(
//                           'एकूण',
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       DataCell(
//                         Text(
//                           widget.value1Total.toStringAsFixed(2),
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Text(
//                             widget.value2Total.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Text(
//                           widget.value3Total.toStringAsFixed(2),
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Text(
//                             widget.value4Total.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Text(
//                             widget.value5Total.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20), // Spacer between tables
//             // Second Table
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.black,
//                   width: 2.0,
//                 ),
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith((states) => smallyellow),
//                 columns: [
//                   DataColumn(
//                     label: Text(
//                       'गट',
//                       style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Text(
//                       'अडसाली',
//                       style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'पु. हंगाम',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'चा.हंगाम',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'खोडवा',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Text(
//                         'एकूण',
//                         style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: [
//                   ...widget.ghResponse.gatHangamCaneBeanMap.entries.map<DataRow>((entry) {
//                     String resourceName = entry.key;
//                     GatHangamCaneData ghData = entry.value;
//                     return DataRow(
//                       cells: [
//                         DataCell(
//                           Text(
//                             resourceName,
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         DataCell(
//                           Text(
//                             ghData.value1.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               ghData.value2.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               ghData.value3.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               ghData.value4.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                         DataCell(
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15.0),
//                             child: Text(
//                               ghData.value5.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                   DataRow(
//                     cells: [
//                       DataCell(
//                         Text(
//                           'एकूण',
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       DataCell(
//                         Text(
//                           widget.ghValue1Total.toStringAsFixed(2),
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Text(
//                             widget.ghValue2Total.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Text(
//                           widget.ghValue3Total.toStringAsFixed(2),
//                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Text(
//                             widget.ghValue4Total.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 15.0),
//                           child: Text(
//                             widget.ghValue5Total.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

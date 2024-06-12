import 'package:SomeshwarManagementApp/pojo/server_error.dart';

import 'app_update.dart';
import 'main_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'crushing_report.g.dart';
@JsonSerializable()
class CrushingReport extends MainResponse {
  late double ? todayCrushing;
  late double ? uptoTodayCrushing;

  double? getTodayCrushing() {
    return todayCrushing;
  }

  void setTodayCrushing(double todayCrushing) {
    this.todayCrushing = todayCrushing;
  }

  double? getUptoTodayCrushing() {
    return uptoTodayCrushing;
  }

  void setUptoTodayCrushing(double uptoTodayCrushing) {
    this.uptoTodayCrushing = uptoTodayCrushing;
  }

  factory CrushingReport.fromjson(Map<String,dynamic> json)=>_$CrushingReportFromJson(json);
  Map<String,dynamic> toJson()=>_$CrushingReportToJson(this);
  CrushingReport({this.todayCrushing,  this.uptoTodayCrushing});

  factory CrushingReport.fromJson(Map<String, dynamic> json) {
    return CrushingReport(
      todayCrushing: json['todayCrushing'] as double?,
      uptoTodayCrushing:json['uptoTodayCrushing'] as double?,

    );
  }
// You can add any additional methods or constructors as needed
}
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CrushingResponse {
   double todayCrushing;
  double uptoTodayCrushing;

  CrushingResponse({
    this.todayCrushing = 0.0,
    this.uptoTodayCrushing = 0.0,
  }); // Closing the constructor with a semicolon

  // Named constructor for deserialization
  factory CrushingResponse.fromJson(Map<String, dynamic> json) {
    return CrushingResponse(
      todayCrushing: json['todayCrushing'].toDouble(),
      uptoTodayCrushing: json['uptoTodayCrushing'].toDouble(),
    );
  }

  // Map to convert object to JSON
  Map<String, dynamic> toJson() => {
    'todayCrushing': todayCrushing,
    'uptoTodayCrushing': uptoTodayCrushing,
  };
}

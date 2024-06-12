class ShiftCrushingResponse {
  final int nsugTypeId;
  final int nlocationId;
  final Map<String, ShiftCrushingData> shiftWiseCrushingBeanMap;
  final bool success;
  final bool update;

  ShiftCrushingResponse({
    required this.nsugTypeId,
    required this.nlocationId,
    required this.shiftWiseCrushingBeanMap,
    required this.success,
    required this.update,
  });

  factory ShiftCrushingResponse.fromJson(Map<String, dynamic> json) {
    var shiftWiseCrushingBeanMap = <String, ShiftCrushingData>{};

    if (json.containsKey('shiftWiseCrushingBeanMap')) {
      if (json['shiftWiseCrushingBeanMap'] != null) {
        json['shiftWiseCrushingBeanMap'].forEach((key, value) {
          shiftWiseCrushingBeanMap[key] = ShiftCrushingData.fromJson(value);
        });
      }
    }

    return ShiftCrushingResponse(
      nsugTypeId: json['nsugTypeId'] ?? 0,
      nlocationId: json['nlocationId'] ?? 0,
      shiftWiseCrushingBeanMap: shiftWiseCrushingBeanMap,
      success: json['success'] ?? false,
      update: json['update'] ?? false,
    );
  }
}
class ShiftCrushingData {
  final num shiftTodayCrushing;
  final num shiftYeastrdayCrushing;
  final String shiftNo;

  ShiftCrushingData({
    required this.shiftTodayCrushing,
    required this.shiftYeastrdayCrushing,
    required this.shiftNo,
  });

  factory ShiftCrushingData.fromJson(Map<String, dynamic> json) {
    return ShiftCrushingData(
      shiftTodayCrushing: json['shiftTodayCrushing'] ?? 0,
      shiftYeastrdayCrushing: json['shiftYeastrdayCrushing'] ?? 0,
      shiftNo: json['shiftNo'] ?? '',
    );
  }
}

class VarietyWiseCrushingResponse {
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;
  final Map<String, VarietyWiseCrushingData> varietyWiseCrushingBeanMap;

  VarietyWiseCrushingResponse({
    required this.varietyWiseCrushingBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.update,
    required this.success,
  });

  factory VarietyWiseCrushingResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('varietyWiseCrushingBeanMap')) {
        var varietyWiseCrushingBeanMapJson = json['varietyWiseCrushingBeanMap'];
        if (varietyWiseCrushingBeanMapJson is Map<String, dynamic>) {
          var varietyCrushingBeanMap = varietyWiseCrushingBeanMapJson.map(
                (key, value) => MapEntry(key, VarietyWiseCrushingData.fromJson(value)),
          );

          return VarietyWiseCrushingResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            varietyWiseCrushingBeanMap: varietyCrushingBeanMap,
            success: json['success'],
            update: json['update'],
          );
        }
      }
    } catch (e) {
      // Handle any potential errors during deserialization
      print('Error: $e');
    }

    // Return a default instance if the JSON is not valid
    return VarietyWiseCrushingResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      varietyWiseCrushingBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class VarietyWiseCrushingData {
  late final String varietyName;
  late final num todayCrushingWt;
  late final num uptoTodayCrushingWt; // Corrected method name

  VarietyWiseCrushingData({
    required this.varietyName,
    required this.todayCrushingWt,
    required this.uptoTodayCrushingWt,
  });

  factory VarietyWiseCrushingData.fromJson(Map<String, dynamic> json) {
    return VarietyWiseCrushingData(
      varietyName: json['varietyName'],
      todayCrushingWt: json['todayCrushingWt'],
      uptoTodayCrushingWt: json['uptoTodayCrushingWt'],
    );
  }
}

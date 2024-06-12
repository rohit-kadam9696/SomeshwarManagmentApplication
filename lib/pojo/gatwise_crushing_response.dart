class GatWiseCrushingResponse {
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;
  final Map<String, GatWiseCrushingData> gatWiseTypeCrushingBeanMap;

  GatWiseCrushingResponse({
    required this.gatWiseTypeCrushingBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.update,
    required this.success,
  });

  factory GatWiseCrushingResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('gatWiseCrushingBeanMap')) {
        var gatWiseCrushingBeanMapJson = json['gatWiseCrushingBeanMap'];
        if (gatWiseCrushingBeanMapJson is Map<String, dynamic>) {
          var gatWiseCrushingBeanMap = gatWiseCrushingBeanMapJson.map(
                (key, value) => MapEntry(key, GatWiseCrushingData.fromJson(value)),
          );

          return GatWiseCrushingResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            gatWiseTypeCrushingBeanMap: gatWiseCrushingBeanMap,
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
    return GatWiseCrushingResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      gatWiseTypeCrushingBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class GatWiseCrushingData {
  late final String department;
  late final num todayCrushing;
  late final num uptoTodayCrushingngWt;

  GatWiseCrushingData({
    required this.department,
    required this.todayCrushing,
    required this.uptoTodayCrushingngWt,
  });

  factory GatWiseCrushingData.fromJson(Map<String, dynamic> json) {
    return GatWiseCrushingData(
      department: json['department'],
      todayCrushing: json['todayCrushing'],
      uptoTodayCrushingngWt: json['uptoTodayCrushingngWt'],
    );
  }
}





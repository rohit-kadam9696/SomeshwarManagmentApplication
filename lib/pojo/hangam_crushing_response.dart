class HangamWiseCrushingResponse {
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;
  final Map<String, HangamCrushingData> hangamCrushingBeanMap;

  HangamWiseCrushingResponse({
    required this.hangamCrushingBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.update,
    required this.success,
  });

  factory HangamWiseCrushingResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('hangamWiseCrushingBeanMap')) {
        var hangamWiseCrushingBeanMapJson = json['hangamWiseCrushingBeanMap'];
        if (hangamWiseCrushingBeanMapJson is Map<String, dynamic>) {
          var hangamCrushingBeanMap = hangamWiseCrushingBeanMapJson.map(
                (key, value) => MapEntry(key, HangamCrushingData.fromJson(value)),
          );

          return HangamWiseCrushingResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            hangamCrushingBeanMap: hangamCrushingBeanMap,
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
    return HangamWiseCrushingResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      hangamCrushingBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class HangamCrushingData {
  late final String hangam;
  late final num todayCrushing;
  late final num uptoTodayCrushingngWt1;

  HangamCrushingData({
    required this.hangam,
    required this.todayCrushing,
    required this.uptoTodayCrushingngWt1,
  });

  factory HangamCrushingData.fromJson(Map<String, dynamic> json) {
    return HangamCrushingData(
      hangam: json['hangam'],
      todayCrushing: json['todayCrushing'],
      uptoTodayCrushingngWt1: json['uptoTodayCrushingngWt1'],
    );
  }
}

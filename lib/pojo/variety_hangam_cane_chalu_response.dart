class VarietyHangamCaneResponse {
  Map<String, VarietyHangamCaneData> varietyHangamCaneBeanMap;

  VarietyHangamCaneResponse({
    required this.varietyHangamCaneBeanMap,
    required int nsugTypeId,
    required int nlocationId,
    required bool success,
    required bool update,
  });

  factory VarietyHangamCaneResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('varietyHangamCaneBeanMap')) {
        var varietyHangamCaneBeanMapJson = json['varietyHangamCaneBeanMap'];
        if (varietyHangamCaneBeanMapJson is Map<String, dynamic>) {
          var varietyHangamCaneBeanMap = varietyHangamCaneBeanMapJson.map(
                (key, value) => MapEntry(key, VarietyHangamCaneData.fromJson(value)),
          );
          return VarietyHangamCaneResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            varietyHangamCaneBeanMap: varietyHangamCaneBeanMap,
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
    return VarietyHangamCaneResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      varietyHangamCaneBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class VarietyHangamCaneData {
  double value1;
  double value2;
  double value3;
  double value4;
  double value5;
  String resourceName;

  VarietyHangamCaneData({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.resourceName,
  });

  factory VarietyHangamCaneData.fromJson(Map<String, dynamic> json) {
    return VarietyHangamCaneData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      value3: (json['value3'] as num).toDouble(),
      value4: (json['value4'] as num).toDouble(),
      value5: (json['value5'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

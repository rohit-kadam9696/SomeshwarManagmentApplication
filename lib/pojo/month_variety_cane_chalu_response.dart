class MonthVarietyCurrentCaneResponse {
  Map<String, MonthVarietyCurrentData> monthVarietyCaneBeanMap;
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;

  MonthVarietyCurrentCaneResponse({
    required this.monthVarietyCaneBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory MonthVarietyCurrentCaneResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('monthVarietyCaneBeanMap')) {
        var monthVarietyCaneBeanMapJson = json['monthVarietyCaneBeanMap'];
        if (monthVarietyCaneBeanMapJson is Map<String, dynamic>) {
          var monthVarietyCaneBeanMap = monthVarietyCaneBeanMapJson.map(
                (key, value) => MapEntry(key, MonthVarietyCurrentData.fromJson(value)),
          );
          return MonthVarietyCurrentCaneResponse(
            monthVarietyCaneBeanMap: monthVarietyCaneBeanMap,
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
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
    return MonthVarietyCurrentCaneResponse(
      monthVarietyCaneBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class MonthVarietyCurrentData {
  double value1;
  double value2;
  double value3;
  double value4;
  double value5;
  String resourceName;

  MonthVarietyCurrentData({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.resourceName,
  });

  factory MonthVarietyCurrentData.fromJson(Map<String, dynamic> json) {
    return MonthVarietyCurrentData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      value3: (json['value3'] as num).toDouble(),
      value4: (json['value4'] as num).toDouble(),
      value5: (json['value5'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

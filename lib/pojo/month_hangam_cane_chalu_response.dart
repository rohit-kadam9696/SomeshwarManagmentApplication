class MonthHangamCurrentCaneResponse {
  Map<String, MonthHangamCurrentData> monthHangamCaneBeanMap;
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;

  MonthHangamCurrentCaneResponse({
    required this.monthHangamCaneBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory MonthHangamCurrentCaneResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('monthHangamCaneBeanMap')) {
        var monthHangamCaneBeanMapJson = json['monthHangamCaneBeanMap'];
        if (monthHangamCaneBeanMapJson is Map<String, dynamic>) {
          var monthHangamCaneBeanMap = monthHangamCaneBeanMapJson.map(
                (key, value) => MapEntry(key, MonthHangamCurrentData.fromJson(value)),
          );
          return MonthHangamCurrentCaneResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            monthHangamCaneBeanMap: monthHangamCaneBeanMap,
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
    return MonthHangamCurrentCaneResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      monthHangamCaneBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class MonthHangamCurrentData {
  double value1;
  double value2;
  double value3;
  double value4;
  double value5;
  String resourceName;

  MonthHangamCurrentData({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.resourceName,
  });

  factory MonthHangamCurrentData.fromJson(Map<String, dynamic> json) {
    return MonthHangamCurrentData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      value3: (json['value3'] as num).toDouble(),
      value4: (json['value4'] as num).toDouble(),
      value5: (json['value5'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

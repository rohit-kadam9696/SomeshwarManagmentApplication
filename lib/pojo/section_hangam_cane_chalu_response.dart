class GatHangamCurrentCaneResponse {
  Map<String, GatHangamCaneData> gatHangamCaneBeanMap;
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;

  GatHangamCurrentCaneResponse({
    required this.gatHangamCaneBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory GatHangamCurrentCaneResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('gatHangamCaneBeanMap')) {
        var gatHangamCaneBeanMapJson = json['gatHangamCaneBeanMap'];
        if (gatHangamCaneBeanMapJson is Map<String, dynamic>) {
          var gatHangamCaneBeanMap = gatHangamCaneBeanMapJson.map(
                (key, value) => MapEntry(key, GatHangamCaneData.fromJson(value)),
          );
          return GatHangamCurrentCaneResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            gatHangamCaneBeanMap: gatHangamCaneBeanMap,
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
    return GatHangamCurrentCaneResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      gatHangamCaneBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class GatHangamCaneData {
  double value1;
  double value2;
  double value3;
  double value4;
  double value5;
  String resourceName;

  GatHangamCaneData({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.resourceName,
  });

  factory GatHangamCaneData.fromJson(Map<String, dynamic> json) {
    return GatHangamCaneData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      value3: (json['value3'] as num).toDouble(),
      value4: (json['value4'] as num).toDouble(),
      value5: (json['value5'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

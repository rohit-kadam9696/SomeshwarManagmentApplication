class PowerProductionResponse {
  final Map<String, PowerProductionData> powerProductionSugarBeanMap;
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;

  PowerProductionResponse({
    required this.powerProductionSugarBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.update,
    required this.success
  });

  factory PowerProductionResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('powerProductionSugarBeanMap')) {
        var powerProductionBeanMapJson = json['powerProductionSugarBeanMap'];
        if (powerProductionBeanMapJson is Map<String, dynamic>) {
          var powerProductionBeanMap = powerProductionBeanMapJson.map(
                (key, value) => MapEntry(key, PowerProductionData.fromJson(value)),
          );

          return PowerProductionResponse(
            powerProductionSugarBeanMap: powerProductionBeanMap,
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
    return PowerProductionResponse(
      powerProductionSugarBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class PowerProductionData {
  final double value1;
  final double value2;
  final String resourceName;

  PowerProductionData({
    required this.value1,
    required this.value2,
    required this.resourceName,
  });

  factory PowerProductionData.fromJson(Map<String, dynamic> json) {
    return PowerProductionData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

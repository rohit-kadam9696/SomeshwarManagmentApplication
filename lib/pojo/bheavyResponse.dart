class BheavyResponse {
  Map<String, BHeavyProductionData> bheavyProductionBeanMap = {};
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;
  BheavyResponse({
    required this.bheavyProductionBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });
  factory BheavyResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('bheavyProductionBeanMap')) {
        var bheavyProductionBeanMapJson = json['bheavyProductionBeanMap'];
        if (bheavyProductionBeanMapJson is Map<String, dynamic>) {
          var bheavyProductionBeanMap = bheavyProductionBeanMapJson.map(
                (key, value) => MapEntry(key, BHeavyProductionData.fromJson(value)),
          );
          return BheavyResponse(
            bheavyProductionBeanMap: bheavyProductionBeanMap,
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            success: json['success'],
            update: json['update'],
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return BheavyResponse(
      bheavyProductionBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}
class BHeavyProductionData {
    double value1;
    double value2;
    String resourceName;
   BHeavyProductionData({
    required this.value1,
    required this.value2,
    required this.resourceName,
  });

  factory BHeavyProductionData.fromJson(Map<String, dynamic> json) {
    return BHeavyProductionData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

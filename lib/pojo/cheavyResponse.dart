class CheavyResponse {
  Map<String, CHeavyProductionData> cheavyProductionBeanMap = {};
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;

  CheavyResponse({
    required this.cheavyProductionBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory CheavyResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('cheavyProductionBeanMap')) {
        var cheavyProductionBeanMapJson = json['cheavyProductionBeanMap'];
        if (cheavyProductionBeanMapJson is Map<String, dynamic>) {
          var cheavyProductionBeanMap = cheavyProductionBeanMapJson.map(
                (key, value) => MapEntry(key, CHeavyProductionData.fromJson(value)),
          );
          return CheavyResponse(
            cheavyProductionBeanMap: cheavyProductionBeanMap,
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
    return CheavyResponse(
      cheavyProductionBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class CHeavyProductionData {
  double value1;
  double value2;
  String resourceName;

  CHeavyProductionData({
    required this.value1,
    required this.value2,
    required this.resourceName,
  });

  factory CHeavyProductionData.fromJson(Map<String, dynamic> json) {
    return CHeavyProductionData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

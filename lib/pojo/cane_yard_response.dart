class CaneYardCrushingData {
  final num cnt;
  final num avgTonnage;
  final String vehicleType;

  CaneYardCrushingData({
    required this.cnt,
    required this.avgTonnage,
    required this.vehicleType,
  });

  factory CaneYardCrushingData.fromJson(Map<String, dynamic> json) {
    return CaneYardCrushingData(
      cnt: json['cnt'],
      avgTonnage: json['avgTonnage'],
      vehicleType: json['vehicleType'],
    );
  }
}

class CaneYardResponse {
  final int nsugTypeId;
  final int nlocationId;
  final Map<String, CaneYardCrushingData> caneTypeCrushingBeanMap;
  final bool success;
  final bool update;

  CaneYardResponse({
    required this.nsugTypeId,
    required this.nlocationId,
    required this.caneTypeCrushingBeanMap,
    required this.success,
    required this.update,
  });

  factory CaneYardResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('caneYardCrushingBeanMap')) {
        var caneYardCrushingBeanMapJson = json['caneYardCrushingBeanMap'];
        if (caneYardCrushingBeanMapJson is Map<String, dynamic>) {
          var caneYardCrushingBeanMap = caneYardCrushingBeanMapJson.map(
                (key, value) => MapEntry(key, CaneYardCrushingData.fromJson(value)),
          );

          return CaneYardResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            caneTypeCrushingBeanMap: caneYardCrushingBeanMap,
            success: json['success'],
            update: json['update'],
          );
        }
      }
    } catch (e) {
      print("Error parsing JSON: $e");
    }

    throw FormatException("Invalid JSON structure for CaneYardResponse");
  }
}

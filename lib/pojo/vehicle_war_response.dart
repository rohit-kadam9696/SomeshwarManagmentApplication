class VehicleTypeWarData {
  final num todayWt;
  final num todateWt;
  final String vvehicleType;

  VehicleTypeWarData({
    required this.todayWt,
    required this.todateWt,
    required this.vvehicleType,
  });

  factory VehicleTypeWarData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return VehicleTypeWarData(todayWt: 0, todateWt: 0, vvehicleType: '');
    }

    return VehicleTypeWarData(
      todayWt: json['todayWt'] ?? 0,
      todateWt: json['todateWt'] ?? 0,
      vvehicleType: json['vvehicleType'] ?? '',
    );
  }
}

class VehicleTypeWarCrushingResponse {
  final Map<String, VehicleTypeWarData> vehicleCrushingBeanMap;
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;

  VehicleTypeWarCrushingResponse({
    required this.vehicleCrushingBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory VehicleTypeWarCrushingResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Invalid JSON structure for VehicleTypeWarCrushingResponse");
    }

    try {
      if (json.containsKey('vehicleCrushingBeanMap')) {
        var vehicleCrushingBeanMapJson = json['vehicleCrushingBeanMap'];
        if (vehicleCrushingBeanMapJson is Map<String, dynamic>) {
          var vehicleCrushingBeanMap = vehicleCrushingBeanMapJson.map(
                (key, value) => MapEntry(key, VehicleTypeWarData.fromJson(value)),
          );

          return VehicleTypeWarCrushingResponse(
            nsugTypeId: json['nsugTypeId'] ?? 0,
            nlocationId: json['nlocationId'] ?? 0,
            success: json['success'] ?? false,
            update: json['update'] ?? false,
            vehicleCrushingBeanMap: vehicleCrushingBeanMap,
          );
        }
      }
    } catch (e) {
      print("Error parsing JSON: $e");
    }

    throw FormatException("Invalid JSON structure for VehicleTypeWarCrushingResponse");
  }
}

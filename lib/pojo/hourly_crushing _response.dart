

class HourlyCrushingReponse {
  final int nsugTypeId;
  final int nlocationId;
  final Map<double, HourlyCrushingData> hourlyTypeCrushingBeanMap;
  final bool success;
  final bool update;

  HourlyCrushingReponse({
    required this.nsugTypeId,
    required this.nlocationId,
    required this.hourlyTypeCrushingBeanMap,
    required this.success,
    required this.update,
  });

  factory HourlyCrushingReponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('hourlyCrushingBeanMap')) {
        var hourlyCrushingBeanMapJson = json['hourlyCrushingBeanMap'];
        if (hourlyCrushingBeanMapJson is Map<String, dynamic>) {
          var hourlyCrushingBeanMap = hourlyCrushingBeanMapJson.map(
                (key, value) => MapEntry(double.parse(key), HourlyCrushingData.fromJson(value)),
          );

          return HourlyCrushingReponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            hourlyTypeCrushingBeanMap: hourlyCrushingBeanMap,
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
class HourlyCrushingData {
  final num hour;
  final num crushingWt;

  HourlyCrushingData({
    required this.hour,
    required this.crushingWt,
  });

  factory HourlyCrushingData.fromJson(Map<String, dynamic> json) {
    return HourlyCrushingData(
      hour: json['hour'],
      crushingWt: json['crushingWt'],
    );
  }
}

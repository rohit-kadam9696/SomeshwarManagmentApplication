import 'main_response.dart';

class PurviCaneNondVhangamResponse  {
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;
  Map<String, PurviVarietyHangamCaneData> purviVarietyHangamCaneBeanMap;

  PurviCaneNondVhangamResponse({
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
    required this.purviVarietyHangamCaneBeanMap,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nsugTypeId'] = this.nsugTypeId;
    data['nlocationId'] = this.nlocationId;
    data['success'] = this.success;
    data['update'] = this.update;
    data['purviVarietyHangamCaneBeanMap'] =
        this.purviVarietyHangamCaneBeanMap.map((key, value) =>
            MapEntry(key, value.toJson()));
    return data;
  }

  factory PurviCaneNondVhangamResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('purviVarietyHangamCaneBeanMap')) {
        var purviVarietyHangamCaneBeanMapJson =
        json['purviVarietyHangamCaneBeanMap'];
        if (purviVarietyHangamCaneBeanMapJson is Map<String, dynamic>) {
          var purviVarietyHangamCaneBeanMap =
          purviVarietyHangamCaneBeanMapJson.map(
                (key, value) => MapEntry(
              key,
              PurviVarietyHangamCaneData.fromJson(value),
            ),
          );
          return PurviCaneNondVhangamResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            success: json['success'],
            update: json['update'],
            purviVarietyHangamCaneBeanMap: purviVarietyHangamCaneBeanMap,
          );
        }
      }
    } catch (e) {
      // Handle any potential errors during deserialization
      print('Error: $e');
    }

    // Return a default instance if the JSON is not valid
    return PurviCaneNondVhangamResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
      purviVarietyHangamCaneBeanMap: {},
    );
  }
}

class PurviVarietyHangamCaneData {
  double value1;
  double value2;
  double value3;
  double value4;
  double value5;
  String resourceName;

  PurviVarietyHangamCaneData({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.resourceName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value1'] = this.value1;
    data['value2'] = this.value2;
    data['value3'] = this.value3;
    data['value4'] = this.value4;
    data['value5'] = this.value5;
    data['resourceName'] = this.resourceName;
    return data;
  }

  factory PurviVarietyHangamCaneData.fromJson(Map<String, dynamic> json) {
    return PurviVarietyHangamCaneData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      value3: (json['value3'] as num).toDouble(),
      value4: (json['value4'] as num).toDouble(),
      value5: (json['value5'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

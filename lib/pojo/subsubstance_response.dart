class SubSubstanceResponse {
  late Map<String, SubSubstanceData> subSubstanceBeanMap;
  late int nsugTypeId;
  late int nlocationId;
  late bool success;
  late bool update;

  SubSubstanceResponse({
    required this.subSubstanceBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory SubSubstanceResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('subSubstanceBeanMap')) {
        var subSubstanceBeanMapJson = json['subSubstanceBeanMap'];
        if (subSubstanceBeanMapJson is Map<String, dynamic>) {
          var subSubstanceBeanMap = subSubstanceBeanMapJson.map(
                (key, value) => MapEntry(key, SubSubstanceData.fromJson(value)),
          );
          return SubSubstanceResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            subSubstanceBeanMap: subSubstanceBeanMap,
            success: json['success'],
            update: json['update'],
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return SubSubstanceResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      subSubstanceBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class SubSubstanceData {
  late String perticular;
  late double today;
  late double todate;
  late double todateRate;

  SubSubstanceData({
    required this.perticular,
    required this.today,
    required this.todate,
    required this.todateRate,
  });

  factory SubSubstanceData.fromJson(Map<String, dynamic> json) {
    return SubSubstanceData(
      perticular: json['perticular'],
      today: (json['today'] as num).toDouble(),
      todate: (json['todate'] as num).toDouble(),
      todateRate: (json['todateRate'] as num).toDouble(),
    );
  }
}

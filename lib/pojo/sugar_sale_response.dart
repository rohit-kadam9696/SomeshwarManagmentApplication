class SugarSaleResponse {
  late Map<String, SugarSaleData> sugarSaleBeanMap;
  late int nsugTypeId;
  late int nlocationId;
  late bool success;
  late bool update;

  SugarSaleResponse({
    required this.sugarSaleBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory SugarSaleResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('sugarSaleBeanMap')) {
        var sugarSaleBeanMapJson = json['sugarSaleBeanMap'];
        if (sugarSaleBeanMapJson is Map<String, dynamic>) {
          var sugarSaleBeanMap = sugarSaleBeanMapJson.map(
                (key, value) => MapEntry(key, SugarSaleData.fromJson(value)),
          );
          return SugarSaleResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            sugarSaleBeanMap: sugarSaleBeanMap,
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
    return SugarSaleResponse(
      nsugTypeId: 0,
      nlocationId: 0,
      sugarSaleBeanMap: {},
      success: false,
      update: false,
    );
  }
}

class SugarSaleData {
  late double todateQty;
  late double todayQty;
  late String gradeName;
  late double todateAvgRate;

  SugarSaleData({
    required this.todateQty,
    required this.todayQty,
    required this.gradeName,
    required this.todateAvgRate,
  });

  factory SugarSaleData.fromJson(Map<String, dynamic> json) {
    return SugarSaleData(
      todateQty: (json['todateQty'] as num).toDouble(),
      todayQty: (json['todayQty'] as num).toDouble(),
      gradeName: json['gradeName'],
      todateAvgRate: (json['todateAvgRate'] as num).toDouble(),
    );
  }
}

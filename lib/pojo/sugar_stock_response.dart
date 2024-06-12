class SugarStockResponse {
  late Map<String, SugarStockData> sugarStockBeanMap;
  late int nsugTypeId;
  late int nlocationId;
  late bool success;
  late bool update;

  SugarStockResponse({
    required this.sugarStockBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory SugarStockResponse.fromJson(Map<String, dynamic> json) {
    var sugarStockBeanMapJson = json['sugarStockBeanMap'];
    if (sugarStockBeanMapJson is Map<String, dynamic>) {
      var sugarStockBeanMap = sugarStockBeanMapJson.map(
            (key, value) => MapEntry(key, SugarStockData.fromJson(value)),
      );
      return SugarStockResponse(
        sugarStockBeanMap: sugarStockBeanMap,
        nsugTypeId: json['nsugTypeId'],
        nlocationId: json['nlocationId'],
        success: json['success'],
        update: json['update'],
      );
    }
    // Return default instance if the JSON is not valid
    return SugarStockResponse(
      sugarStockBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class SugarStockData {
  late String vgradeName;
  late double bal;

  SugarStockData({required this.vgradeName, required this.bal});

  factory SugarStockData.fromJson(Map<String, dynamic> json) {
    return SugarStockData(
      vgradeName: json['vgradeName'],
      bal: (json['bal'] as num).toDouble(),
    );
  }
}

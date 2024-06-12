class ProductionResponse {
  Map<String, ProductionSugarData> productionSugarBeanMap = {};
  int nsugTypeId;
  int nlocationId;
  bool success;
  bool update;

  ProductionResponse({
    required this.productionSugarBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory ProductionResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('productionSugarBeanMap')) {
        var productionSugarBeanMapJson = json['productionSugarBeanMap'];
        if (productionSugarBeanMapJson is Map<String, dynamic>) {
          var productionSugarBeanMap = productionSugarBeanMapJson.map(
                (key, value) => MapEntry(key, ProductionSugarData.fromJson(value)),
          );
          return ProductionResponse(
            productionSugarBeanMap: productionSugarBeanMap,
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
    return ProductionResponse(
      productionSugarBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class ProductionSugarData {
  double value1;
  double value2;
  String resourceName;

  ProductionSugarData({
    required this.value1,
    required this.value2,
    required this.resourceName,
  });

  factory ProductionSugarData.fromJson(Map<String, dynamic> json) {
    return ProductionSugarData(
      value1: (json['value1'] as num).toDouble(),
      value2: (json['value2'] as num).toDouble(),
      resourceName: json['resourceName'],
    );
  }
}

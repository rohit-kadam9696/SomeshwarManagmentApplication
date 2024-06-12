class SubSubstanceProductionResp {
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;
  final Map<String, ProductionSubSubstanceData> productionSubSubstanceBeanMap;

  SubSubstanceProductionResp({
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
    required this.productionSubSubstanceBeanMap,
  });

  factory SubSubstanceProductionResp.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> productionMap = json['productionSubSubstanceBeanMap'];
    Map<String, ProductionSubSubstanceData> productionBeanMap = {};
    productionMap.forEach((key, value) {
      productionBeanMap[key] = ProductionSubSubstanceData.fromJson(value);
    });
    return SubSubstanceProductionResp(
      nsugTypeId: json['nsugTypeId'],
      nlocationId: json['nlocationId'],
      success: json['success'],
      update: json['update'],
      productionSubSubstanceBeanMap: productionBeanMap,
    );
  }
}

class ProductionSubSubstanceData {
  final double value1;
  final double value2;
  final String resourceName;

  ProductionSubSubstanceData({
    required this.value1,
    required this.value2,
    required this.resourceName,
  });

  factory ProductionSubSubstanceData.fromJson(Map<String, dynamic> json) {
    return ProductionSubSubstanceData(
      value1: json['value1'].toDouble(), // Convert to double
      value2: json['value2'].toDouble(), // Convert to double
      resourceName: json['resourceName'],
    );
  }
}
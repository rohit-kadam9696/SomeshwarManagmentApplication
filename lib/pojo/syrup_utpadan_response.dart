class SyrupUtpadanResponse {
  final Map<String, SyrupUtpadanData> syrupProductionBeanMap;
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;
  SyrupUtpadanResponse({
    required this.syrupProductionBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.update,
    required this.success
  });

  factory SyrupUtpadanResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('syrupProductionBeanMap')) {
        var syrupProductionBeanMapJson = json['syrupProductionBeanMap'];
        if (syrupProductionBeanMapJson is Map<String, dynamic>) {
          var syrupProductionBeanMap = syrupProductionBeanMapJson.map(
                (key, value) => MapEntry(key, SyrupUtpadanData.fromJson(value)),
          );

          return SyrupUtpadanResponse(
            nsugTypeId: json['nsugTypeId'],
            nlocationId: json['nlocationId'],
            syrupProductionBeanMap: syrupProductionBeanMap,
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
    return SyrupUtpadanResponse(
      syrupProductionBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class SyrupUtpadanData {
  late final double value1;
  late final double value2;
  late final String resourceName;

  SyrupUtpadanData({
    required this.value1,
    required this.value2,
    required this.resourceName,
  });

  factory SyrupUtpadanData.fromJson(Map<String, dynamic> json) {
    return SyrupUtpadanData(
      value1: json['value1'],
      value2: json['value2'],
      resourceName: json['resourceName'],
    );
  }
}

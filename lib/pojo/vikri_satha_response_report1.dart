class VikriSatha1Response {
  final Map<String, VikriSathaData> vikriSathaSugarBeanMap;
  final int nsugTypeId;
  final int nlocationId;
  final bool success;
  final bool update;

  VikriSatha1Response({
    required this.vikriSathaSugarBeanMap,
    required this.nsugTypeId,
    required this.nlocationId,
    required this.success,
    required this.update,
  });

  factory VikriSatha1Response.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('vikriSathaSugarBeanMap')) {
        var vikriSathaSugarBeanMapJson = json['vikriSathaSugarBeanMap'];
        if (vikriSathaSugarBeanMapJson is Map<String, dynamic>) {
          var vikriSathaSugarBeanMap = vikriSathaSugarBeanMapJson.map(
                (key, value) => MapEntry(key, VikriSathaData.fromJson(value)),
          );
          return VikriSatha1Response(
            vikriSathaSugarBeanMap: vikriSathaSugarBeanMap,
            nsugTypeId: json['nsugTypeId'] ?? 0,
            nlocationId: json['nlocationId'] ?? 0,
            success: json['success'] ?? false,
            update: json['update'] ?? false,
          );
        }
      }
    } catch (e) {
      // Handle any potential errors during deserialization
      print('Error: $e');
    }

    // Return a default instance if the JSON is not valid
    return VikriSatha1Response(
      vikriSathaSugarBeanMap: {},
      nsugTypeId: 0,
      nlocationId: 0,
      success: false,
      update: false,
    );
  }
}

class VikriSathaData {
  final double value2;
  final String resourceName;

  VikriSathaData({
    required this.value2,
    required this.resourceName,
  });

  factory VikriSathaData.fromJson(Map<String, dynamic> json) {
    return VikriSathaData(
      value2: (json['value2'] as num?)?.toDouble() ?? 0.0,
      resourceName: json['resourceName'] ?? '',
    );
  }
}

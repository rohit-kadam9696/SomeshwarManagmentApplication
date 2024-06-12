// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainResponse _$MainResponseFromJson(Map<String, dynamic> json) => MainResponse(
      success: json['success'] as bool?,
      update: json['update'] as bool?,
      nlocationId: json['nlocationId'] as int?,
      nsugTypeId: json['nsugTypeId'] as int?,
      se: json['se'] == null
          ? null
          : ServerError.fromJson(json['se'] as Map<String, dynamic>),
      updateResponse: json['updateResponse'] == null
          ? null
          : AppUpdate.fromJson(json['updateResponse'] as Map<String, dynamic>),
      vfullName: json['vfullName'] as String?,
      designation: json['designation'] as String?,
      slipboycode: json['slipboycode'] as String?,
      mobileno: json['mobileno'] as String?,
      pggroups: json['pggroups'] as String?,
      uniquestring: json['uniquestring'] as String?,
      yearCode: json['yearCode'] as String?,
      nuserRoleId: json['nuserRoleId'] as String?,
      harvestingYearCode: json['harvestingYearCode'] as String?,
      perbygroup: json['perbygroup'] as String?,
      vrrtgYear: json['vrrtgYear'] as String?,
      vfertYear: json['vfertYear'] as String?,
      fromTimeRawana: json['fromTimeRawana'] as String?,
      toTimeRawana: json['toTimeRawana'] as String?,
      currentDateTime: json['currentDateTime'] as String?,
      areaMax: json['areaMax'] as String?,
      areaMin: json['areaMin'] as String?,
      intimationAcc: json['intimationAcc'] as String?,
      intimationMinDate: json['intimationMinDate'] as String?,
      plantationAcc: json['plantationAcc'] as String?,
      plantationMaxDate: json['plantationMaxDate'] as String?,
      mapAllowIn: json['mapAllowIn'] as String?,
      calculationAcc: json['calculationAcc'] as String?,
      loadTime: json['loadTime'] as String?,
      onlineCalcualte: json['onlineCalcualte'] as String?,
    );

Map<String, dynamic> _$MainResponseToJson(MainResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'update': instance.update,
      'nlocationId': instance.nlocationId,
      'nsugTypeId': instance.nsugTypeId,
      'se': instance.se,
      'updateResponse': instance.updateResponse,
      'vfullName': instance.vfullName,
      'designation': instance.designation,
      'slipboycode': instance.slipboycode,
      'mobileno': instance.mobileno,
      'pggroups': instance.pggroups,
      'uniquestring': instance.uniquestring,
      'yearCode': instance.yearCode,
      'nuserRoleId': instance.nuserRoleId,
      'harvestingYearCode': instance.harvestingYearCode,
      'perbygroup': instance.perbygroup,
      'vrrtgYear': instance.vrrtgYear,
      'vfertYear': instance.vfertYear,
      'fromTimeRawana': instance.fromTimeRawana,
      'toTimeRawana': instance.toTimeRawana,
      'currentDateTime': instance.currentDateTime,
      'areaMin': instance.areaMin,
      'areaMax': instance.areaMax,
      'intimationAcc': instance.intimationAcc,
      'intimationMinDate': instance.intimationMinDate,
      'plantationAcc': instance.plantationAcc,
      'plantationMaxDate': instance.plantationMaxDate,
      'mapAllowIn': instance.mapAllowIn,
      'calculationAcc': instance.calculationAcc,
      'loadTime': instance.loadTime,
      'onlineCalcualte': instance.onlineCalcualte,
    };

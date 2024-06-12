// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      chitBoyId: json['chitBoyId'] as String?,
      uniqueString: json['uniqueString'] as String?,
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
      yearCode: json['yearCode'] as String?,
      nuserRoleId: json['nuserRoleId'] as String?,
      harvestingYearCode: json['harvestingYearCode'] as String?,
      perbygroup: json['perbygroup'] as String?,
      vrrtgYear: json['vrrtgYear'] as String?,
      vfertYear: json['vfertYear'] as String?,
      fromTimeRawana: json['fromTimeRawana'] as String?,
      toTimeRawana: json['toTimeRawana'] as String?,
      currentDateTime: json['currentDateTime'] as String?,
      areaMin: json['areaMin'] as String?,
      areaMax: json['areaMax'] as String?,
      intimationMinDate: json['intimationMinDate'] as String?,
      plantationMaxDate: json['plantationMaxDate'] as String?,
      plantationAcc: json['plantationAcc'] as String?,
      mapAllowIn: json['mapAllowIn'] as String?,
      onlineCalcualte: json['onlineCalcualte'] as String?,
      loadTime: json['loadTime'] as String?,
      calculationAcc: json['calculationAcc'] as String?,
      intimationAcc: json['intimationAcc'] as String?,
    )..uniquestring = json['uniquestring'] as String?;

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'uniquestring': instance.uniquestring,
      'chitBoyId': instance.chitBoyId,
      'uniqueString': instance.uniqueString,
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

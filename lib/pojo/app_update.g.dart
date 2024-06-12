// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdate _$AppUpdateFromJson(Map<String, dynamic> json) => AppUpdate(
      message: json['message'] as String?,
      forceUpdate: json['forceUpdate'] as bool?,
      head: json['head'] as String?,
      updateUrl: json['updateUrl'] as String?,
    );

Map<String, dynamic> _$AppUpdateToJson(AppUpdate instance) => <String, dynamic>{
      'forceUpdate': instance.forceUpdate,
      'head': instance.head,
      'message': instance.message,
      'updateUrl': instance.updateUrl,
    };

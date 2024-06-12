// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerError _$ServerErrorFromJson(Map<String, dynamic> json) => ServerError(
      error: json['error'] as int?,
      msg: json['msg'] as String?,
      popup: json['popup'] as bool?,
    );

Map<String, dynamic> _$ServerErrorToJson(ServerError instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'error': instance.error,
      'popup': instance.popup,
    };

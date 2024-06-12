import 'package:json_annotation/json_annotation.dart';

part 'server_error.g.dart';
@JsonSerializable()
class ServerError {
  String ? msg;
  int ? error;
  bool ? popup;

  ServerError({
    this.error,
    this.msg,
    this.popup,
  });

  factory ServerError.fromjson(Map<String, dynamic> json)=>
      _$ServerErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ServerErrorToJson(this);

  factory ServerError.fromJson(Map<String, dynamic> json) {
    return ServerError(
      msg: json['msg'] as String?,
      error: json['error'] as int?,
      popup: json['popup'] as bool?,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'app_update.g.dart';
@JsonSerializable()
class AppUpdate {
  bool ? forceUpdate;
   String ? head;
  String ? message;
   String  ? updateUrl;

  AppUpdate(
  {
    this.message,
    this.forceUpdate,
    this.head,
    this.updateUrl,
  }
  );
  factory AppUpdate.fromjson(Map<String,dynamic> json)=>_$AppUpdateFromJson(json);
  Map<String,dynamic> toJson()=>_$AppUpdateToJson(this);
  factory AppUpdate.fromJson(Map<String, dynamic> json) {

    return AppUpdate(
      message: json['message'] as String?,
      forceUpdate: json['forceUpdate'] as bool?,
      head: json['head'] as String?,
      updateUrl: json['updateUrl'] as String?,
    );
  }
}
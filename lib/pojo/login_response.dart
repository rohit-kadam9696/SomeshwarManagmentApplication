
 import 'package:SomeshwarManagementApp/pojo/server_error.dart';

import 'app_update.dart';
import 'main_response.dart';
 import 'package:json_annotation/json_annotation.dart';

 part 'login_response.g.dart';
 @JsonSerializable()
 class LoginResponse extends MainResponse {
  String? chitBoyId;
  String ? uniqueString;
  bool? success;
  bool ? update;
  int ? nlocationId,nsugTypeId;
  ServerError ? se;
  AppUpdate ? updateResponse;
  String ? vfullName,designation,slipboycode,mobileno,pggroups,yearCode,nuserRoleId,harvestingYearCode,perbygroup,vrrtgYear,vfertYear;
  String ? fromTimeRawana,toTimeRawana,currentDateTime;
  String ? areaMin,areaMax,intimationAcc,intimationMinDate,plantationAcc,plantationMaxDate,mapAllowIn,calculationAcc,loadTime,onlineCalcualte;
  LoginResponse(
      {
       this.chitBoyId,
       this.uniqueString,
       this.success,
       this.update,
       this.nlocationId,
       this.nsugTypeId,
       this.se,
       this.updateResponse,
       this.vfullName,
       this.designation,
       this.slipboycode,
       this.mobileno,
       this.pggroups,
       this.yearCode,
       this.nuserRoleId,
       this.harvestingYearCode,
       this.perbygroup,
       this.vrrtgYear,
       this.vfertYear,
       this.fromTimeRawana,
       this.toTimeRawana,
       this.currentDateTime,
       this.areaMin,
       this.areaMax,
       this.intimationMinDate,
       this.plantationMaxDate,
       this.plantationAcc,
       this.mapAllowIn,
       this.onlineCalcualte,
       this.loadTime,
       this.calculationAcc,
       this.intimationAcc,



  }) ;
  factory LoginResponse.fromjson(Map<String,dynamic> json)=>_$LoginResponseFromJson(json);
  Map<String,dynamic> toJson()=>_$LoginResponseToJson(this);

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
   return LoginResponse(
      chitBoyId: json['chitBoyId'] as String?,
     uniqueString:json['uniqueString;'] as String,

   );
  }
  }

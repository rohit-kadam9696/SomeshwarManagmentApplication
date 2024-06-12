import 'package:SomeshwarManagementApp/pojo/server_error.dart';
import 'package:json_annotation/json_annotation.dart';
import 'app_update.dart';
part 'main_response.g.dart';
@JsonSerializable()
class MainResponse  {

   bool? success;
   bool ? update;
   int ? nlocationId,nsugTypeId;
   ServerError ? se;
   AppUpdate ? updateResponse;
   String ? vfullName,designation,slipboycode,mobileno,pggroups,uniquestring,yearCode,nuserRoleId,harvestingYearCode,perbygroup,vrrtgYear,vfertYear;
   String ? fromTimeRawana,toTimeRawana,currentDateTime;
   String ? areaMin,areaMax,intimationAcc,intimationMinDate,plantationAcc,plantationMaxDate,mapAllowIn,calculationAcc,loadTime,onlineCalcualte;

   MainResponse(
       {
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
         this.uniquestring,
         this.yearCode,
         this.nuserRoleId,
         this.harvestingYearCode,
         this.perbygroup,
         this.vrrtgYear,
         this.vfertYear,
         this.fromTimeRawana,
         this.toTimeRawana,
         this.currentDateTime,
         this.areaMax,
         this.areaMin,
         this.intimationAcc,
         this.intimationMinDate,
         this.plantationAcc,
         this.plantationMaxDate,
         this.mapAllowIn,
         this.calculationAcc,
         this.loadTime,
         this.onlineCalcualte
       });
   factory MainResponse.fromjson(Map<String,dynamic> json)=>_$MainResponseFromJson(json);
   Map<String,dynamic> toJson()=>_$MainResponseToJson(this);

   factory MainResponse.fromJson(Map<String, dynamic> json) {
     return MainResponse(
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
   }
  }




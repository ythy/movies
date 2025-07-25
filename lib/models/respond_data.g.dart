// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respond_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespondData _$RespondDataFromJson(Map<String, dynamic> json) => RespondData(
  error: json['error'] as bool,
  msg: json['msg'] as String?,
  data: json['data'],
);

Map<String, dynamic> _$RespondDataToJson(RespondData instance) =>
    <String, dynamic>{
      'error': instance.error,
      'msg': instance.msg,
      'data': instance.data,
    };

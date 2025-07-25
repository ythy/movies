import 'package:json_annotation/json_annotation.dart';

part 'respond_data.g.dart';

@JsonSerializable()
class RespondData {
  final bool error;
  final String? msg;
  final dynamic data;

  RespondData({required this.error, required this.msg, required this.data});

  factory RespondData.fromJson(Map<String, dynamic> json) => _$RespondDataFromJson(json);

  Map<String, dynamic> toJson() => _$RespondDataToJson(this);


}
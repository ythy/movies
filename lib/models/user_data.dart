import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {

  final String id;
  final String name;
  final String password;
  final String blockflag;

  UserData({required this.id, required this.name, required this.blockflag, required this.password});

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);


}
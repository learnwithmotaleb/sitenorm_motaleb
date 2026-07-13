import 'package:weather_app/utils/api_urls/api_urls.dart';

class ProfileModel {
  final bool? success;
  final Data? data;

  ProfileModel({this.success, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  Data({
    this.id,
    this.name,
    this.email,
    this.role,
    this.avatar,
    this.createdAt,
    this.lastLogin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    avatar: ApiUrls.getImageUrl(json["avatar"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    lastLogin: json["lastLogin"] == null
        ? null
        : DateTime.parse(json["lastLogin"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "avatar": avatar,
    "createdAt": createdAt?.toIso8601String(),
    "lastLogin": lastLogin?.toIso8601String(),
  };
}

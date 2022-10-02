// ignore_for_file: prefer_if_null_operators

import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    required this.id,
    required this.email,
    required this.avatar,
    required this.phone,
    required this.userName,
    required this.emailToken,
    required this.isVerified,
  });
  final String id;
  final String email;
  final String userName;
  final String avatar;
  final String phone;
  final String emailToken;
  bool isVerified;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      phone: json['phone'],
      userName: json['username'],
      avatar: json['avatar'] != null ? json['avatar'] : '',
      emailToken: json['emailToken'] != null ? json['emailToken'] : '',
      isVerified: json['isVerified'] != null ? json['isVerified'] : false,
    );
  }
  @override
  List<Object?> get props => [email, id, avatar, phone];
}

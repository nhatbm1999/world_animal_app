import 'package:equatable/equatable.dart';

class AccessToken extends Equatable {
  const AccessToken({
    required this.accessToken,
    required this.expiresIn,
  });
  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      accessToken: json['access_token'],
      expiresIn: json['expire_in'],
    );
  }
  final String accessToken;
  final int expiresIn;

  @override
  List<Object?> get props => [accessToken];
}

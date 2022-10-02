import 'dart:async';


import 'package:animal_world_app/authentication/model/token.dart';
import 'package:animal_world_app/authentication/model/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({required this.httpClient}) {
    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('token');

      httpClient.options.headers['content-Type'] = 'application/json';
      httpClient.options.headers['authorization'] = 'Bearer $token';
    });
  }
  final Dio httpClient;
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    var prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token != '') {
      httpClient.options.headers['authorization'] = 'Bearer $token';

      try {
        final response = await httpClient.post('auth/refresh');

        if (response.statusCode != 200) {
          yield AuthenticationStatus.unauthenticated;
        } else {
          final accessToken = AccessToken.fromJson(response.data);
          await prefs.setString('token', accessToken.accessToken);

          yield AuthenticationStatus.authenticated;
        }
      } catch (error) {
        yield AuthenticationStatus.unauthenticated;
      }
    } else {
      yield AuthenticationStatus.unauthenticated;
    }

    yield* _controller.stream;
  }

  Future<AccessToken> logIn({
    required String email,
    required String password,
  }) async {
    final response = await httpClient.post('/login', data: {
      'email': email,
      'password': password,
    });
    final accessToken = AccessToken.fromJson(response.data);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', accessToken.accessToken);

    httpClient.options.headers['content-Type'] = 'application/json';
    httpClient.options.headers['authorization'] =
        'Bearer ${accessToken.accessToken}';

    _controller.add(AuthenticationStatus.authenticated);
    return accessToken;
  }

  Future<User?> getCurrentUser() async {
    final response = await httpClient.get('/auth/me',);
    return User.fromJson(response.data);
  }

  void logOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

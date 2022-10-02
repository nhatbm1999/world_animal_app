import 'package:animal_world_app/app.dart';
import 'package:animal_world_app/common/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final options = BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: 15000,
    receiveTimeout: 3000,
    headers: {
      'content-Type': 'application/json',
      'authorization': 'Bearer $token'
    },
  );
  final httpClient = Dio(options);
  runApp(App(httpClient: httpClient));
}

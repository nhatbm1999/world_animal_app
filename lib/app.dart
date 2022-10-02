import 'package:animal_world_app/authentication/bloc/authentication_bloc.dart';
import 'package:animal_world_app/authentication/repository/auth_repository.dart';
import 'package:animal_world_app/home/view/home_page.dart';
import 'package:animal_world_app/splash/view/splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.httpClient}) : super(key: key);

  final Dio httpClient;

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthenticationRepository(httpClient: httpClient);
    return RepositoryProvider.value(
      value: httpClient,
      child: RepositoryProvider(
        create: (_) => authRepository,
        child: BlocProvider(
          create: (_) => AuthenticationBloc(
            authenticationRepository: authRepository,
          ),
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil(
                    HomePage.route(), (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil(
                    HomePage.route(), (route) => false);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}

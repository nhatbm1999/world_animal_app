import 'dart:async';

import 'package:animal_world_app/authentication/model/user.dart';
import 'package:animal_world_app/authentication/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.authenticationRepository})
      : super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequest);
    _authenticationStatusSubscription = authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }
  final AuthenticationRepository authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;
  
  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    authenticationRepository.dispose();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch(event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogoutRequest(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    authenticationRepository.logOut();
  }
  
  Future<User?> _tryGetUser() async {
    try {
      final user = await authenticationRepository.getCurrentUser();
      return user;
    } catch(error) {
      print(error);
      return null;
    }
  }
}

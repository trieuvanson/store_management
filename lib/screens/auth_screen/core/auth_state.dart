part of 'auth_bloc.dart';

@immutable
class AuthState {
  final AuthResponse? auth;

  const AuthState({this.auth});

  //copyWith

  AuthState copyWith({AuthResponse? auth}) => AuthState(
        auth: auth ?? this.auth,
      );
}

class LoadingAuthState extends AuthState {}

class SuccessAuthState extends AuthState {}

class LogOutAuthState extends AuthState {}

class FailureAuthState extends AuthState {
  final error;
  const FailureAuthState(this.error);
}
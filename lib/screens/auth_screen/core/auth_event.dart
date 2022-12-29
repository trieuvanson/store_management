part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String userName;
  final String passWord;

  LoginEvent({required this.userName, required this.passWord});
}

class CheckLoginEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}



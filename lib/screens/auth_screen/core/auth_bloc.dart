import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '/screens/auth_screen/model/auth_response.dart';

import '../../../utils/secure_storage.dart';
import '../repository/auth_repostory.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogOutEvent>(_onLogOut);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());
      final data = await authRepository.login(event.userName, event.passWord);
      await Future.delayed(const Duration(milliseconds: 850));
      if (data != null && data.message == null) {
        await secureStorage.deleteSecureStorage();
        await secureStorage.persistAuth(data);
        emit(state.copyWith(auth: data));
        return;
      }
      emit(FailureAuthState(data!.message!));
    } catch (e) {
      emit(FailureAuthState(e.toString()));
    }
  }

  Future<void> _onCheckLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());
      if (await secureStorage.readAuth() != null) {
        // final data = await authRepository.renewLoginController();
        AuthResponse? data = await secureStorage.readAuth();
        //Kiểm tra token có hết hạn hay không, token giới hạn thời gian là 3 giờ
        if (data!.expiresIn! < DateTime.now().millisecondsSinceEpoch) {
          await secureStorage.deleteSecureStorage();
          emit(LogOutAuthState());
        } else {
          emit(state.copyWith(auth: data));
        }
      } else {
        emit(LogOutAuthState());
      }
    } catch (e) {
      emit(FailureAuthState(e.toString()));
    }
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      // emit(const LoadingAuthState());
      // await secureStorage.deleteSecureStorage();
      // emit(const LogOutAuthState());
    } catch (e) {
      emit(FailureAuthState(e.toString()));
    }
  }
}

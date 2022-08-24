import 'package:annisa_furniture/services/auth/auth_provider.dart';
import 'package:annisa_furniture/services/auth/auth_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // Initialize firebase apps
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();

      final user = provider.currentUser;

      if (user == null) {
        emit(AuthStateLoggedOut());
      } else {
        emit(AuthStateLoggedIn(user));
      }
      // emit(AuthStateLoggedOut());
    });

    //
    on<AuthEventSendVerificationCode>((event, emit) async {
      final phoneNumber = event.phoneNumber;

      await provider.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: (credential) {
          add(AuthEventVerificationCompleted(credential));
        },
        onVerificationFailed: (exception) {},
        onCodeSent: (verificationId, smsCode) {
          add(AuthEventCodeSent(
            smsCode: smsCode,
            verificationId: verificationId,
          ));
        },
        codeAutoRetrievalTimeOut: (verificationId) {},
      );
    });

    on<AuthEventCodeSent>((event, emit) async {
      emit(AuthStateCodeSent(event.verificationId, event.smsCode));
    });

    on<AuthEventVerifyCode>((event, emit) async {
      final verificationId = event.verificationId;
      final smsCode = event.smsCode;

      await provider.logIn(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final user = provider.currentUser;

      if (user != null) {
        emit(AuthStateLoggedIn(user));
      } else {
        emit(AuthStateLoggedOut());
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      await provider.logout();
      emit(AuthStateLoggedOut());
    });
  }
}

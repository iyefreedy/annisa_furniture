part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendVerificationCode extends AuthEvent {
  final String phoneNumber;
  const AuthEventSendVerificationCode(this.phoneNumber);
}

class AuthEventVerificationCompleted extends AuthEvent {
  final PhoneAuthCredential credential;
  const AuthEventVerificationCompleted(this.credential);
}

class AuthEventCodeSent extends AuthEvent {
  final int? smsCode;
  final String verificationId;

  const AuthEventCodeSent({
    required this.smsCode,
    required this.verificationId,
  });
}

class AuthEventVerifyCode extends AuthEvent {
  final int? smsCode;
  final String verificationId;

  const AuthEventVerifyCode(this.verificationId, this.smsCode);
}

class AuthEventLogOut extends AuthEvent {}

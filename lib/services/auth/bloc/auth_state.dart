part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {}

class AuthStateLoggedOut extends AuthState {}

class AuthStateCodeSent extends AuthState {
  final String verificationId;
  final int? smsCode;
  const AuthStateCodeSent(this.verificationId, this.smsCode);
}

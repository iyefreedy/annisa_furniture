import 'package:annisa_furniture/services/auth/auth_provider.dart';
import 'package:annisa_furniture/services/auth/auth_user.dart';
import 'package:annisa_furniture/services/auth/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> logIn({
    required String verificationId,
    required int? smsCode,
  }) =>
      provider.logIn(
        verificationId: verificationId,
        smsCode: smsCode,
      );

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) codeAutoRetrievalTimeOut,
  }) =>
      provider.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: onVerificationCompleted,
        onVerificationFailed: onVerificationFailed,
        onCodeSent: onCodeSent,
        codeAutoRetrievalTimeOut: codeAutoRetrievalTimeOut,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<AuthUser> signInWithCredential({
    required AuthCredential credential,
  }) =>
      provider.signInWithCredential(credential: credential);
}

import 'package:annisa_furniture/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> signInWithCredential({required AuthCredential credential});

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) codeAutoRetrievalTimeOut,
  });

  Future<AuthUser> logIn({
    required String verificationId,
    required int? smsCode,
  });

  Future<void> logout();
}

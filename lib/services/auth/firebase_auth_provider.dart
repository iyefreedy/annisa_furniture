import 'package:annisa_furniture/firebase_options.dart';
import 'package:annisa_furniture/services/auth/auth_exceptions.dart';
import 'package:annisa_furniture/services/auth/auth_provider.dart';
import 'package:annisa_furniture/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String verificationId,
    required int? smsCode,
  }) async {
    try {
      final phoneCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.toString(),
      );
      final credential =
          await FirebaseAuth.instance.signInWithCredential(phoneCredential);

      final user = credential.user;

      if (user != null) {
        return AuthUser.fromFirebase(user);
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (_) {
      throw Exception();
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(FirebaseAuthException) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) codeAutoRetrievalTimeOut,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: onVerificationCompleted,
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeOut,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> signInWithCredential({
    required AuthCredential credential,
  }) async {
    final user = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((credential) => credential.user);

    if (user == null) {
      throw UserNotLoggedInAuthException();
    }

    return AuthUser.fromFirebase(user);
  }
}

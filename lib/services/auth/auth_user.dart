import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String phoneNumber;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  AuthUser({
    required this.id,
    required this.phoneNumber,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        phoneNumber: user.phoneNumber!,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
}

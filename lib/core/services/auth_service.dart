import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) throw const _CancelledException();
    final googleAuth = await googleUser.authentication;
    return _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ),
    );
  }

  Future<UserCredential> signInAsGuest() => _auth.signInAnonymously();

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _google.signOut()]);
  }
}

class _CancelledException implements Exception {
  const _CancelledException();
  @override
  String toString() => 'Google sign-in cancelled.';
}

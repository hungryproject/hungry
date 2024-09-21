import 'package:firebase_auth/firebase_auth.dart';

class Orphanageauthservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception(e.message ?? 'An error occurred during registration.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred during registration: $e');
    }
  }

}
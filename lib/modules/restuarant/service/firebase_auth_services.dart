import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle user sign-in using email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      } else {
        throw Exception(e.message ?? 'An error occurred during sign-in.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred during sign-in: $e');
    }
  }

  // Method to handle user registration using email and password
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

  // Method to handle user sign-out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('An error occurred while signing out: $e');
    }
  }

  // Method to get the currently signed-in user
  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (e) {
      throw Exception('An error occurred while fetching the current user: $e');
    }
  }

  // Method to handle password reset via email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'An error occurred while sending password reset email.');
    } catch (e) {
      throw Exception('An unknown error occurred while sending password reset email: $e');
    }
  }

  // Method to update the email address of the current user
  Future<void> updateEmail(String newEmail, String password) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    try {
      // Reauthenticate user before updating email
      final credential = EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      // Update email
      await user.verifyBeforeUpdateEmail(newEmail);
      await user.sendEmailVerification();
      print('Email updated successfully. Verification email sent.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('The email address is badly formatted.');
      } else if (e.code == 'requires-recent-login') {
        throw Exception('Reauthentication required. Please sign in again.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception(e.message ?? 'An error occurred while updating the email.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred while updating the email: $e');
    }
  }

  // Method to update the password of the current user
  Future<void> updatePassword(String newPassword, String oldPassword) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    try {
      // Reauthenticate user before updating password
      final credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      print('Password updated successfully.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'requires-recent-login') {
        throw Exception('Reauthentication required. Please sign in again.');
      } else {
        throw Exception(e.message ?? 'An error occurred while updating the password.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred while updating the password: $e');
    }
  }
}

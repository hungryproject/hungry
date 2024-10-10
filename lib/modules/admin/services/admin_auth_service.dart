import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Adminauthservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore  _firestore = FirebaseFirestore.instance;
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



  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if(userCredential.user != null){
        final a =  _firestore.collection('Admin').doc(getId());

        if(a.id == getId()){

          return true;
        }
        return false;

        

      }

      return false;

      
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


  String getId(){

    return FirebaseAuth.instance.currentUser!.uid;
  }

}
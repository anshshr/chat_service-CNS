import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // register the user
  Future<String> registerUser(String email, String password) async {
    try {
      //TODO : hash the passwords using the bcrypt for secure authentication
      //TODO : validate password must be 6 characters long
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firestore
          .collection("users")
          .doc(auth.currentUser?.uid)
          .set({"email": email, "userId": auth.currentUser?.uid});

      return "Success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e.message.toString();
    }
  }

  //login the user
  Future<String> loginUser(String email, String password) async {
    try {
      //TODO : decrypt the passwords using the bcrypt for secur authentication
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      debugPrint(e.message.toString());
      return e.message.toString();
    }
  }

  // logout

  Future<String> logoutUser() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // TODO: change password
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseServices {
  static String errorMessage = "";

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> signUp(String name, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(name, email, password)})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";

          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";

          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";

          break;
        case "too-many-requests":
          errorMessage = "Too many requests";

          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";

          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  static postDetailsToFirestore(
      String name, String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    // UserModel userModel = UserModel(uid: int.parse(user!.uid), email: user.email, fullName: _fullName.text, password: _password.text);

    await firebaseFirestore.collection("Users").doc(user!.uid).set({
      "email": user.email,
      "uid": user.uid,
      "password": password,
      "name": name,
    });
    Fluttertoast.showToast(msg: "Account created successfully :) ");
  }

  static Future<void> login(
    String email,
    String password,
  ) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";

          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";

          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";

          break;
        case "too-many-requests":
          errorMessage = "Too many requests";

          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";

          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
    }
  }
}

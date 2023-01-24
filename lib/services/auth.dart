import 'package:firebase_auth/firebase_auth.dart';
import 'package:vp_admin/packages/flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with email & password
  Future<String?> signInWithEmailAndPassword(LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          {
            return "Invalid Email";
          }
        case "wrong-password":
          {
            return "Password incorrect. Please try again";
          }
        case "user-not-found":
          {
            return "Wrong email address or password";
          }
        case "user-disabled":
          {
            return "This account is disabled";
          }
        case "too-many-requests":
          {
            return "Too many requests. Try again later";
          }
        default:
          {
            return e.message;
          }
      }
    }
  }

  // register with email & password
  Future<String?> registerWithEmailAndPassword(SignupData data) async {
    if (data.password == null || data.name == null) {
      return "Please enter email and password";
    }
    try {
      await _auth.createUserWithEmailAndPassword(
          email: data.name!, password: data.password!);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          {
            return "Invalid Email";
          }
        case "email-already-in-use":
          {
            return "Email already in use";
          }
        case "weak-password":
          {
            return "Password is too weak";
          }
        default:
          {
            return e.message;
          }
      }
    }
  }

  //Recovers password
  Future<String?> recoverPassword(String name) async {
    try {
      await _auth.sendPasswordResetEmail(email: name);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          {
            return "Invalid Email";
          }
        case "user-not-found":
          {
            return "User not found";
          }
        default:
          {
            return e.message;
          }
      }
    }
  }

  //Google Sign In
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _guser;

  GoogleSignInAccount? get guser {
    return _guser;
  }

  //Sign In with google
  Future<String?>? signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      _guser = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "account-exists-with-different-credential") {
        return "Email already exists";
      } else if (e.code == "invalid-credential") {
        return "Invalid credential";
      } else {
        return e.message;
      }
    }
  }

  // sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';


class AuthServices{
    static final _auth = FirebaseAuth.instance;

    static User? get currentUser => _auth.currentUser;

    static Future<bool> loginto(String email, String password) async{
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user != null;
    }



  }

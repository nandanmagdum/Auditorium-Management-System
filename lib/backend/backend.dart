import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> registeruser(String email, String password) async{
  UserCredential _user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
}
Future<void> signinemailpass(String email, String password) async{
  UserCredential _user = await _auth.signInWithEmailAndPassword(email: email, password: password);
}
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly'
  ]
);
Future<void> handleSignIn() async{
  try{
    await _googleSignIn.signIn();
  } catch(e){
    print(e);
  }
}
}
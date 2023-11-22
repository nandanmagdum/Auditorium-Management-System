import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  static email_pass_sign_in(String email, String password) async{

  }
  googleSIGN() async {
    final GoogleSignInAccount? gAcc = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gAcc!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> registeruser(String email, String password) async{
  UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
}
Future<void> signinemailpass(String email, String password) async{
  UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: password);
}
final GoogleSignIn _googleSignIn = GoogleSignIn(
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
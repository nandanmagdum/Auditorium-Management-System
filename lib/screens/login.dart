import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audi/backend/backend.dart';
import 'homescreen.dart';
import 'const.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Auth auth = Auth();
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool IsPassVisible = false;
  Icon suffix = const Icon(Icons.remove_red_eye_outlined);
  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: !IsPassVisible,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        suffixIcon: GestureDetector( onTap: (){
          setState(() {
            IsPassVisible = !IsPassVisible;
            if(IsPassVisible == true){
              suffix = const Icon(Icons.remove_red_eye_outlined);
            }
            else {
              suffix = const Icon(Icons.remove_red_eye);
            }
          });
        }
            ,child: suffix),
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: buttonColor,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            try{
              await auth.signinemailpass(emailController.text, passwordController.text)
                  .then((value) => HomeScreen());
            } catch(e){
              print(e);
            }
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final register = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: buttonColor,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async{
            try{
              await auth.registeruser(emailController.text, passwordController.text)
                  .then((value) => HomeScreen());
            } catch(e){
              print(e);
            }
          },
          child: const Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    final signinwithgoogle = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            // signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Sign in with Google",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // title: Text("Login / Register", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
        // centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              Image.asset('assets/gcek_logo.png', scale: 7,),
              SizedBox(height: 40,),
              Text("Login", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              emailField,
              SizedBox(height: 20,),
              passwordField,
              SizedBox(height: 20,),
              loginButton,
              SizedBox(height: 20,),
              register,
              GestureDetector(onTap: () async{
                await auth.handleSignIn();
              } ,child: Image.asset('assets/google.png')),
            ],
          ),
        ),
      ),
    );
  }
}

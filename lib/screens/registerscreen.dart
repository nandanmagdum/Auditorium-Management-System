import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Constant.dart';
import 'homepage.dart';
import 'login.dart';
import 'const.dart';
import 'package:audi/backend/backend.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final _role = ['student', 'professor / club member'];
String? _selectedValue = 'student';

class _RegisterScreenState extends State<RegisterScreen> {
  Auth auth = Auth();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  bool IsPassVisible = false;
  bool IsConfirmPassVisible = false;
  Icon suffix = const Icon(Icons.visibility_off);
  Icon confirmPassSuffix = const Icon(Icons.visibility_off);
  Color adminColor = notselected;
  Color ClubColor = notselected;
  Color StudentColor = selected;
  @override
  Widget build(BuildContext context) {
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
          prefixIcon: const Icon(Icons.email),
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
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                IsPassVisible = !IsPassVisible;
                if (IsPassVisible == true) {
                  suffix = const Icon(Icons.visibility);
                } else {
                  suffix = const Icon(Icons.visibility_off);
                }
              });
            },
            child: suffix),
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmpasswordController,
      obscureText: !IsConfirmPassVisible,
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
        confirmpasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                IsConfirmPassVisible = !IsConfirmPassVisible;
                if (IsConfirmPassVisible == true) {
                  confirmPassSuffix = const Icon(Icons.visibility);
                } else {
                  confirmPassSuffix = const Icon(Icons.visibility_off);
                }
              });
            },
            child: confirmPassSuffix),
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    bool isLoading = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
            ),
            const Text(
              "Create your account",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 20,
            ),
            emailField,
            const SizedBox(
              height: 20,
            ),
            passwordField,
            const SizedBox(
              height: 20,
            ),
            confirmpasswordField,
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              items: _role.map((e) {
                return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedValue = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.grey,
              ),
              dropdownColor: Colors.white,
              decoration: kBoxDecoration.copyWith(hintText: 'Select your role'),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              color: buttonColor,
              child: MaterialButton(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () async {
                    isLoading = true;
                    if (emailController.text.isNotEmpty) {
                      try {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(emailController.text)
                            .set({
                          "email": emailController.text,
                          "role": _selectedValue
                        });
                        // print("Database updated");
                        final user = await auth.registeruser(
                            emailController.text, passwordController.text);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                        //  else {
                        //   print("Auth is null");
                        //   showErrorSnackbar(context, "Auth is null");
                        // }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          duration: Duration(seconds: 3),
                        ));
                        print(e);
                        showErrorSnackbar(context, e.toString());
                      }
                    } else {
                      // print("Null check error");
                    }
                    isLoading = false;
                  },
                  child: const Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

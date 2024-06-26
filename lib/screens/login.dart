import 'dart:async';
import 'package:audi/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audi/backend/backend.dart';
import 'const.dart';
import 'homepage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ////////////////
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    startPeriodicCheck();
  }

  Future<void> initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String eventTitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Event Today!',
      'You have an event scheduled: $eventTitle',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void startPeriodicCheck() {
    // Adjust the duration based on your requirements
    const Duration checkInterval = Duration(minutes: 15);

    Timer.periodic(checkInterval, (Timer timer) {
      checkForTodayEvents();
    });
  }

  void checkForTodayEvents() {
    // Replace this with your logic to check events scheduled for today
    // For simplicity, we'll just assume there's an event today
    bool hasEventToday = true;

    if (hasEventToday) {
      showNotification('Your Event Title');
    }
  }

  ////////////////

  Auth auth = Auth();
  // form key
  final _formKey = GlobalKey<FormState>();
  Color adminColor = notselected;
  Color ClubColor = notselected;
  Color StudentColor = selected;
  String role = "student";
  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<String> roles = ['Admin', 'Club Co-ordinator', 'Student'];
  var selectedItem = 'Student';
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
                  suffix = const Icon(Icons.remove_red_eye_outlined);
                } else {
                  suffix = const Icon(Icons.remove_red_eye);
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

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: buttonColor,
      child: ScaffoldMessenger(
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async {
              try {
                await auth
                    .signinemailpass(
                        emailController.text, passwordController.text)
                    .then((value) => const HomePage());
              } catch (e) {
                showErrorSnackbar(context, e.toString());
                // print(e);
              }
            },
            child: const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
    final register = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: buttonColor,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            try {
              await auth
                  .registeruser(emailController.text, passwordController.text)
                  .then((value) => const HomePage());
            } catch (e) {
              showErrorSnackbar(context, e.toString());
              // print(e);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
              ),
              Image.asset(
                'assets/gcek_logo.png',
                scale: 6,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Login",
                style: TextStyle(fontSize: 40, fontFamily: 'Poppins'),
              ),
              const SizedBox(
                height: 30,
              ),
              emailField,
              const SizedBox(
                height: 20,
              ),
              passwordField,
              const SizedBox(
                height: 5,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Login as: ",
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             role = "admin";
              //             print("admin selecrted");
              //             adminColor = selected;
              //             ClubColor = notselected;
              //             StudentColor = notselected;
              //           });
              //         },
              //         child: Container(
              //           margin: EdgeInsets.all(3),
              //           padding: EdgeInsets.all(2),
              //           color: adminColor,
              //           child: Text(
              //             "Admin",
              //             style: TextStyle(fontSize: 16),
              //           ),
              //         )),
              //     GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             role = "club";
              //             print("Club selecrted");
              //             adminColor = notselected;
              //             ClubColor = selected;
              //             StudentColor = notselected;
              //           });
              //         },
              //         child: Container(
              //           margin: EdgeInsets.all(3),
              //           padding: EdgeInsets.all(2),
              //           color: ClubColor,
              //           child: Text(
              //             "Club Coordinator",
              //             style: TextStyle(fontSize: 16),
              //           ),
              //         )),
              //     GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             role = "student";
              //             print("club selecrted");
              //             adminColor = notselected;
              //             ClubColor = notselected;
              //             StudentColor = selected;
              //           });
              //         },
              //         child: Container(
              //           margin: EdgeInsets.all(3),
              //           padding: EdgeInsets.all(2),
              //           color: StudentColor,
              //           child: Text(
              //             "Student",
              //             style: TextStyle(fontSize: 16),
              //           ),
              //         )),
              //   ],
              // ),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                color: buttonColor,
                child: ScaffoldMessenger(
                  child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (adminColor == selected &&
                            emailController.text != 'n@gmail.com') {
                          showErrorSnackbar(context, "YOU ARE NOT ADMIN");
                          return;
                        }
                        try {
                          await auth
                              .signinemailpass(
                                  emailController.text, passwordController.text)
                              .then((value) => const HomePage());
                        } catch (e) {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 3), ));
                          // print(e);
                          showErrorSnackbar(context, e.toString());
                        }
                      },
                      child: const Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
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
              // GestureDetector(
              //     onTap: () async {
              //       try {
              //         final GoogleSignInAccount? gAcc =
              //             await GoogleSignIn().signIn();
              //         final GoogleSignInAuthentication gAuth =
              //             await gAcc!.authentication;
              //         final credential = GoogleAuthProvider.credential(
              //             idToken: gAuth.idToken,
              //             accessToken: gAuth.accessToken);
              //         await FirebaseAuth.instance
              //             .signInWithCredential(credential)
              //             .then((value) => HomePage());
              //       } catch (e) {
              //         showErrorSnackbar(context, e.toString());
              //       }
              //     },
              //     child: Image.asset(
              //       'assets/google.png',
              //       scale: 1,
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}

void showErrorSnackbar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

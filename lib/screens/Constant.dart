import 'package:flutter/material.dart';

const kBoxDecoration =  InputDecoration(
    hintText: 'Event name',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    border: OutlineInputBorder(),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)));
const kStartBoxDecoration = InputDecoration(
    hintText: 'Start',
    filled: true,
    suffixIcon: Icon(
      Icons.access_time_rounded,
      color: Colors.grey,
    ),
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    border: OutlineInputBorder(),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)));
//
// final emailField = TextFormField(
//     autofocus: false,
//     controller: emailController,
//     keyboardType: TextInputType.emailAddress,
//     validator: (value) {
//       if (value!.isEmpty) {
//         return ("Please Enter Your Email");
//       }
//       // reg expression for email validation
//       if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//           .hasMatch(value)) {
//         return ("Please Enter a valid email");
//       }
//       return null;
//     },
//     onSaved: (value) {
//       emailController.text = value!;
//     },
//     textInputAction: TextInputAction.next,
//     decoration: InputDecoration(
//       prefixIcon: Icon(Icons.email),
//       contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//       hintText: "Email",
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ));
//
// //password field
// final passwordField = TextFormField(
//   autofocus: false,
//   controller: passwordController,
//   obscureText: !IsPassVisible,
//   validator: (value) {
//     RegExp regex = RegExp(r'^.{6,}$');
//     if (value!.isEmpty) {
//       return ("Password is required for login");
//     }
//     if (!regex.hasMatch(value)) {
//       return ("Enter Valid Password(Min. 6 Character)");
//     }
//     return null;
//   },
//   onSaved: (value) {
//     passwordController.text = value!;
//   },
//   textInputAction: TextInputAction.done,
//   decoration: InputDecoration(
//     suffixIcon: GestureDetector(
//         onTap: () {
//           setState(() {
//             IsPassVisible = !IsPassVisible;
//             if (IsPassVisible == true) {
//               suffix = const Icon(Icons.remove_red_eye_outlined);
//             } else {
//               suffix = const Icon(Icons.remove_red_eye);
//             }
//           });
//         },
//         child: suffix),
//     prefixIcon: const Icon(Icons.vpn_key),
//     contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//     hintText: "Password",
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//   ),
// );


// this is register button , copy it and uncomment for use
// Material(
// elevation: 5,
// borderRadius: BorderRadius.circular(10),
// color: buttonColor,
// child: MaterialButton(
// padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
// minWidth: MediaQuery.of(context).size.width,
// onPressed: () async {
// if (adminColor == selected) {
// showErrorSnackbar(context, "Admin cannot be created");
// return;
// }
// try {
// await auth
//     .registeruser(
// emailController.text, passwordController.text)
//     .then((value) => HomePage());
// } catch (e) {
// // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 3), ));
// print(e);
// showErrorSnackbar(context, e.toString());
// }
// },
// child: const Text(
// "Regiser",
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 20,
// color: Colors.white,
// fontWeight: FontWeight.bold),
// )),
// ),
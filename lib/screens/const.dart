import 'package:flutter/material.dart';

Color buttonColor = const Color.fromARGB(255, 115, 91, 241);
Color notselected = Colors.grey;
Color selected = buttonColor;
Color appBarColor = const Color(0xFFD9D9D9);
// class button extends StatelessWidget {
//   final text;
//   final GestureDetector gesture;
//   final _color = Colors.purple;
//   const button({super.key, required this.text, required this.gesture});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 5,
//       borderRadius: BorderRadius.circular(10),
//       color: buttonColor,
//       child: ScaffoldMessenger(
//         child: MaterialButton(
//             padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//             minWidth: MediaQuery.of(context).size.width,
//             onPressed: () async {
//               if (adminColor == selected &&
//                   emailController.text != 'n@gmail.com') {
//                 showErrorSnackbar(context, "YOU ARE NOT ADMIN");
//                 return;
//               }
//               try {
//                 await auth
//                     .signinemailpass(
//                     emailController.text, passwordController.text)
//                     .then((value) => HomePage());
//               } catch (e) {
//                 // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 3), ));
//                 print(e);
//                 showErrorSnackbar(context, e.toString());
//               }
//             },
//             child: const Text(
//               "Login",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold),
//             )),
//       ),
//     ),;
//   }
// }

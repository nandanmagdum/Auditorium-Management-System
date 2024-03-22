import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DevelopersPage extends StatelessWidget {
  const DevelopersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Developers",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                personCard(
                    name: "Nandan Magdum",
                    img: "assets/nandan.png",
                    contactNo: '8180097590'),
                const Divider(indent: 40, endIndent: 40),
                personCard(
                    name: "Pooja Chavan",
                    img: "assets/pooja.jpg",
                    contactNo: '9579363569'),
                const Divider(indent: 40, endIndent: 40),
                personCard(
                    name: "Atharv Chougule",
                    img: "assets/atharv.jpg",
                    contactNo: '9422324904'),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF22223b),
                      ),
                      onPressed: () {
                        launchUrlString(
                          'https://docs.google.com/forms/d/e/1FAIpQLScLf-Tg5ieQPVFyAnwYWVasUM4BMv5Sgtfr9rHpPB_mGWXwrQ/viewform?usp=sf_link',
                          // "http://google.com"
                        );
                      },
                      child: const Center(
                          child: Text(
                        "Give your Feedback here",
                        style: TextStyle(color: Colors.white),
                      ))),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget personCard(
    {required String name, required String img, required String contactNo}) {
  return Column(
    children: [
      const SizedBox(height: 10),
      CircleAvatar(
        radius: 70,
        child: img != "img"
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(img))
            : const Icon(Icons.person),
      ),
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      Text(
        "B.Tech IT 2025",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.grey.shade800),
      ),
      Text(
        contactNo,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.grey.shade800),
      ),
      const SizedBox(height: 10),
    ],
  );
}

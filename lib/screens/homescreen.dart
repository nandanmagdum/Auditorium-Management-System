import 'package:audi/backend/backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init called');
  }

  @override
  Widget build(BuildContext context) {
    print("Build method called");
    Auth auth = Auth();
    User? user = FirebaseAuth.instance.currentUser;
    String? usser = user?.email;
    TextEditingController data1 = TextEditingController();
    TextEditingController data2 = TextEditingController();
    TextEditingController data3 = TextEditingController();
    FirebaseFirestore fire = FirebaseFirestore.instance;
    CollectionReference collection = fire.collection('sampleData');
    void getDataStream() async {
      print("Getting all data");
      await for (var snapShot in fire.collection('sampleData').snapshots()) {
        for (var _doc in snapShot.docs) {
          print(_doc.data());
        }
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                stream: fire.collection('sampleData').snapshots(),
                  builder: (context, snapshot){
                      if(snapshot.hasData){
                          final messages = snapshot.data!.docs;
                          List<Card> card = [];
                          for(var message in messages){
                            card.add(
                              Card(
                                color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(message.data()['name'].toString(), style: const TextStyle(fontSize: 18),),
                                    Text(message.data()['roll no'].toString(), ),
                                    Text(message.data()['cgpa'].toString(),),
                                    GestureDetector(onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(message: message)));
                                      print(message.reference.id);
                                      } ,child: const Icon(Icons.edit)),
                                    GestureDetector(child: const Icon(Icons.delete), onTap: (){
                                      print(message.reference.id);
                                      print("deleting data");
                                      fire.collection('sampleData').doc(message.reference.id).delete();
                                      print("deleted finally");
                                    },),
                                  ],
                                ),
                              )
                            );
                          }
                          return ListView(
                            children: card,
                          );
                      }
                      return const Center(
                        child: CircularProgressIndicator( backgroundColor: Colors.blueAccent,),
                      );
                  }
    ),
              ),
              TextField(
                controller: data1,
                onChanged: (value) {
                  data1.text = value;
                },
              ),
              TextField(
                controller: data2,
                onChanged: (value) {
                  data2.text = value;
                },
              ),
              TextField(
                controller: data3,
                onChanged: (value) {
                  data3.text = value;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    print("data is sending");
                    try {
                      await fire
                          .collection('sampleData')
                          .add({"name": data1.text, "roll no": data2.text, "cgpa": data3.text});
                      print("data sent");
                    } catch (e) {
                      print(e);
                    }
                    print("$data1 $data2 $data3");
                  },
                  child: const Text("Send/Create Data")),
              ElevatedButton(
                onPressed: () {
                  getDataStream();
                },
                child: const Text("Get Data"),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text("Sign out of $usser"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



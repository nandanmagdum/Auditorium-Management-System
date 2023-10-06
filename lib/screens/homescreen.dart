import 'package:audi/backend/backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_api/backend.dart';
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
    late String data1 = "default";
    late String data2 = "default";
    late String data3 = "default";
    FirebaseFirestore _fire = FirebaseFirestore.instance;
    CollectionReference _collection = _fire.collection('sampleData');
    void getDataStream() async {
      print("Getting all data");
      await for (var snapShot in _fire.collection('sampleData').snapshots()) {
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
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                stream: _fire.collection('sampleData').snapshots(),
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
                                    Text(message.data()['name'].toString(), style: TextStyle(fontSize: 18),),
                                    Text(message.data()['roll no'].toString(), ),
                                    Text(message.data()['cgpa'].toString(),),
                                    GestureDetector(onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(message: message)));
                                      print(message.reference.id);
                                      } ,child: Icon(Icons.edit)),
                                    GestureDetector(child: Icon(Icons.delete), onTap: (){
                                      print(message.reference.id);
                                      print("deleting data");
                                      _fire.collection('sampleData').doc(message.reference.id).delete();
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
                      return Center(
                        child: CircularProgressIndicator( backgroundColor: Colors.blueAccent,),
                      );
                  }
    ),
              ),
              TextField(
                onChanged: (value) {
                  data1 = value;
                },
              ),
              TextField(
                onChanged: (value) {
                  data2 = value;
                },
              ),
              TextField(
                onChanged: (value) {
                  data3 = value;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    print("data is sending");
                    try {
                      await _fire
                          .collection('sampleData')
                          .add({"name": data1 != null? data1 : 'value is null', "roll no": data2 != null ? data2 : 'value is null', "cgpa": data3 != null? data3: 'value is null'});
                      print("data sent");
                    } catch (e) {
                      print(e);
                    }
                    print("${data1} ${data2} ${data3}");
                  },
                  child: Text("Send/Create Data")),
              ElevatedButton(
                onPressed: () {
                  getDataStream();
                },
                child: Text("Get Data"),
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



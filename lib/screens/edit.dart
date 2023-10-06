import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EditScreen extends StatefulWidget {
  final message;
  EditScreen({super.key, required this.message});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    String? data1, data2, data3;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit details for " + widget.message.data()['name']),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              SizedBox(width: MediaQuery.of(context).size.width,),
              TextField(
                onChanged: (value){
                  data1 = value;
                },
              ),
              TextField(
                onChanged: (value){
                  data2 = value;
                },
              ),
              TextField(
                onChanged: (value){
                  data3 = value;
                },
              ),
          ElevatedButton(onPressed: () async{
            try{
              await FirebaseFirestore.instance.collection('sampleData').doc(widget.message.reference.id).update({
                'name': data1,
                'roll no': data2,
                'cgpa': data3
              });
              Navigator.pop(context);
              print("$data1 $data2 $data3");
            } catch(e){
              print(e);
            }
          }, child: Text("Edit data"),),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel"),),
        ],
      ),
    );
  }
}

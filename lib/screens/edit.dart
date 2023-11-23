import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EditScreen extends StatefulWidget {
  final message;
  const EditScreen({super.key, required this.message});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController data1 = TextEditingController(text: widget.message.data()['name']);
    TextEditingController data2 = TextEditingController(text: widget.message.data()['roll no']);
    TextEditingController data3 = TextEditingController(text: widget.message.data()['cgpa']);
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
                controller: data1,
                onChanged: (value){
                  data1.text = value;
                },
              ),
              TextField(
                controller: data2,
                onChanged: (value){
                  data2.text = value;
                },
              ),
              TextField(
                controller: data3,
                onChanged: (value){
                  data3.text = value;
                },
              ),
          ElevatedButton(onPressed: () async{
            try{
              await FirebaseFirestore.instance.collection('sampleData').doc(widget.message.reference.id).update({
                'name': data1.text,
                'roll no': data2.text,
                'cgpa': data3.text
              });
              Navigator.pop(context);
              // print("$data1 $data2 $data3");
            } catch(e){
              // print(e);
            }
          }, child: const Text("Edit data"),),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel"),),
        ],
      ),
    );
  }
}

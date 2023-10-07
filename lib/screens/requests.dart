import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Requested Time Slots',
          style: TextStyle(color: Color(0xFF222B45)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD9D9D9),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('requestedEvents').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final messages = snapshot.data!.docs;
              List<Card> card = [];
              for(var message in messages){
                card.add(
                    Card(
                      color: Colors.grey,
                      child: Column(
                        children: [
                          Text("${message.data()['startTime'].toString()} - ${message.data()['endTime'].toString()}"),
                          Text(message.data()['eventName'].toString(), style: TextStyle(fontSize: 25),),
                          Text(message.data()['organizer'].toString(), ),
                          Text(message.data()['date'].toString(),),
                          // GestureDetector(onTap: (){
                          //
                          //   print(message.reference.id);
                          // } ,child: Icon(Icons.edit)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: (){}, child: Text("Accept"),),
                              SizedBox(width: 10,),
                              ElevatedButton(onPressed: (){}, child: Text("Reject")),
                              SizedBox(width: 10,),
                              // GestureDetector(child: Icon(Icons.delete), onTap: (){
                              //   print(message.reference.id);
                              //   print("deleting data");
                              //   FirebaseFirestore.instance.collection('requestedEvents').doc(message.reference.id).delete();
                              //   print("deleted finally");
                              // },),
                            ],
                          ),

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
    );
  }
}

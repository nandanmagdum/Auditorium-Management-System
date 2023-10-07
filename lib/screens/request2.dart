
import 'package:audi/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Requests2 extends StatefulWidget {
  const Requests2({super.key});

  @override
  State<Requests2> createState() => _RequestsState();
}

class _RequestsState extends State<Requests2> {
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
              List<Padding> newCard = [];
              for(var message in messages){
                newCard.add(Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Container(
                    height: 165,
                    width: 350,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Colors.black26,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 0.1,
                              blurRadius: 5.0,
                              offset: Offset(0, 0))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16.0,
                                height: 16.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getRandomColor(),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "${message.data()['startTime'].toString()}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "${message.data()['eventName'].toString()}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "${message.data()['description'].toString()}",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(onPressed: (){}, child: Text("Accept",), style: ElevatedButton.styleFrom(primary: Colors.green),),
                              ElevatedButton(onPressed: () async{
                                            try{
                                              await FirebaseFirestore.instance.collection('requestedEvents').doc(message.reference.id).delete();
                                            } catch(e){
                                              print(e);
                                            }
                              }, child: Text("Reject"),style: ElevatedButton.styleFrom(primary: Colors.red),),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                );
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
                children: newCard,
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



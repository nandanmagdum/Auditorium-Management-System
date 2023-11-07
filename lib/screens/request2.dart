
import 'package:audi/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
          'Pending Requests',
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
                    height: 170,
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
                              Row(
                                children: [
                                  Text(
                                    "${message.data()['startTime'].toString()}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(" - "),
                                  Text(
                                    "${message.data()['endTime'].toString()}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
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
                          Text(
                            "${message.data()['organizer'].toString()}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          // Text(
                          //   "${message.data()['description']}",
                          //   style: TextStyle(
                          //     fontSize: 12.0,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(onPressed: (){
                                showModalBottomSheet(context: context,
                                    builder: (builder){
                                      return Scaffold(
                                        backgroundColor: Colors.white10,
                                        appBar: AppBar(backgroundColor: Colors.white10,title: Text("Event Details"),centerTitle: true,),
                                        body: Container(
                                          height: MediaQuery.of(context).size.height,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50.0),
                                              topRight: Radius.circular(50.0),
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                children:
                                                [
                                                  SizedBox(height: 20,),
                                                  Text("Event: ${message.data()['eventName'].toString()}", style: TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                                  SizedBox(height: 10,),
                                                  Text("Organizer: ${message.data()['organizer']}", style: TextStyle(fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start,),
                                                  SizedBox(height: 10,),
                                                  Text("Date: ${date_parse(message.data()['date'].toString())}", style: TextStyle(fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("Time:  ", style: TextStyle(fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start),
                                                      Text("${message.data()['startTime'].toString()}  to  ", style: TextStyle(fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start),
                                                      Text("${message.data()['endTime'].toString()}", style: TextStyle(fontSize: 26, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Text("Event Desciption: ", style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start),
                                                  SizedBox(height: 10,),
                                                  Text("${message.data()['description'].toString()}", style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500,), textAlign: TextAlign.start),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                                  child: Text("View details")),
                              ElevatedButton(onPressed: () async{
                                  try{
                                    print("Data is sending");
                                    await FirebaseFirestore.instance.collection('finalEvents').add({
                                      'eventName': message.data()['eventName'],
                                      'organizer' :message.data()['organizer'],
                                      'description': message.data()['description'],
                                      'date': message.data()['date'],
                                      'startTime': message.data()['startTime'],
                                      'endTime': message.data()['endTime'],
                                      'category': message.data()['category'],
                                    });
                                    print("data sent");
                                    await FirebaseFirestore.instance.collection('requestedEvents').doc(message.reference.id).delete();
                                  }catch(e){
                                    print(e);
                                  }
                              }, child: Text("Accept",), style: ElevatedButton.styleFrom(primary: Colors.green),),
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



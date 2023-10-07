
import 'package:audi/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FinalSlots extends StatefulWidget {
  const FinalSlots({super.key});

  @override
  State<FinalSlots> createState() => _FinalSlotsState();
}

class _FinalSlotsState extends State<FinalSlots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          'Booked Slots',
          style: TextStyle(color: Color(0xFF222B45)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD9D9D9),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('finalEvents').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final messages = snapshot.data!.docs;
              List<Padding> newCard = [];
              for(var message in messages){
                newCard.add(Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Container(
                    height: 125,
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



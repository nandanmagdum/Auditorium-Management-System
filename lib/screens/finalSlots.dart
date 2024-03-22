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
        title: const Text(
          'Booked Slots',
          style: TextStyle(color: Color(0xFF222B45)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD9D9D9),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('finalEvents')
            .orderBy('datetime_start')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // print('aasdadsad');
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs;
          List<Padding> card = [];
          for (var message in messages) {
            int comparisonResult =
                DateTime.parse(message.data()['date'] + " 00:00:00")
                    .compareTo(DateTime.now());
            {
              card.add(
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Colors.black26,
                          width: 2,
                        ),
                        boxShadow: const [
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
                              const SizedBox(width: 8.0),
                              Row(
                                children: [
                                  Text(
                                    message.data()['startTime'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Text("  -  "),
                                  Text(
                                    message.data()['endTime'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Date: ${date_parse(message.data()['date'].toString())}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "Event: ${message.data()['eventName'].toString()}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "Organizer: ${message.data()['organizer'].toString()}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250,
                                height: 30,
                                child: Text(
                                  message.data()['description'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (builder) {
                                          return Scaffold(
                                            backgroundColor: Colors.white10,
                                            appBar: AppBar(
                                              backgroundColor: Colors.white10,
                                              title:
                                                  const Text("Event Details"),
                                              centerTitle: true,
                                            ),
                                            body: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(50.0),
                                                  topRight:
                                                      Radius.circular(50.0),
                                                ),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Event: ${message.data()['eventName'].toString()}",
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Organizer: ${message.data()['organizer']}",
                                                        style: const TextStyle(
                                                          fontSize: 26,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          "Date: ${date_parse(message.data()['date'].toString())}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 26,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text("Time:  ",
                                                              style: TextStyle(
                                                                fontSize: 26,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          Text(
                                                              "${message.data()['startTime'].toString()}  to  ",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 26,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                          Text(
                                                              message
                                                                  .data()[
                                                                      'endTime']
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 26,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Text(
                                                          "Event Description: ",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.start),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Text(
                                                            message
                                                                .data()[
                                                                    'description']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .start),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: const Text("View More")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          if (card.isEmpty) {
            return const Center(
                child: Text(
              "There are no upcomming events\n stay tuned",
              style: TextStyle(fontSize: 20),
            ));
          }
          return ListView(
            children: card,
          );
        },
      ),
    );
  }
}

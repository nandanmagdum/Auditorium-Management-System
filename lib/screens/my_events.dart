import 'package:audi/backend/emails.dart';
import 'package:audi/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => MyEventsState();
}

class MyEventsState extends State<MyEvents> {
  List<String> GLOBAL_AUDIENCE = [];
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .get();

      List<String> strings = querySnapshot.docs
          .map((doc) =>
              doc.get('email') as String) // Replace with your field name
          .toList();

      setState(() {
        GLOBAL_AUDIENCE = strings;
      });
      print("Global audience fetched");
      print(":::::::::::::::::::::::::::::::::::::::::${GLOBAL_AUDIENCE}");
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: const Text(
          'Your Events',
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
              .where('requested_by',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final messages = snapshot.data!.docs;
              List<Card> card = [];
              List<Padding> newCard = [];
              for (var message in messages) {
                newCard.add(
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Container(
                      height: 170,
                      width: 350,
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
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Text(" - "),
                                    Text(
                                      message.data()['endTime'].toString(),
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              message.data()['eventName'].toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              message.data()['organizer'].toString(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8.0),
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
                                ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder) {
                                            return Scaffold(
                                              backgroundColor: Colors.white10,
                                              appBar: AppBar(
                                                backgroundColor:
                                                    Color(0xFFD9D9D9),
                                                title: const Text(
                                                    "Event Details",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                centerTitle: true,
                                              ),
                                              body: Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(50.0),
                                                    topRight:
                                                        Radius.circular(50.0),
                                                  ),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Organizer: ${message.data()['organizer']}",
                                                          style:
                                                              const TextStyle(
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .start),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                "Time:  ",
                                                                style:
                                                                    TextStyle(
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .start),
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
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Text(
                                                              message
                                                                  .data()[
                                                                      'description']
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
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
                                    child: const Text("View details")),
                                SizedBox(
                                  width: 5,
                                ),

                                // datetime_end
                                if (message
                                    .data()['datetime_end']
                                    .toDate()
                                    .isAfter(DateTime.now()))
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        List<String> audience = GLOBAL_AUDIENCE;
                                        String emailBody =
                                            "Upcoming NEW EVENT AT GCEK AUDITORIUM !\n\n"
                                            "Event : ${message.data()['eventName']}\n"
                                            "Organizer : ${message.data()['organizer']}\n"
                                            "Date of Event : ${date_parse(message.data()['date'])}\n"
                                            "Description : ${message.data()['description']}\n"
                                            "Time: ${message.data()['startTime']}\n";
                                        EMailNotifications.sendEmail_TO_ALL(
                                            emailBody, audience);
                                        await FirebaseFirestore.instance
                                            .collection('requestedEvents')
                                            .doc(message.reference.id)
                                            .delete();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                              "Email Notification Sent !\nYou can send again after 10 minutes"),
                                        ));
                                        setState(() {});
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Error: ${e}")));
                                      }
                                    },
                                    child: const Text(
                                      "Send Notification",
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (newCard.length == 0) {
                return Center(
                  child: Text("You don't have any Events Yet"),
                );
              }
              return ListView(
                children: newCard,
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }),
    );
  }
}

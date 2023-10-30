import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'package:audi/screens/Event_screen.dart';
import 'package:audi/screens/const.dart';
import 'package:audi/screens/request2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'finalSlots.dart';
import 'Event_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

EventList<Event> getEventDates() {
  EventList<Event> eventDates = EventList<Event>(events: {});

  // Replace this with your logic to fetch event data from Firestore or any other source
  // For this example, I'm adding some dummy data

  StreamBuilder(
      stream: FirebaseFirestore.instance.collection('finalEvents').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final messages = snapshot.data!.docs;
          List<Padding> newCard = [];
          for(var message in messages){
            print('${message['date'].substring(0, 4)} ${message['date'].substring(5, 7)}  ${message['date'].substring(8, 10)}');
            eventDates.add(DateTime(message['date'].substring(0, 4), message['date'].substring(5, 7), message['date'].substring(8, 10)), Event(
              date: DateTime(2023, 10, 31),
              icon: _getEventIcon(1),
              dot: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                color: Colors.blue,
                width: 4.0,
                height: 4.0,
              ),
            ));
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
  );

  eventDates.add(
    DateTime(2023, 11, 10),
    Event(
      date: DateTime(2023, 11, 10),
      icon: _getEventIcon(2),
      dot: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.0),
        color: Colors.green, // Color of the dot
        width: 4.0,
        height: 4.0,
      ),
    ),
  );

  return eventDates;
}

// Define a function to return an icon based on the event count
Widget _getEventIcon(int eventCount) {
  // Customize this function to return an icon or widget based on your design
  return Icon(Icons.circle);
}


Color getRandomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red value (0-255)
    random.nextInt(256), // Green value (0-255)
    random.nextInt(256), // Blue value (0-255)
    1.0, // Alpha value (1.0 for fully opaque)
  );
}
enum Role {
  admin,
  professor,
  student,
  _null
}
Future<String> getUserEmail() async{
  final email = await FirebaseAuth.instance.currentUser!.email.toString();
  return email;
}

// Future<bool> hasRole(Role role) async{
//   final currentUserRole = await getUserRole();
//   return currentUserRole == role;
// }
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var role;
  var _userRole ;
  var _user_email;
  Future<void> initilizeData() async{
    _user_email = await getUserEmail();
    role = await getUserRole(_user_email.toString());
    _userRole = await getUserRole(_user_email.toString());
  }
  Future<String> getUserRole(String email) async {
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(email).get();
    setState(() {
      _userRole = userSnapshot['role'];
    });
    return userSnapshot['role'];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilizeData();
    getEventDates();
  }
  DateTime selectedDate = DateTime.now();
  String? strSelectedDate = DateTime.now().toString().substring(0, 10);
  @override
  Widget build(BuildContext context) {
    print(selectedDate);
    print(strSelectedDate);
    // print(strSelectedDate);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF22223b)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 40,
                    ),
                    title: Text("username"),
                    subtitle:
                        Text(FirebaseAuth.instance.currentUser!.email.toString()
                            // 'atharvc2022@gmail.com',
                            ),
                    // trailing: Icon(Icons.phone),

                    iconColor: Colors.white54,
                    textColor: Colors.white,
                  )),
              (_userRole == 'admin')? ListTile(
                leading: const Icon(Icons.add_alert_outlined),
                title: const Text('Auditorium Requests'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Requests2()));
                },
              ):ListTile(),
              ListTile(
                leading: const Icon(Icons.add_alert_outlined),
                title: const Text('Booked Slots'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FinalSlots()));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text('User Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 65,
          title: Text(
            'GCEK Auditorium',
            style: TextStyle(color: Color(0xFF222B45)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFD9D9D9),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
        body: SafeArea(
          child: Container(
            color: Color(0xFFFAF9F9),
            child: Column(
              children: [
                // Text(_userRole.toString()),
                // Container(
                //   height: 40,
                //   child: StreamBuilder(
                //       stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email.toString()).snapshots(),
                //       builder: (context, snapshot){
                //         if(!snapshot.hasData){
                //           return CircularProgressIndicator();
                //         }
                //         final user = snapshot.data!.docs;
                //         List<Text> card = [];
                //         for(var u in user){
                //           var role = u.data()['role'].toString();
                //           print(role);
                //           card.add(
                //             Text('${u.data()['email'].toString()} is ${u.data()['role'].toString()}', style: TextStyle(fontSize: 20, color: Colors.black),)
                //           );
                //         }
                //         return ListView(
                //           children: card,
                //         );
                //       }),
                // ),
                Flexible(
                  child: CalendarCarousel(
                    onDayPressed: (DateTime date, List<EventInterface> events) {
                      setState(() {
                        selectedDate = date;
                        strSelectedDate = selectedDate.toString().substring(0, 10);
                      });
                    },
                    ///////////////////////////////
                    markedDatesMap: getEventDates(),
                    //////////////////////////////
                    selectedDateTime: selectedDate,
                    childAspectRatio: 1.2,
                    todayButtonColor: Color(0xFF735BF2),
                    markedDateIconBorderColor: Colors.amber,
                    leftButtonIcon: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 3, // Blur radius
                            offset: Offset(0, 0), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.black, // Icon color
                      ),
                    ),
                    rightButtonIcon: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.black,
                      ),
                    ),
                    todayTextStyle:
                        TextStyle(backgroundColor: Color(0xFF735BF2)),
                    weekdayTextStyle: TextStyle(color: Color(0xFF8F9BB3)),
                    // weekDayFormat: WeekdayFormat.short,
                    headerTextStyle: TextStyle(color: Colors.black),
                    markedDateWidget: Container(
                      color: Colors.amber,
                      height: 10,
                      width: 10,
                    ),
                  ),
                ),
                Divider(endIndent: 15, indent: 15),
                Flexible(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        stops: [0.0, 0.15],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.white10, Colors.white],
                      ).createShader(bounds);
                    },
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('finalEvents')
                          .where('date', isEqualTo: strSelectedDate)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          print('aasdadsad');
                          return Text("No data");
                        }
                        final messages = snapshot.data!.docs;
                        List<Padding> card = [];
                        for (var message in messages) {
                          card.add(
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0),
                              child: Container(
                                height: 155,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              Text("  -  "),
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
                        if(card.length == 0) {
                          return Center(child: Text("No event for today", style: TextStyle(fontSize: 20),));
                        }
                        return ListView(
                          children: card,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
          floatingActionButton: (_userRole == 'student')? null: ElevatedButton(
          onPressed: () {
            print(role);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EventPage()));
            print("Book a slot");
          },
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class user{
  String email;
  String role;
  user({required this.email, required this.role});
}

// class EventData {
//   final String timeRange;
//   final String eventName;
//   final String eventDescription;
//   final Color dotColor;
//
//   EventData({
//     required this.timeRange,
//     required this.eventName,
//     required this.eventDescription,
//     required this.dotColor,
//   });
// }
//
// class EventCard extends StatelessWidget {
//   final EventData eventData;
//
//   EventCard({required this.eventData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
//       child: Container(
//         height: 115,
//         width: 350,
//         margin: EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20.0),
//             border: Border.all(
//               color: Colors.black26,
//               width: 2,
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black45,
//                   spreadRadius: 0.1,
//                   blurRadius: 5.0,
//                   offset: Offset(0, 0))
//             ]),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 16.0,
//                     height: 16.0,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: eventData.dotColor,
//                     ),
//                   ),
//                   SizedBox(width: 8.0),
//                   Text(
//                     eventData.timeRange,
//                     style: TextStyle(
//                       fontSize: 12.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 eventData.eventName,
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 eventData.eventDescription,
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

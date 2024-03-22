import 'package:flutter/material.dart';
import 'Constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:audi/backend/clash.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Timestamp> global_events_start = [];
  List<Timestamp> global_events_end = [];
  Future<void> fillGlobalEvents() async {
    print("fill global events called ");
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('finalEvents') // Replace with your collection name
          .get();
      print("1");
      List<Timestamp> strings_start = querySnapshot.docs
          .map((doc) => doc.get('datetime_start')
              as Timestamp) // Replace with your field name
          .toList();
      print("2");
      List<Timestamp> strings_end = querySnapshot.docs
          .map((doc) => doc.get('datetime_end') as Timestamp)
          .toList();
      print("3");
      // global_events_start = querySnapshot.docs
      //     .map((doc) => doc.get('datetime_start').toDate()) // Convert Timestamp to DateTime
      //     .toList();
      // global_events_end = querySnapshot.docs
      //     .map((doc) => doc.get('datetime_end').toDate()) // Convert Timestamp to DateTime
      //     .toList();
      // setState(() {
      global_events_start = strings_start;
      global_events_end = strings_end;
      // });
      print("Printing datetime lists");
      print(global_events_start);
      print(global_events_end);
      print("Fill data funtion completed succesfully !! :-)");
      print(global_events_start.length);
      print(global_events_end.length);
    } catch (e) {
      print("Serious error : ");
      print('Error fetching data: $e');
    }
  }

  bool isSlotAvailable(List<Timestamp> starting, List<Timestamp> ending,
      Timestamp s, Timestamp e) {
    print("isSlotAvailable funtion called");
    int n = starting.length;
    int m = ending.length;
    print(n);
    print(m);
    for (var i = 0; i < n; i++) {
      print("${starting[i]}  - ${ending[i]}  -- ${s} - ${e}");
      int c1 = starting[i].compareTo(s);
      int c2 = starting[i].compareTo(e);
      int c3 = ending[i].compareTo(s);
      int c4 = ending[i].compareTo(e);
      if (c2 == 0 || c3 == 0) return true;
      if ((c1 >= 0 && c1 <= 0) || (c4 >= 0 && c4 <= 0)) {
        // If the start or end time of the current event is equal to the start or end time of any existing event
        return false;
      } else if ((c1 <= 0 && c4 >= 0) || (c1 >= 0 && c4 <= 0)) {
        // If the current event completely overlaps with an existing event or vice versa
        return false;
      } else if ((c1 >= 0 && c3 <= 0) || (c2 >= 0 && c4 <= 0)) {
        // If the start time of the current event is between the start and end time of an existing event
        return false;
      } else if ((c1 <= 0 && c3 >= 0) || (c2 <= 0 && c4 >= 0)) {
        // If the end time of the current event is between the start and end time of an existing event
        return false;
      }
    }
    print("returning true");
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state called");
    // TODO: get all event data here as List of objects
    fillGlobalEvents();
  }

  // function to send email
  void sendEmail(String emailBody) async {
    List<String> emails = [];
    String username = 'codinghero1234@gmail.com'; // Your email
    String password = 'rqdfitlbhzeyfbxb';
    final smtpServer = gmail(username, password);
    final documentsnapshots = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        print("admin email = ${doc.data()['email']}");
        emails.add(doc.data()['email']);
      }

      // send email
      print(emails);
      final message = Message()
        ..from = Address(username)
        ..recipients.addAll(emails)
        ..subject = 'GCEK Auditorium App Request'
        ..text = emailBody; // Body of the email
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } catch (e) {
        print(':::Error occurred: $e');
      }
    });

    // emails = [
    //   'nandanmagdum@gmail.com',
    //   'atharvc2022@gmail.com',
    //   'pujachavan789@gmail.com',
    //   'sachitbhor1@gmail.com',
    //   'nandanmagdum14@gmail.com',
    //   'omkargurav210@gmail.com',
    //   ''
    // ];
    // print(emails);
    // final message = Message()
    //   ..from = Address(username)
    //   ..recipients.addAll(emails)
    //   ..subject = 'GCEK Auditorium App Request'
    //   ..text = emailBody; // Body of the email
    // try {
    //   final sendReport = await send(message, smtpServer);
    //   print('Message sent: ' + sendReport.toString());
    // } catch (e) {
    //   print('Error occurred: $e');
    // }
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _timeController1 = TextEditingController();
  TextEditingController EventName = TextEditingController();
  TextEditingController Organizer = TextEditingController();
  TextEditingController EventDescription = TextEditingController();
  TextEditingController EventDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController Eventcategory = TextEditingController();

  final _catagory = [
    'TPO',
    'Placement drive',
    'Club Activity',
    'CIIS',
    'TEDX',
    'Others'
  ];
  String? _selectedValue = 'TPO';
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final auth = FirebaseAuth.instance.currentUser;
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final deviceOrientation = mediaQuery.orientation;
    // TextEditingController EventName = TextEditingController();
    // TextEditingController Organizer = TextEditingController();
    // TextEditingController EventDescription = TextEditingController();
    // TextEditingController EventDate = TextEditingController();
    // TextEditingController startTime = TextEditingController();
    // TextEditingController endTime = TextEditingController();
    // TextEditingController Eventcategory = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white38,
        title: const Text(
          'Add New Event',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: EventName,
                onChanged: (value) {
                  EventName.text = value;
                },
                style: const TextStyle(color: Colors.black),
                decoration: kBoxDecoration.copyWith(hintText: 'Event Name'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: Organizer,
                  onChanged: (value) {
                    Organizer.text = value;
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: kBoxDecoration.copyWith(hintText: 'Organizer')),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: EventDescription,
                minLines: 2,
                maxLines: null,
                onChanged: (value) {
                  EventDescription.text = value;
                },
                style: const TextStyle(color: Colors.black),
                decoration:
                    kBoxDecoration.copyWith(hintText: 'Event Description'),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (value) {
                  EventDate.text = value;
                },
                controller: _dateController,
                style: const TextStyle(color: Colors.black),
                decoration: kStartBoxDecoration.copyWith(
                  hintText: 'Date',
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _timeController.text = value;
                      },
                      controller: _timeController,
                      style: const TextStyle(color: Colors.black),
                      decoration: kStartBoxDecoration.copyWith(
                        hintText: 'Start',
                        suffixIcon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectTime();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      controller: _timeController1,
                      style: const TextStyle(color: Colors.black),
                      decoration: kStartBoxDecoration.copyWith(hintText: 'End'),
                      readOnly: true,
                      onTap: () {
                        _selectTime1();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Catagory',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  child: DropdownButtonFormField(
                    items: _catagory.map((e) {
                      return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedValue = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.grey,
                    ),
                    dropdownColor: Colors.white,
                    decoration: kBoxDecoration.copyWith(hintText: 'Choose'),
                  ),
                ),
              ),
              const SizedBox(
                height: 90.0,
              ),
              FutureBuilder(
                future: fillGlobalEvents(),
                builder: (context, snapshot) => (snapshot.connectionState ==
                        ConnectionState.waiting)
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Material(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(30.0),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () {
                              // Show CircularProgressIndicator
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 4),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Booking an Auditorium...'),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                ),
                              );

                              // Delay the next steps by 4 seconds using Future.delayed and then
                              Future.delayed(Duration(seconds: 2)).then((_) {
                                // Hide the SnackBar
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                // Verify that data is valid and add to Firestore
                                final starting = global_events_start;
                                final endingg = global_events_end;
                                DateTime event_start = convertDateTime(
                                    _dateController.text, _timeController.text);
                                DateTime event_end = convertDateTime(
                                    _dateController.text,
                                    _timeController1.text);
                                if (!isSlotAvailable(
                                    starting,
                                    endingg,
                                    Timestamp.fromDate(event_start),
                                    Timestamp.fromDate(event_end))) {
                                  print(
                                      "Events are clashing red alaert !!!!!!!!!!!!!!!");
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Event Clash Detected'),
                                      content: Text(
                                          'The requested event clashes with an existing booking. Please choose different event timings and check the calendar again for already booked events.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('requestedEvents')
                                        .add({
                                      'eventName': EventName.text,
                                      'organizer': Organizer.text,
                                      'description': EventDescription.text,
                                      'date': _dateController.text,
                                      'startTime': _timeController.text,
                                      'endTime': _timeController1.text,
                                      'category': _selectedValue,
                                      'datetime_start': convertDateTime(
                                          _dateController.text,
                                          _timeController.text),
                                      'datetime_end': convertDateTime(
                                          _dateController.text,
                                          _timeController1.text),
                                      'requested_by': auth!.email,
                                      'requested_datetime': DateTime.now(),
                                    });
                                    String emailBody =
                                        "${auth!.email} is requesting to access Auditorium Slot\nEvent Details are: \n"
                                        "Event Name: ${EventName.text}\n"
                                        "Organizer : ${Organizer.text}\n"
                                        "Event Description : ${EventDescription.text}\n"
                                        "Date of request : ${_dateController.text}\n"
                                        "Start Time : ${_timeController.text}\n"
                                        "End Time: ${_timeController1.text}\n"
                                        "To Accept/Reject the slot request from the App\n"
                                        "Go to GCEK Auditorium App -> Auditorium Requestes\n";

                                    sendEmail(emailBody);
                                    // Navigate to the next page after 4 seconds
                                    // Future.delayed(Duration(seconds: 0)).then((_) {
                                    Navigator.pop(context);
                                    // });
                                  } catch (e) {
                                    // print(e);
                                  }
                                }

                                // print(EventName.text);
                                // print(Organizer.text);
                                // print(EventDescription.text);
                                // print(_dateController.text);
                                // print(_timeController.text);
                                // print(_timeController1.text);
                                // print(_selectedValue);
                              });
                            },
                            minWidth: double.infinity,
                            height: 50.0,
                            child: const Text('Book an Auditorium'),
                          ),

                          // child: MaterialButton(
                          //   onPressed: () async{
                          //     ///////////////
                          //     // verify that data is valid
                          //     //////////////
                          //     try{
                          //       await FirebaseFirestore.instance.collection('requestedEvents').add({
                          //         'eventName' : EventName.text,
                          //         'organizer': Organizer.text,
                          //         'description': EventDescription.text,
                          //         'date': _dateController.text,
                          //         'startTime': _timeController.text,
                          //         'endTime': _timeController1.text,
                          //         'category': _selectedValue,
                          //         'datetime_start': convertDateTime(_dateController.text, _timeController.text),
                          //         'datetime_end': convertDateTime(_dateController.text, _timeController1.text),
                          //         'requested_by': auth!.email,
                          //         'requested_datetime': DateTime.now(),
                          //       });
                          //       Navigator.pop(context);
                          //     } catch(e){
                          //       print(e);
                          //     }
                          //     print(EventName.text);
                          //     print(Organizer.text);
                          //     print(EventDescription.text);
                          //     print(_dateController.text);
                          //     print(_timeController.text);
                          //     print(_timeController1.text);
                          //     print(_selectedValue);
                          //   },
                          //   minWidth: double.infinity,
                          //   height: 50.0,
                          //   child: const Text('Book an Auditorium'),
                          // ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _selectTime1() async {
    final TimeOfDay? picked1 =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked1 != null) {
      setState(() {
        _timeController1.text = picked1.format(context);
      });
    }
  }
}

DateTime convertDateTime(String date, String time) {
  // print(date);
  // print(time);
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(5, 7));
  int day = int.parse(date.substring(8, 10));
  int hour;
  int minute;
  if (time.length == 7) {
    if (time.substring(5, 7) == "AM") {
      hour = int.parse(time.substring(0, 1));
      minute = int.parse(time.substring(2, 4));
    } else {
      hour = int.parse(time.substring(0, 1)) + 12;
      minute = int.parse(time.substring(2, 4));
    }
  } else {
    if (time.substring(6, 8) == "AM") {
      hour = int.parse(time.substring(0, 2));
      minute = int.parse(time.substring(3, 5));
    } else {
      hour = int.parse(time.substring(0, 2)) + 12;
      minute = int.parse(time.substring(3, 5));
    }
  }
  return DateTime(year, month, day, hour, minute);
}

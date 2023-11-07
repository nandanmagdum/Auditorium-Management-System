import 'package:flutter/material.dart';
import 'Constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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
                  suffixIcon: Icon(
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
                        suffixIcon: Icon(
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
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Catagory',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  child: DropdownButtonFormField(
                    items: _catagory.map((e) {
                      return DropdownMenuItem(
                          child: Text(
                            e,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: e);
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
              SizedBox(
                height: 90.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Material(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async{
                      ///////////////
                      // verfy that data is valid
                      /////////////
                      try{
                        await FirebaseFirestore.instance.collection('requestedEvents').add({
                          'eventName' : EventName.text,
                          'organizer': Organizer.text,
                          'description': EventDescription.text,
                          'date': _dateController.text,
                          'startTime': _timeController.text,
                          'endTime': _timeController1.text,
                          'category': _selectedValue
                        });
                        Navigator.pop(context);
                      } catch(e){
                        print(e);
                      }
                      print(EventName.text);
                      print(Organizer.text);
                      print(EventDescription.text);
                      print(_dateController.text);
                      print(_timeController.text);
                      print(_timeController1.text);
                      print(_selectedValue);

                    },
                    child: Text('Book an Auditorium'),
                    minWidth: double.infinity,
                    height: 50.0,
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

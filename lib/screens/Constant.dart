import 'package:flutter/material.dart';

const kBoxDecoration = const InputDecoration(
    hintText: 'Event name',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    border: OutlineInputBorder(),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)));
const kStartBoxDecoration = const InputDecoration(
    hintText: 'Start',
    filled: true,
    suffixIcon: Icon(
      Icons.access_time_rounded,
      color: Colors.grey,
    ),
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    border: OutlineInputBorder(),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)));

import 'package:cloud_firestore/cloud_firestore.dart';

class EventHelper {
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
      if(c2 == 0 || c3 == 0) return true;
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
}

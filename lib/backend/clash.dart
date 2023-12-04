import 'package:cloud_firestore/cloud_firestore.dart';

class EventHelper {
  static Future<bool> isSlotAvailable(DateTime selectedStartDateTime, DateTime selectedEndDateTime) async {
    // Reference to the Firestore collection
    CollectionReference eventsCollection = FirebaseFirestore.instance.collection('finalEvents');

    // Query for events overlapping with the selected time range
    QuerySnapshot eventsSnapshot = await eventsCollection
        .where('datetime_start', isGreaterThan: selectedStartDateTime)
        .where('datetime_end', isLessThan: selectedEndDateTime)
        .get();

    // Check for clashes with each event
    for (QueryDocumentSnapshot eventSnapshot in eventsSnapshot.docs) {
      // Parse start and end times from Firestore document
      DateTime eventStartDateTime = DateTime.parse(eventSnapshot['datetime_start']);
      DateTime eventEndDateTime = DateTime.parse(eventSnapshot['datetime_end']);

      // Check for clashes
      if ((selectedStartDateTime.isAfter(eventStartDateTime) && selectedStartDateTime.isBefore(eventEndDateTime)) ||
          (selectedEndDateTime.isAfter(eventStartDateTime) && selectedEndDateTime.isBefore(eventEndDateTime)) ||
          (selectedStartDateTime.isAtSameMomentAs(eventStartDateTime) && selectedEndDateTime.isAtSameMomentAs(eventEndDateTime))) {
        // Clash found
        return false;
      }
    }

    // No clashes found
    return true;
  }
}

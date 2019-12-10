import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_webservice/geocoding.dart';
import 'package:haversine/haversine.dart';

class Item {
  final String id;
  final String creator;
  final Timestamp time;
  final int votes;

  Item({
    this.id,
    this.creator,
    this.time,
    this.votes = 0,
  });

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    GeoPoint gp = snapshot.data['location'];
    return Item(
      id: snapshot.documentID,
      creator: snapshot.data['creator'],
      time: snapshot.data['time'],
      votes: snapshot.data['votes'],
    );
  }

  Map<String, dynamic> toJson() => {
        "creator": creator,
        "time": time,
        "votes": votes,
      };

  String toStringTimeAgo() {
    int minDiffrence = time.toDate().difference(DateTime.now()).inMinutes.abs();
    if (minDiffrence < 60) return minDiffrence.toString() + "min ago";
    return "${weekdays[time.toDate().weekday - 1]} at " +
        (time.toDate().hour > 12
            ? "${time.toDate().hour - 12}"
            : time.toDate().hour == 0 ? "12" : "${time.toDate().hour}") +
        ":" +
        (time.toDate().minute > 9
            ? time.toDate().minute.toString()
            : "0" + time.toDate().minute.toString()) + (time.toDate().hour>12?"pm":"am");
  }

  static final List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
}

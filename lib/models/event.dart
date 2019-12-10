import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_webservice/geocoding.dart';
import 'package:haversine/haversine.dart';
import 'package:safe/models/item.dart';

class Event extends Item {
  final String name;
  final LatLng location;
  String humanReadableAddress = "";
  static final geocoding = new GoogleMapsGeocoding(
      apiKey: "AIzaSyCyF4o7IIX3kgVcC4MNfuM_CKl0ria9_Ro");

  Event({
    String id,
    this.name = "Default",
    String creator,
    this.location = const LatLng(37.43296265331129, -122.08832357078792),
    Timestamp time,
    int votes = 0,
    this.humanReadableAddress,
  }) : super(id: id, creator: creator, votes: votes, time: time);

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    GeoPoint gp = snapshot.data['location'];
    return Event(
      id: snapshot.documentID,
      name: snapshot.data['name'],
      creator: snapshot.data['creator'],
      time: snapshot.data['time'],
      location: LatLng(gp.latitude, gp.longitude),
      votes: snapshot.data['votes'],
      humanReadableAddress: snapshot.data['address'] ?? "",
    );
  }

  //WORKAROUND
  //Put on backend later
  Future<void> setAddress() async {
    if (humanReadableAddress.isEmpty) {
      var res = await geocoding
          .searchByLocation(Location(location.latitude, location.longitude));
      if (res.isOkay) humanReadableAddress = res.results[0].formattedAddress;
    }
    return;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "creator": creator,
        "location": GeoPoint(location.latitude, location.longitude),
        "time": time,
        "votes": votes,
        "address": humanReadableAddress,
      };

  double calculateDistance(LatLng target) {
    return Haversine.fromDegrees(
            latitude1: location.latitude,
            longitude1: location.longitude,
            latitude2: target.latitude,
            longitude2: target.longitude)
        .distance();
  }
}

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEvent extends Equatable {
  final String name;
  final LatLng location;
  CreateEvent({this.name, this.location}) : super([name, location]);
}
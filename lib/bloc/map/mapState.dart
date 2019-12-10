import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe/models/models.dart';

abstract class MapState extends Equatable {
  List<Event> events = List<Event>();
  MapState(this.events, [List props = const []]) : super((props + events));

  Set<Marker> eventsToMarkers(void Function(Event) onTap) {
    return events
        .map<Marker>((event) => Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(13),
              markerId: MarkerId(event.id),
              position: event.location,
              consumeTapEvents: true,
              onTap: () => onTap(event),
            ))
        .toSet();
  }
}

class MapInitial extends MapState {
  MapInitial() : super(List<Event>());

  @override
  String toString() => 'MapInitial';
}

class MapList extends MapState {
  MapList(List<Event> events) : super(events, events);

  @override
  String toString() => 'MapLoaded';
}

class MapItemSelected extends MapState{
  final Event selected;
  final List<Comment> comments;
  
  MapItemSelected(this.selected, [this.comments = const []]) : super([selected], comments.expand((c) => [c.id, c.content, c.votes]).toList());
}

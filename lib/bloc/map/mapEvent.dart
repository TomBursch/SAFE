import 'package:equatable/equatable.dart';
import 'package:safe/models/models.dart';

class MapEvent extends Equatable {
  MapEvent([List props = const []]) : super(props);
}

class MapUpdate extends MapEvent {
  final List<Event> eventList;
  final List<Comment> commentList;

  MapUpdate({this.eventList, this.commentList}) : super(eventList);
}

class MapSelect extends MapEvent {
  final String selectedId;

  MapSelect(this.selectedId) : super([selectedId]);
}

class MapUnSelect extends MapEvent {}

class MapVote extends MapEvent {
  final String id;
  final bool up;

  MapVote(this.id, this.up) : super([id, up]);
}

class MapCommentVote extends MapEvent {
  final String id;
  final bool up;

  MapCommentVote(this.id, this.up) : super([id, up]);
}

class MapCommentAdd extends MapEvent {
  final String content;

  MapCommentAdd(this.content) : super([content]);
}


import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/models/models.dart';
import 'bloc.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  get initialState => MapInitial();

  List<Event> _eventList = List<Event>();
  StreamSubscription _eventStreamSubscription;
  StreamSubscription _commentStreamSubscription;

  MapBloc() {
    dispatch(MapUnSelect());
    _eventStreamSubscription = Firestore.instance
        .collection('events')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((snapshots) async {
      dispatch(MapUpdate(eventList: await Future.wait<Event>(snapshots.documents
          .map<Future<Event>>((DocumentSnapshot snapshot) async {
        var e = Event.fromSnapshot(snapshot);
        await e.setAddress();
        return e;
      }))));
    });
  }

  Stream<MapState> mapEventToState(event) async* {
    if (event is MapUpdate) {
      _eventList = event.eventList ?? _eventList;
      if (currentState is MapItemSelected) {
        var id = (currentState as MapItemSelected).selected.id;
        var item =
            _eventList.firstWhere((item) => item.id == id, orElse: () => null);
        if (item != null) {
          yield MapItemSelected(item,
              event.commentList ?? (currentState as MapItemSelected).comments);
        } else {
          _commentStreamSubscription.cancel();
          yield MapList(_eventList);
        }
      } else
        yield MapList(_eventList);
    }
    if (event is MapUnSelect) {
      _commentStreamSubscription.cancel();
      yield MapList(_eventList);
    }
    if (event is MapSelect) {
      var item = _eventList.firstWhere((item) => item.id == event.selectedId,
          orElse: () => null);
      if (item != null) {
        yield MapItemSelected(item);
        if (_commentStreamSubscription != null)
          await _commentStreamSubscription.cancel();
        _commentStreamSubscription = Firestore.instance
            .collection('events')
            .document(item.id)
            .collection('comments')
            .orderBy("time", descending: true)
            .snapshots()
            .listen((snapshots) {
          dispatch(MapUpdate(
              commentList: snapshots.documents
                  .map<Comment>((DocumentSnapshot snapshot) =>
                      Comment.fromSnapshot(snapshot))
                  .toList()));
        });
      }
    }
    if (event is MapVote) {
      var temp = _eventList.firstWhere((item) => item.id == event.id,
          orElse: () => null);
      if (temp != null) {
        var docRef = Firestore.instance.collection('events').document(event.id);
        Firestore.instance.runTransaction((transaction) async {
          var doc = await docRef.get();
          if (!doc.exists) return;
          transaction.update(
              docRef, {'votes': doc.data['votes'] + (event.up ? 1 : -1)});
          return;
        });
      }
    }
    if (event is MapCommentVote) {
      var temp = _eventList.firstWhere(
          (item) => item.id == (currentState as MapItemSelected).selected.id,
          orElse: () => null);
      if (temp != null) {
        var docRef = Firestore.instance
            .collection('events')
            .document((currentState as MapItemSelected).selected.id)
            .collection('comments')
            .document(event.id);
        Firestore.instance.runTransaction((transaction) async {
          var doc = await docRef.get();
          if (!doc.exists) return;
          transaction.update(
              docRef, {'votes': doc.data['votes'] + (event.up ? 1 : -1)});
          return;
        });
      }
    }
    if (event is MapCommentAdd && currentState is MapItemSelected) {
      var user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        Firestore.instance
            .collection('events')
            .document((currentState as MapItemSelected).selected.id)
            .collection('comments')
            .add(Comment(
              content: event.content,
              time: Timestamp.now(),
              votes: 0,
              creator: user.uid,
            ).toJson());
      }
    }
  }

  @override
  void dispose() {
    _eventStreamSubscription.cancel();
    if (_commentStreamSubscription != null) _commentStreamSubscription.cancel();
    super.dispose();
  }
}

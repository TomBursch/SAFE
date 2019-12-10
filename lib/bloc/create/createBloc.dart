import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe/models/models.dart';
import 'bloc.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  get initialState => CreateInitial();

  Stream<CreateState> mapEventToState(event) async* {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Event eventModel = Event(
        creator: user.uid,
        name: event.name,
        location: event.location,
        time: Timestamp.now(),
      );
      await Firestore.instance.collection('/events').add(eventModel.toJson());
      if(true){
        yield CreateSuccess();
      }
    } else yield CreateFailure("Not logged in");    
  }
}

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  get initialState => HomeState(0);


  Stream<HomeState> mapEventToState(event) async* {
    yield HomeState(event.newPageIndex);
  }
}

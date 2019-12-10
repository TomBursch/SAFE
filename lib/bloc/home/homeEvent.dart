import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  final int newPageIndex;
  HomeEvent(this.newPageIndex) : super([newPageIndex]);
}
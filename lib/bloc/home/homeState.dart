import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int pageIndex;
  HomeState(this.pageIndex) : super([pageIndex]);
}

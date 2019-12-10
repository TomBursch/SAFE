import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/components/mapPanelList.dart';
import 'package:safe/components/mapPanelSelected.dart';

class MapPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapEvent, MapState>(
      bloc: BlocProvider.of<MapBloc>(context),
      builder: (context, state) {
        if (state is MapItemSelected) {
          return MapPanelSelected(
            event: state.selected,
            comments: state.comments,
          );
        }
        return MapPanelList(events: state.events);
      },
    );
  }
}

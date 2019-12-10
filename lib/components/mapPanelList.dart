import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/components/event.dart';
import 'package:safe/models/models.dart';

class MapPanelList extends StatelessWidget {
  final List<Event> events;

  const MapPanelList({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 12.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 70,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, i) {
              return EventWidget(
                event: events[i],
                onTap: () {
                  BlocProvider.of<MapBloc>(context)
                      .dispatch(MapSelect(events[i].id));
                },
              );
            },
          ),
        )
      ],
    );
  }
}

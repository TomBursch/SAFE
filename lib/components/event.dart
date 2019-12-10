import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/main.dart';
import 'package:safe/models/models.dart';
import 'package:safe/style/colors.dart';
import 'package:safe/style/styles.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final void Function() onTap;

  const EventWidget({Key key, @required this.event, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: SafeColors.darkCoral,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 8), blurRadius: 8, color: Colors.black26)
            ]),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "~${event.calculateDistance(SafeApp.lastLocation).round()}m - " +
                          event.toStringTimeAgo(),
                      style: SafeStyles.eventInfoText,
                    ),
                    FittedBox(
                      child: Text(
                        event.name,
                        textScaleFactor: 3,
                      ),
                    ),
                    Text(event.humanReadableAddress),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<MapBloc>(context).dispatch(MapVote(event.id, true));
                  },
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 45,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    event.votes.toString(),
                    textScaleFactor: 2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<MapBloc>(context).dispatch(MapVote(event.id, false));
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 45,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

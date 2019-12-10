import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/components/event.dart';
import 'package:safe/components/comment.dart';
import 'package:safe/models/models.dart';

class MapPanelSelected extends StatelessWidget {
  final Event event;
  final List<Comment> comments;

  const MapPanelSelected({Key key, this.event, @required this.comments})
      : super(key: key);

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
        ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          itemCount: 1 + comments.length,
          itemBuilder: (context, i) {
            if (i == 0)
              return EventWidget(
                event: event,
                onTap: () {
                  BlocProvider.of<MapBloc>(context).dispatch(MapUnSelect());
                },
              );
            i--;
            return CommentWidget(
              comment: comments[i],
            );
          },
        )
      ],
    );
  }
}

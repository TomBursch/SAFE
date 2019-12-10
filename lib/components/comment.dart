import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/models/models.dart';
import 'package:safe/style/colors.dart';
import 'package:safe/style/styles.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: SafeColors.darkCoral,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4), blurRadius: 8, color: Colors.black26)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: SafeColors.portlandOrange,
                    /*backgroundImage: CachedNetworkImageProvider(
                      comment.creatorUser.picture
                    ),*/
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          /*comment.creatorUser.name + " " +*/ comment.toStringTimeAgo(),
                          style: SafeStyles.eventInfoText,
                        ),
                        FittedBox(
                          child: Text(
                            comment.content,
                            textScaleFactor: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  BlocProvider.of<MapBloc>(context)
                      .dispatch(MapCommentVote(comment.id, true));
                },
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 45,
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  comment.votes.toString(),
                  textScaleFactor: 2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<MapBloc>(context)
                      .dispatch(MapCommentVote(comment.id, false));
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
    );
  }
}

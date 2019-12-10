import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/map/bloc.dart';
import 'package:safe/style/colors.dart';

class CommentAddWidget extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _commentController,
      decoration: InputDecoration(
        labelText: "Comment",
        hasFloatingPlaceholder: false,
        fillColor: SafeColors.darkCoral,
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            if (_commentController.text.isNotEmpty) {
              BlocProvider.of<MapBloc>(context)
                  .dispatch(MapCommentAdd(_commentController.text));
              _commentController.clear();
            }
          },
        ),
      ),
    );
  }
}

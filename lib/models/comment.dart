import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe/models/models.dart';

class Comment extends Item {
  final String content;
  final User creatorUser;

  Comment({
    String id,
    this.content = "Default",
    String creator,
    Timestamp time,
    int votes = 0,
    this.creatorUser,
  }) : super(id: id, creator: creator, time: time, votes: votes);

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    return Comment(
      id: snapshot.documentID,
      content: snapshot.data['content'],
      creator: snapshot.data['creator'],
      time: snapshot.data['time'],
      votes: snapshot.data['votes'],
    );
  }
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'content': content,
      });
  }
}

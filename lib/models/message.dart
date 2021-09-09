import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String userId;
  final String text;
  final String userImage;
  final String username;
  final Timestamp createdAt;

  Message(
      {this.id,
      required this.createdAt,
      required this.userId,
      required this.text,
      required this.userImage,
      required this.username});

  Message.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          userId: json['userId']! as String,
          text: json['text']! as String,
          userImage: json['userImage']! as String,
          username: json['username']! as String,
          createdAt: json['createdAt'] as Timestamp,
        );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'text': text,
      'userImage': userImage,
      'username': username,
      'createdAt': createdAt,
    };
  }
}

import 'package:chat_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class MessageViewModel with ChangeNotifier {
  bool _busy = false;
  CurrentUser currentUser;

  MessageViewModel(this.currentUser);

  final _chatsRef = FirebaseFirestore.instance
      .collection('chats')
      .withConverter<Message>(
          fromFirestore: (snapshot, _) =>
              Message.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (message, _) => message.toJson());

  Stream<List<Message>> getMessageStream() {
    Stream<QuerySnapshot<Message>> stream =
        _chatsRef.orderBy('createdAt', descending: true).snapshots();

    return stream.map((querySnapshots) =>
        querySnapshots.docs.map((doc) => doc.data()).toList());
  }

  void sendMessage(String message) async {
    _chatsRef.add(
      Message(
        userId: currentUser.userId!,
        text: message,
        userImage: currentUser.imageUrl,
        username: currentUser.username,
        createdAt: Timestamp.now(),
      ),
    );
  }

  void turnBusy() {
    _busy = true;
  }

  void turnIdle() {
    _busy = false;
    notifyListeners();
  }
}

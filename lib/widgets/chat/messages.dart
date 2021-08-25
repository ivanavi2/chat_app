import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        //! = null assertion operator (treat as non-nullable)
        final chatsRef = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatsRef.length,
          itemBuilder: (context, index) {
            return MessageBubble(
              chatsRef[index].data()['text'],
              chatsRef[index].data()['userId'] == user.uid,
              chatsRef[index].data()['username'],
              chatsRef[index].data()['userImage'],
              key: ValueKey(chatsRef[index].id),
            );
          },
        );
      },
    );
  }
}

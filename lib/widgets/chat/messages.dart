import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './message_bubble.dart';
import '../../models/message.dart';
import '../../view_models/messages_viewmodel.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messagesViewModel = Provider.of<MessageViewModel>(context);
    return StreamBuilder<List<Message>>(
      stream: messagesViewModel.getMessageStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Message>> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        //! = null assertion operator (treat as non-nullable)
        final messages = chatSnapshot.data!;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageBubble(
              messages[index].text,
              messages[index].userId == messagesViewModel.currentUser.userId,
              messages[index].username,
              messages[index].userImage,
              key: ValueKey(messages[index].id),
            );
          },
        );
      },
    );
  }
}

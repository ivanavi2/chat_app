import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMyMessage;
  final String username;
  final String imageUrl;
  final Key key;

  MessageBubble(this.message, this.isMyMessage, this.username, this.imageUrl,
      {required this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: isMyMessage
                    ? Colors.lightBlue[300]
                    : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !isMyMessage ? Radius.circular(0) : Radius.circular(12),
                  bottomRight:
                      isMyMessage ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: isMyMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline1!.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline1!.color,
                      fontSize: 16,
                    ),
                    textAlign: isMyMessage ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: isMyMessage ? null : MediaQuery.of(context).size.width * 0.38,
          right: isMyMessage ? MediaQuery.of(context).size.width * 0.38 : null,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import '../view_models/user_viewmodel.dart';
import '../view_models/messages_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    fbm.subscribeToTopic('chats');
  }

  @override
  Widget build(BuildContext context) {
/*     final currentUser =
        Provider.of<UserViewModel>(context, listen: false).currentUser; */

    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Log out'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  Provider.of<UserViewModel>(context, listen: false).signOut();
                }
              }),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<UserViewModel>(context).getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ChangeNotifierProvider(
            create: (context) => MessageViewModel(snapshot.data),
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Messages(),
                  ),
                  NewMessage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

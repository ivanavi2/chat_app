import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import './view_models/user_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Flutter Chat',
          theme: getThemeData(context),
          home: snapshot.connectionState != ConnectionState.done
              ? LoadingScreen()
              : ChangeNotifierProvider(
                  create: (context) => UserViewModel(),
                  builder: (context, _) {
                    return StreamBuilder(
                      stream: Provider.of<UserViewModel>(context, listen: false)
                          .getAuthStateChangesStream(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingScreen();
                        }
                        if (userSnapshot.hasData) {
                          return ChatScreen();
                        }
                        return AuthScreen();
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  ThemeData getThemeData(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.pink,
      backgroundColor: Colors.pink,
      accentColor: Colors.pinkAccent,
      accentColorBrightness: Brightness.dark,
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: Colors.pink,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

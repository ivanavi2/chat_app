import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import '../models/user.dart';

class UserViewModel with ChangeNotifier {
  bool _busy = false;

  final _usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<CurrentUser>(
            fromFirestore: (snapshot, _) =>
                CurrentUser.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (currentUser, _) => currentUser.toJson(),
          );
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;

  get busy => _busy;

  get isLogin => this._isLogin;
  set isLogin(value) {
    this._isLogin = value;
    turnIdle();
  }

  get userEmail => this._userEmail;
  set userEmail(value) => this._userEmail = value;

  get userName => this._userName;
  set userName(value) => this._userName = value;

  get userPassword => this._userPassword;
  set userPassword(value) => this._userPassword = value;

  get userImageFile => this._userImageFile;
  set userImageFile(value) => this._userImageFile = value;

  User? get user => _auth.currentUser;

  Stream<User?> getAuthStateChangesStream() {
    return _auth.authStateChanges();
  }

  //Fetch user data from users collection if FirebaseAuth.user is set
  Future<CurrentUser?> getCurrentUser() async {
    if (user != null) {
      return await _usersRef
          .doc(user!.uid)
          .get()
          .then((snapshot) => snapshot.data()!);
    }
    return null;
  }

  Future<String?> submitAuthForm() async {
    print({userEmail, userPassword});
    UserCredential authResult;

    turnBusy();
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');

        UploadTask uploadTask = ref.putFile(userImageFile);
        uploadTask.whenComplete(() async {
          final url = await ref.getDownloadURL();
          await _usersRef.doc(authResult.user!.uid).set(
              CurrentUser(email: userEmail, imageUrl: url, username: userName));
        });
        turnIdle();
        return null;
      }
    } on PlatformException catch (e) {
      var message = 'An error occurred, please check your credentials!';

      if (e.message != null) {
        message = e.message.toString();
      }
      turnIdle();
      return message;
    } catch (e) {
      turnIdle();
      print(e);
      return e.toString();
    }
  }

  void signOut() async {
    turnBusy();
    await _auth.signOut();
    turnIdle();
  }

  void turnBusy() {
    _busy = true;
  }

  void turnIdle() {
    _busy = false;
    notifyListeners();
  }
}

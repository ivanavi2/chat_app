import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../pickers/user_image_picker.dart';
import '../../view_models/user_viewmodel.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _trySubmit(File? userImageFile, bool isLogin) {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (userImageFile == null && !isLogin) {
      showSnackBar('Please select an image');
      return false;
    }

    if (isValid) {
      // _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!userViewModel.isLogin) UserImagePicker(),
            TextFormField(
              key: ValueKey('email'),
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                hintText: 'Email Address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onChanged: (value) => {userViewModel.userEmail = value.trim()},
              onSaved: (value) => userViewModel.userEmail = value!.trim(),
            ),
            if (!userViewModel.isLogin) ...[
              SizedBox(
                height: 12,
              ),
              TextFormField(
                key: ValueKey('username'),
                autocorrect: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 4) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
                onChanged: (value) => {userViewModel.userName = value.trim()},
                onSaved: (value) => userViewModel.userName = value!.trim(),
              ),
            ],
            SizedBox(
              height: 12,
            ),
            TextFormField(
              key: ValueKey('password'),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open_outlined),
                hintText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 7) {
                  return 'Password must be 7 characters long';
                }
                return null;
              },
              onChanged: (value) => {userViewModel.userPassword = value.trim()},
              onSaved: (value) => userViewModel.userPassword = value!.trim(),
            ),
            SizedBox(
              height: 20,
            ),
            if (userViewModel.busy) CircularProgressIndicator(),
            if (!userViewModel.busy)
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    child: Text(
                      userViewModel.isLogin ? 'Login' : 'Sign up',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async {
                      final isValid = _trySubmit(
                          userViewModel.userImageFile, userViewModel.isLogin);
                      if (isValid) {
                        final result = await userViewModel.submitAuthForm();
                        if (result != null) {
                          showSnackBar(result);
                        }
                      }
                    }),
              ),
            const SizedBox(
              height: 12,
            ),
            const Divider(),
            if (!userViewModel.busy)
              FlatButton(
                onPressed: () {
                  userViewModel.isLogin = !userViewModel.isLogin;
                },
                child: Text(userViewModel.isLogin
                    ? 'Create new account?'
                    : 'I already have an account'),
                textColor: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

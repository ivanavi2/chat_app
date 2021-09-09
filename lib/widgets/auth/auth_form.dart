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
      _formKey.currentState!.save();
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
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
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
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) => userViewModel.userEmail = value!.trim(),
                  ),
                  if (!userViewModel.isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          userViewModel.userName = value!.trim(),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return 'Password must be 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        userViewModel.userPassword = value!.trim(),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (userViewModel.busy) CircularProgressIndicator(),
                  if (!userViewModel.busy)
                    RaisedButton(
                        child:
                            Text(userViewModel.isLogin ? 'Login' : 'Sign up'),
                        onPressed: () async {
                          final isValid = _trySubmit(
                              userViewModel.userImageFile,
                              userViewModel.isLogin);
                          if (isValid) {
                            final result = await userViewModel.submitAuthForm();
                            if (result != null) {
                              showSnackBar(result);
                            }
                          }
                        }),
                  if (!userViewModel.busy)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          userViewModel.isLogin = !userViewModel.isLogin;
                        });
                      },
                      child: Text(userViewModel.isLogin
                          ? 'Create new account?'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

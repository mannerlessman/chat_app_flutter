import 'dart:io';

import 'package:chat_app/widgets/auth/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  late Function func;
  var isLoadingState;
  //constructor to get function refrence from main widget
  AuthForm(Function funny, var isLoadingState) {
    func = funny;
    this.isLoadingState = isLoadingState;
  }

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLoginMode = true;

  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? userImageFile;
  late BuildContext ctx;

  void trySubmit() {
    //here we are validating user inputs
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (userImageFile == null && !_isLoginMode) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an Image please...'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      widget.func(_userEmail.trim(), _userName.trim(), userImageFile,
          _userPassword.trim(), _isLoginMode, ctx);

      //after saving user data from form now authorize it with firebaseAuth

    }
  }

  void imagePickFn(File image) {
    userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              //giving a unique key to form...
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoginMode) UserImagePicker(imagePickFn),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address !';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'email address'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLoginMode)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter a valid username !';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'UserName'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('passsword'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Please enter a valid password !';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'password'),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoadingState) const CircularProgressIndicator(),
                  if (!widget.isLoadingState)
                    ElevatedButton(
                        onPressed: trySubmit,
                        child: Text(_isLoginMode ? 'Log In' : 'Sign Up')),
                  const SizedBox(
                    height: 5,
                  ),
                  if (!widget.isLoadingState)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoginMode = !_isLoginMode;
                          });
                        },
                        child: Text(_isLoginMode
                            ? 'Don\'t have a account ? Sign Up'
                            : 'Already have an account? Login'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

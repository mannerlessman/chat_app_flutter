import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoadingState = false;

  void _submitAuthForm(String email, String username, File userImage,
      String password, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        isLoadingState = true;
      });
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //here we will store image to firebase storoage and then get a link to save to database and later retrieve image

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_profile')
            .child(userCredential.user!.uid + '.jpg');

        ref.putFile(userImage).whenComplete(() async {
          var url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({'username': username, 'email': email, 'image_url': url});
        });
      }
    } on PlatformException catch (err) {
      var message = 'There was an error, please check your credentials !';
      if (err.message != null) {
        message = err.message!;
        setState(() {
          isLoadingState = false;
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        isLoadingState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, isLoadingState),
    );
  }
}

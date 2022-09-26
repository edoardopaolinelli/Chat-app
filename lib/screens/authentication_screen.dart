import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/authentication/authentication_form.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _authentication = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthenticationForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext buildContext,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _authentication.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _authentication.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userCredential.user!.uid}.jpg');
        ref.putFile(image).whenComplete(() => null);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (error) {
      String message = 'An error occurred, please check your credentials!';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(buildContext).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(buildContext).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseException catch (error) {
      String message = 'An error occurred, please check your credentials!';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(buildContext).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(buildContext).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthenticationForm(
        submitFunction: _submitAuthenticationForm,
        isLoading: _isLoading,
      ),
    );
  }
}

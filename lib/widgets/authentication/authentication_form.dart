import 'dart:io';

import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';

class AuthenticationForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext buildContext,
  ) submitFunction;

  final bool isLoading;

  const AuthenticationForm(
      {super.key, required this.submitFunction, required this.isLoading});

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _userEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  bool _isLogin = true;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      widget.submitFunction(
        _userEmail!.trim(),
        _userPassword!.trim(),
        _userName!.trim(),
        _userImageFile!,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(imagePickFunction: _pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a email address';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      labelStyle: TextStyle(
                        fontFamily: 'Lato-Bold',
                      ),
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _userName = newValue;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontFamily: 'Lato-Bold',
                        ),
                      ),
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userPassword = newValue;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.indigo),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
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

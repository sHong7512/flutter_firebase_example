import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/auth/auth_complete_screen.dart';
import 'package:firebase_example/auth/auth_manage.dart';
import 'package:firebase_example/auth/auth_sign_up_screen.dart';
import 'package:flutter/material.dart';

class FireBaseAuthScreen extends StatelessWidget {
  FireBaseAuthScreen({Key? key}) : super(key: key);

  AuthManage authManage = AuthManage();

  BuildContext? context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text('Firebase Auth'),
        ),
        body: Center(
          child: emailLogin(),
        ));
  }

  final emailController = TextEditingController();
  final pwController = TextEditingController();

  Widget emailLogin() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'email', hintText: 'example@gmail.com'),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            controller: pwController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await authManage.signIn(emailController.text, pwController.text);
              _showSnackBar('Sign in :: ${result.isComplete} ${result.message}');
              if (result.isComplete)
                Navigator.of(context!).pushReplacement(MaterialPageRoute(builder: (_) => AuthCompleteScreen()));
            },
            child: Text('Sign in'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context!).push(MaterialPageRoute(builder: (_) => AuthSignUpScreen()));
            },
            child: Text('Sign Up'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await authManage.signInWithGoogle();
              log('result : ${result.user}');
            },
            child: Text('Google Login'),
          ),
        ],
      ),
    );
  }

  _showSnackBar(String msg) {
    if (context == null) return;

    ScaffoldMessenger.of(context!).clearSnackBars();
    ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 2000),
    ));
  }
}

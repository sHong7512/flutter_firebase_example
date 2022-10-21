import 'dart:developer';

import 'package:flutter/material.dart';

import 'auth_manage.dart';

class AuthSignUpScreen extends StatelessWidget {
  AuthSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthManage authManage = AuthManage();

    final emailController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
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
            SizedBox(height: 8,),
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
                final result = await authManage.createUser(emailController.text, pwController.text);
                log('Sign in :: ${result.isComplete} ${result.message}');

                if(result.isComplete) Navigator.of(context).pop();
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

}

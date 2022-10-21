import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/auth/auth_manage.dart';
import 'package:firebase_example/auth/firebase_auth_screen.dart';
import 'package:flutter/material.dart';

class AuthCompleteScreen extends StatelessWidget {
  const AuthCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _listenUser();
    AuthManage authManage = AuthManage();
    return Scaffold(
      appBar: AppBar(title: Text('Auth Complete'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${authManage.getUser()}', textAlign: TextAlign.center,),
          SizedBox(height: 8,),
          ElevatedButton(
            onPressed: () async {
              final result = await authManage.signOut();
              if(result)
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => FireBaseAuthScreen()));
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _listenUser() {
    // 유저의 로그인 상태를 확인하고 변화된 이벤트를 받음
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        log('<${this.runtimeType}> user == null');
      } else {
        log('<${this.runtimeType}> user :: $user');
      }
    });

    /* // 상태의 변화를 streamBuilder로 받고 싶을 시
    StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> user) {
        if (user.hasData) {
          return const MainWidget();
        } else {
          return const LoginWidget();
        }
      },
    );
    */
  }
}

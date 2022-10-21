import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMScreen extends StatefulWidget {
  const FCMScreen({Key? key}) : super(key: key);

  @override
  State<FCMScreen> createState() => _FCMScreenState();
}

class _FCMScreenState extends State<FCMScreen> {
  String? fcmToken = '';

  @override
  void initState() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log('newToken : $newToken');
      setState() {
        fcmToken = newToken;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Messaging'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$fcmToken', textAlign: TextAlign.center),
          ElevatedButton(
            onPressed: () async {
              fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BD3nvKVR1C7cxl_pAIYz0nUnKSUbxVm1F17EMdzD7w6KlvslTNpJLji_l8qaytzAFVb65yc49N973hGvV1dm46s");
              setState(() {});
            },
            child: Text('show fcm token'),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseMessaging.instance.deleteToken();
              setState(() {
                fcmToken = '';
              });
            },
            child: Text('delete Token'),
          ),
        ],
      ),
    );
  }
}

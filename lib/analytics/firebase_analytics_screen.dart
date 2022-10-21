import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class FirebaseAnalyticsScreen extends StatefulWidget {
  const FirebaseAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseAnalyticsScreen> createState() => _FirebaseAnalyticsScreenState();
}

class _FirebaseAnalyticsScreenState extends State<FirebaseAnalyticsScreen> {
  final analytics = FirebaseAnalytics.instance;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Analytics')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _message,
            style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0)),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: _sendAnalyticsEvent,
            child: const Text('Test logEvent Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    setState(() {
      _message = 'logEvent succeeded';
    });
  }
}

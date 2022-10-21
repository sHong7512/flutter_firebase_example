import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_example/analytics/firebase_analytics_screen.dart';
import 'package:firebase_example/auth/firebase_auth_screen.dart';
import 'package:firebase_example/crashlytics/firebase_crashlytics_screen.dart';
import 'package:firebase_example/messaging/fcm_manager.dart';
import 'package:firebase_example/messaging/fcm_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  fcmBackgroundHandle();
  fcmForegroundHandle();

  final analytics = FirebaseAnalytics.instance;
  analytics.logAppOpen();

  final crashlytics = FirebaseCrashlytics.instance;
  // if (kDebugMode) {
  //   await crashlytics.setCrashlyticsCollectionEnabled(false);
  // }
  print('Crashlytics is Enable :: ${crashlytics.isCrashlyticsCollectionEnabled}');

  runApp(
    MaterialApp(
      navigatorObservers: [
        /// 화면이 변경되었을떄 analytics 이벤트를 받을 수 있음
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FireBaseAuthScreen()));
              },
              child: Text('Auth Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FCMScreen()));
              },
              child: Text('FCM Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FirebaseAnalyticsScreen()));
              },
              child: Text('Analytics Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FirebaseCrashlyticsScreen()));
              },
              child: Text('Crashlytics Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///Background
void fcmBackgroundHandle() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _setupInteractedMessage();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId} ${message.data}");
}

Future<void> _setupInteractedMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) _handleMessage(initialMessage);

  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  print('message = ${message.notification!.title}');
}

///Foreground
void fcmForegroundHandle() async {
  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            badgeNumber: 1,
            subtitle: 'the subtitle',
            // sound: 'slow_spring_board.aiff',
          ),
          macOS: const DarwinNotificationDetails(
            badgeNumber: 1,
            subtitle: 'the subtitle',
            // sound: 'slow_spring_board.aiff',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('onMessage Opened App : $message');
  });
}

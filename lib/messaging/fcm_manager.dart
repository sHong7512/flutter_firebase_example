import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///Background
/*
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
이거는 main에서 실행해줘야하는데 나머지(백그라운드 클릭, 포그라운드)는 runApp 내부에서 실행해줘도 됨.
 */
bool isOn = false;
void fcmBackgroundHandle() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _setupInteractedMessage();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  log("Notification: ${message.notification}");
  for (String key in message.data.keys) {
    log('$key :: ${message.data[key]}');
  }
}

Future<void> _setupInteractedMessage() async {
  log('_setupInteractedMessage');
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  /// 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) _handleMessage(initialMessage);

  /// 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  log('message = ${message.notification!.title}');
}

///Foreground
void fcmForegroundHandle() async {
  /// 알림 노티 만들어주기
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
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
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

  /// 알림 클릭시 핸들링
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
  final initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      log('onDidReceiveNotificationResponse :: $details');
    },
  );
}

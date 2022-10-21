# firebase_example

A new Flutter project.

## Initial Setting
* 1. CLI 설치 및 로그인 :: ~$ curl -sL https://firebase.tools | bash
* 2. CLI 로그인 :: ~$ firebase login
* 3. flutterfire_cli활성화 :: ~$ dart pub global activate flutterfire_cli
* 4. 환경변수 설정 :: ~$ export PATH="$PATH":"$HOME/.pub-cache/bin"
* 5. 프로젝트 연결 :: ~$ flutterfire configure     (~$ flutterfire configure {프로젝트코드} 로도 연결가능)
* 6. firebase init :: 메인에 아래 코드 삽입
```
     void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        ...
     }
```

* 7. 로그캣 확인(Android) :: I/FirebaseApp: Device unlocked: initializing all Firebase APIs for app [DEFAULT]


## Analytics DebugView

* 연결하기

```
~$ adb shell setprop debug.firebase.analytics.app com.example.firebase_example
```

* 연결 해제

```
~$ adb shell setprop debug.firebase.analytics.app .none
```


## Libraries 

firebase_core: ^2.0.0

firebase_core_web: ^2.0.0

firebase_auth: ^4.0.1

google_sign_in: ^5.4.2

firebase_messaging: ^14.0.1

flutter_local_notifications: ^12.0.2

firebase_analytics: ^10.0.2

firebase_crashlytics: ^3.0.2


## Reference

Initial : https://kanoos-stu.tistory.com/m/70
Auth : https://kanoos-stu.tistory.com/m/71, https://bangu4.tistory.com/m/352
Messaging : https://velog.io/@leedool3003/Flutter-FCM-Firebase-Cloud-Messagin-%EC%97%B0%EB%8F%99, https://kanoos-stu.tistory.com/m/72
Analytics : https://dev-yakuza.posstree.com/ko/flutter/firebase/analytics/
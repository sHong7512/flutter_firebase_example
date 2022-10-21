import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/auth/auth_complication_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManage{
  /// 회원가입
  Future<AuthComplication> createUser(String email, String pw) async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
      log('sign up >> ${credential.user}');

      // authPersistence(); // 인증 영속
      return AuthComplication(isComplete: true, message: 'Sign Up Complete');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      } else {
        log('Sign Up Error : ${e.message}');
      }
      return AuthComplication(isComplete: false, message: '${e.message}');
    } catch (e) {
      log('ERROR : $e');
      return AuthComplication(isComplete: false, message: '$e');
    }
  }

  /// 로그인
  Future<AuthComplication> signIn(String email, String pw) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pw
      );
      log('sign in >> ${credential.user}');

      // authPersistence(); // 인증 영속
      return AuthComplication(isComplete: true, message: 'Sign in Complete');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else {
        log('Sign in Error : $e');
      }
      return AuthComplication(isComplete: false, message: '${e.message}');
    } catch (e) {
      log('ERROR : $e');
      return AuthComplication(isComplete: false, message: '$e');
    }
  }
  /// 로그아웃
  Future<bool> signOut() async{
    await FirebaseAuth.instance.signOut();
    return true;
  }

  /// 회원가입, 로그인시 사용자 영속
  void authPersistence() async{
    await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  }
  /// 유저 삭제
  Future<void> deleteUser(String email) async{
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  }

  /// 현재 유저 정보 조회
  User? getUser(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      // Check if user's email is verified
      final emailVerified = user.emailVerified;

      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      final uid = user.uid;
    }
    return user;
  }
  /// 공급자로부터 유저 정보 조회
  User? getUserFromSocial(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.cpm, etc.)
        final provider = providerProfile.providerId;

        // UID specific to the provider
        final uid = providerProfile.uid;

        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        final profilePhoto = providerProfile.photoURL;
      }
    }
    return user;
  }
  /// 유저 이름 업데이트
  Future<void> updateProfileName(String name) async{
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateDisplayName(name);
  }
  /// 유저 url 업데이트
  Future<void> updateProfileUrl(String url) async{
    final user = FirebaseAuth.instance.currentUser;
    await user?.updatePhotoURL(url);
  }
  /// 비밀번호 초기화 메일보내기
  Future<void> sendPasswordResetEmail(String email) async{
    await FirebaseAuth.instance.setLanguageCode("kr");
    await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
  }

  /// 구글 로그인 (앱 배포하여 인증서 서명을 받아서 등록되야 가능)
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    log('111111 $googleUser');

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    log('222222 $googleUser');

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    log('333333 $credential');

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
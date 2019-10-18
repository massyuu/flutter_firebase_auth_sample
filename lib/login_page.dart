import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

import 'models/auth_model.dart';

// FirebaseAuthインスタンス
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class LoginPage extends StatelessWidget {
  StreamSubscription<FirebaseUser> _listener;

  // FIrebaseユーザー情報
  FirebaseUser _currentUser;

  // Twitterログイン情報
  TwitterLoginResult _twitterLoginResult;
  TwitterLoginStatus _twitterLoginStatus;
  TwitterSession _currentUserTwitterSession;

  // ログイン状態
  String _loginStateMessage = "Not Login";
  AuthModel _authModel;

  // Twitterログインインスタンス
  final TwitterLogin twitterLogin = new TwitterLogin(
    // TwitterDeveloperで取得したConsumer API keys
    consumerKey: "consumerKey",
    consumerSecret: "consumerSecret"
  );

  /// ************************
  /// ビルド
  /// ************************
  @override
  Widget build(BuildContext context) {
    _authModel = Provider.of<AuthModel>(context);

    // 初期状態の取得
    _setCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firebase Auth Sample"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed('/nextpage'),
              child: Text('次のページへ'),
            ),
            RaisedButton(
              onPressed: _twitterLogin,
              child: Text('Twitter Login'),
            ),
            RaisedButton(
              onPressed: _twitterLogout,
              child: Text('Twitter logout'),
            ),
            Text(
              _loginStateMessage,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }

  /// ************************
  /// Twitterログイン
  /// ************************
  void _twitterLogin() async {

    // ログイン処理
    _twitterLoginResult = await twitterLogin.authorize();
    _currentUserTwitterSession = _twitterLoginResult.session;
    _twitterLoginStatus = _twitterLoginResult.status;

    // Twitterログイン成功時にクレデンシャルをセット
    if(_currentUserTwitterSession != null) {
      AuthCredential _authCredential = TwitterAuthProvider.getCredential(
          authToken: _currentUserTwitterSession?.token ?? '',
          authTokenSecret: _currentUserTwitterSession?.secret ?? ''
      );
      _currentUser = (await _firebaseAuth.signInWithCredential(
          _authCredential
      )).user;
    }

    // ログイン状態の更新
    if (_twitterLoginStatus == TwitterLoginStatus.loggedIn && _currentUser != null) {
      _authModel.setLoginState(true);
      _authModel.setDisplayName(_currentUser.displayName);
    }
  }

  /// ************************
  /// 現在ログイン中のユーザーをセット
  /// ************************
  void _setCurrentUser() async {
    _currentUser = await _firebaseAuth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _firebaseAuth.onAuthStateChanged.listen((FirebaseUser user) {
      // 保持しているユーザー情報の更新
      _currentUser = user;
      if(_currentUser != null) {
        _authModel.setLoginState(true);
        _authModel.setDisplayName(_currentUser.displayName);
        _loginStateMessage = "Login as " + _currentUser.displayName;
      } else {
        _authModel.setLoginState(false);
        _authModel.setDisplayName("");
        _loginStateMessage = "Not Login";
      }
    });
  }

  /// ************************
  /// Twitterログアウト
  /// ************************
  void _twitterLogout() async {
    _currentUser = null;
    _authModel.setLoginState(false);
    _authModel.setDisplayName("");
    _loginStateMessage = "Not Login";

    // ログアウト処理
    await _firebaseAuth.signOut();
  }
}

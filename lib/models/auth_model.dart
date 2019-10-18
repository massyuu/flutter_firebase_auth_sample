import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  String _displayName = "";

  get isLogin => _isLogin;
  get displayName => _displayName;

  void setLoginState(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  void setDisplayName(String displayName) {
    _displayName = displayName;
    notifyListeners();
  }
}

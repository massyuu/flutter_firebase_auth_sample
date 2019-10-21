import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth_model.dart';

class NextPage extends StatelessWidget {
  String _loginStateMessage = "Not Login";
  AuthModel _authModel;

  @override
  Widget build(BuildContext context) {
    _authModel = Provider.of<AuthModel>(context);

    setDisplayMessage();

    return Scaffold(
      appBar: AppBar(
        title: Text('ChangeNotifier Provider Sample'),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _loginStateMessage,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }

  void setDisplayMessage(){
    if(_authModel.isLogin) {
      _loginStateMessage = "Hi, " + _authModel.displayName;
    }
  }
}

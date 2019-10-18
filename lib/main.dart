import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth_model.dart';
import 'login_page.dart';
import 'next_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (BuildContext context) => AuthModel(),
        ),
      ],
      child: MaterialApp(
        home: LoginPage(
        ),
        routes: {
          '/nextpage': (BuildContext context) => NextPage(),
        },
      ),
    );
  }
}

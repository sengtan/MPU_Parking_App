import 'package:flutter/material.dart';
import 'authprovider.dart';
import 'authenticator.dart';
import 'root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterPhoto',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: RootPage(),
        )
    );
  }

}

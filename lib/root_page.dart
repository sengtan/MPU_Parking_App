import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'authprovider.dart';
import 'authenticator.dart';
import 'login_page.dart';
import 'utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'floor_control.dart';
import 'dart:math';

enum AuthStatus {
  notDetermined,
  notSignedIn,
  SignedIn,
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.notDetermined;
  bool isAdmin = false;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Authenticator auth = AuthProvider.of(context).auth;
    auth.getUID().then((String userID) {
      setState(() {
        authStatus = userID == null ? AuthStatus.notSignedIn : AuthStatus.SignedIn;
      });
    });
  }
  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SignedIn;
    });
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  }

  void reset(String floor, int num){
    for(int x = 1;x<=num;x++){
      _database.reference().child(floor).child(x.toString()).child("status").set("Available");
    }
  }

  void randomize(String floor, int num){
    var random = Random();
    for(int x = 1;x<=num;x++){
      int rand = random.nextInt(120);
      if(rand > 40 && rand <= 80)
        _database.reference().child(floor).child(x.toString()).child("status").set("Available");
      else if(rand >80 && rand <= 120)
        _database.reference().child(floor).child(x.toString()).child("status").set("Reserved");
      else
        _database.reference().child(floor).child(x.toString()).child("status").set("Occupied");
    }
  }

  Widget listofbuttons(isAdmin){
    switch(isAdmin){
      case true:
        return Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () => reset("Level_1",78),
              child: Text("Reset Level_1"),
            ),
            RaisedButton(
              onPressed: () => reset("Level_2",47),
              child: Text("Reset Level_2"),
            ),
            RaisedButton(
              onPressed: () => randomize("Level_1",78),
              child: Text("Randomize Level_1"),
            ),
            RaisedButton(
              onPressed: () => randomize("Level_2",47),
              child: Text("Randomize Level_2"),
            ),
          ],
        );break;
      case false:
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text("Your account has restricted priviledges.", style: TextStyle(fontSize: 24.0),textAlign: TextAlign.center,),
          ),
        );
    }
  }

  Widget admin(isAdmin){
    String text;
    switch(isAdmin){
      case true: text = "Admin User";break;
      case false: text = "Non-Admin User";break;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0,20.0,0,0.0),
      child: Text("$text",style: TextStyle(fontSize: 32.0))
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return WaitingScreen(_signedOut);
        break;
      case AuthStatus.notSignedIn:
        return LoginPage(
          onSignedIn: _signedIn,
        );
        break;
      case AuthStatus.SignedIn:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        return Scaffold(
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:admin(isAdmin) ,
                ),
                Switch(
                  value: isAdmin,
                  onChanged: (value) {
                    setState(() {
                      isAdmin = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                listofbuttons(isAdmin),
                RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () => _signedOut(),
                  child: Text("Log Out"),
                )
              ],
            )
          ),
          body: floors(isAdmin)
        );
        break;
      default:
        return ErrorScreen(_signedOut);
    }
  }

}
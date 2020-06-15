import 'package:flutter/material.dart';
import 'package:focuscamp/focus_input_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'authentication_page.dart';

class MainPage extends StatefulWidget {
  static const String id = 'main_page';
  bool isSuccess;

  MainPage({Key key, this.isSuccess}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool battery = false;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _token;
  Future<int> _streak;
  String kTitle = 'FOCUS CAMP';

  Future<bool> getToken() async {
    FirebaseUser currentUser = await _auth.currentUser();

    final SharedPreferences prefs = await _prefs;
    var firestoreToken =
        await _firestore.collection('tokens').document(currentUser.uid).get();
    try {
      print(firestoreToken.data['token']);
    } catch (e) {
      print(e);
    }
    print(prefs.getBool('token'));
    return (prefs.getBool('token'));
  }

  @override
  void initState() {
    super.initState();

    _streak = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('streak') ?? 0);
    });
    _token = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('token') ?? true);
    });

    _firestore.collection('tokens').add({
      'token': true,
      'user': _auth.currentUser(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool args = ModalRoute.of(context).settings.arguments;
    print('');
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/rope.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            kTitle,
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 2, child: Container()),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                'STREAK #',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 9,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FutureBuilder<int>(
                      future: _streak,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data.toString(),
                                style: TextStyle(
                                  color: (snapshot.data == null)
                                      ? Colors.transparent
                                      : Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                strutStyle: StrutStyle(
                                  forceStrutHeight: true,
                                  height: 1,
                                ),
                              );
                            }
                        }
                      })),
            ),
            Expanded(
              flex: 2,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: RaisedButton(
                    elevation: 8,
                    color: Colors.grey,
                    padding: EdgeInsets.all(0.0),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    onPressed: () async {
                      bool token = await getToken();
                      (token == null)
                          ? print('sorry token is $token')
                          : Navigator.pushNamed(
                              context,
                              FocusInputPage.id,
                            );
                    },
                    child: Container(
                      width: 120,
                      child: Text(
                        'FOCUS',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(
                          forceStrutHeight: true,
                        ),
                      ),
                    ),
                  )),
            ),
//            MenuButton(
//              title: 'HISTORY',
//              screen: FocusInputPage.id,
//            ),
//            Expanded(
//              flex: 2,
//              child: FittedBox(
//                  fit: BoxFit.contain,
//                  child: RaisedButton(
//                    elevation: 2,
//                    color: Colors.grey,
//                    padding: EdgeInsets.all(0.0),
//                    splashColor: Colors.blueAccent,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(24)),
//                    onPressed: () async {
//                      Navigator.pushNamed(
//                        context,
//                        AuthenticationPage.id,
//                      );
//                    },
//                    child: Container(
//                      width: 120,
//                      child: Text(
//                        'Account',
//                        style: TextStyle(color: Colors.white),
//                        textAlign: TextAlign.center,
//                        strutStyle: StrutStyle(
//                          forceStrutHeight: true,
//                        ),
//                      ),
//                    ),
//                  )),
//            ),

//            Expanded(
//              flex: 2,
//              child: Switch(
//                value: battery,
//                onChanged: (value) {
//                  setState(() {
//                    getBatteryStatus();
//                    battery = value;
//                    if (battery) {
//                    } else {}
//                  });
//                },
//                activeTrackColor: Colors.lightBlueAccent,
//                activeColor: Colors.blue,
//              ),
//            ),

            Expanded(child: Container()),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void getBatteryStatus() async {
    var status = await Permission.ignoreBatteryOptimizations.status;

    print(status.toString());
  }
}

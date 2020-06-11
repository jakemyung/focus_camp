import 'package:flutter/material.dart';
import 'package:focuscamp/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FailPage extends StatefulWidget {
  static const String id = 'fail_page';
  final String willFocusOn;

  FailPage({Key key, this.willFocusOn}) : super(key: key);
  @override
  _FailPageState createState() => _FailPageState();
}

class _FailPageState extends State<FailPage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _token;
  Future<int> _streak;

  Future<void> _zeroCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int streak = 0;
    print(streak);
    setState(() {
      _streak = prefs.setInt("streak", streak).then((bool success) {
        return streak;
      });
    });
  }

  Future<void> _emptyToken() async {
    FirebaseUser currentUser = await _auth.currentUser();

    final SharedPreferences prefs = await _prefs;
    final bool token = false;
    print(token);
    setState(() {
      _token = prefs.setBool("token", token).then((bool success) {
        return token;
      });
      print('here is the real ${currentUser.uid}');
      _firestore
          .collection('tokens')
          .document(currentUser.uid)
          .setData({'token': false, 'user': currentUser.uid});
    });
  }

  @override
  void initState() {
    super.initState();

    _streak = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('streak') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    print('focusingOn is from args $args');

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bar.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'FAIL',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 5,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                  ),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Actions have consequences. The app ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'PermanentMarker',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'WILL',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'PermanentMarker'),
                        ),
                        TextSpan(
                          text: ' need to be ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'PermanentMarker'),
                        ),
                        TextSpan(
                          text: 'REPURCHASED',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'PermanentMarker'),
                        ),
                        TextSpan(
                          text: ' to run.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'PermanentMarker'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: RaisedButton(
                  elevation: 2,
                  color: Colors.grey,
                  padding: EdgeInsets.all(0.0),
                  splashColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  onPressed: () {
                    _zeroCounter();
                    _emptyToken();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MainPage.id, (Route<dynamic> route) => false,
                        arguments: true);
                  },
                  child: Container(
                    width: 120,
                    child: Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

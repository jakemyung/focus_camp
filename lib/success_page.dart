import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';

class SuccessPage extends StatefulWidget {
  static const String id = 'success_page';
  final String willFocusOn;

  SuccessPage({Key key, this.willFocusOn}) : super(key: key);
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> _streak;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int streak = (prefs.getInt('streak') ?? 0) + 1;
    setState(() {
      _streak = prefs.setInt("streak", streak).then((bool success) {
        return streak;
      });
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

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/gym.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'SUCCESS',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
            ),
            Expanded(
                flex: 5,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Good job, you made it.\nNow go do another one.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'PermanentMarker'),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
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
                      _incrementCounter();
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
                  )),
            ),
            Expanded(child: Container()),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

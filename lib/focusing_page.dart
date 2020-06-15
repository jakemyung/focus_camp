import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focuscamp/fail_page.dart';
import 'package:quiver/async.dart';
import 'success_page.dart';
import 'package:wakelock/wakelock.dart';
import 'package:screen_state/screen_state.dart';

import 'package:screenshot/screenshot.dart';

class FocusingPage extends StatefulWidget {
  static const String id = 'focusing_page';
  final String arguments;

  FocusingPage({Key key, this.arguments}) : super(key: key);
  @override
  _FocusingPageState createState() => _FocusingPageState();
}

class _FocusingPageState extends State<FocusingPage>
    with WidgetsBindingObserver {
  var screenStatus;
  int _start = 3;
  int _current = 3;
  AppLifecycleState _notification;
  var _notificationList = [];
  Screen _screen;
  StreamSubscription<ScreenStateEvent> _subscription;
  ScreenshotController _controller = ScreenshotController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();

    startTimer();
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(ScreenStateEvent event) {
    print(event);
    screenStatus = event;
    _notificationList.add(event);
    print('length of notificaiton Listion ${_notificationList.length}');
  }

  void startListening() {
//    _screen = new Screen();
//    try {
//      _subscription = _screen.screenStateStream.listen(onData);
//    } on ScreenStateException catch (exception) {
//      print(exception);
//    }
  }

  void stopListening() {
    _subscription.cancel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  var sub;
  void startTimer() {
    _screen = new Screen();
    try {
      _subscription = _screen.screenStateStream.listen(onData);
    } on ScreenStateException catch (exception) {
      print(exception);
    }

    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: _start),
      Duration(seconds: 1),
    );
    Wakelock.enable();

    int counter = 0;
    sub = countDownTimer.listen(null);
    sub.onData(
      (duration) {
        setState(
          () {
            _current = _start - duration.elapsed.inSeconds;

            if (_notification == AppLifecycleState.paused) {
              print('#1: _notification is $_notification');
              if (counter == 1) {
                if (_notificationList.isNotEmpty) {
                  print('#2: _notificationList is ${_notificationList.last}');

                  if (_notificationList.last ==
                      ScreenStateEvent.SCREEN_UNLOCKED) {
                    _notificationList = [];
//                      print(('FAILED $screenStatus and $_notification'));
//                      sub.cancel();
//                      Wakelock.disable();
//                      Navigator.pushNamed(
//                        context,
//                        FailPage.id,
//                      );

                  }
                } else {
                  print(('FAILED $screenStatus and $_notification'));
                  sub.cancel();
                  Wakelock.disable();
                  Navigator.pushNamed(
                    context,
                    FailPage.id,
                  );
                }
              } else {
                counter++;
                print('counter $counter');
              }
            }
          },
        );
      },
    );

    sub.onDone(() {
      print("Done");

      sub.cancel();
      Wakelock.disable();

      Navigator.pushNamed(
        context,
        SuccessPage.id,
      );
    });
  }

  String formatMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes).toString();
    String secondsStr = (seconds % 60).toString();
    return (minutes == 0)
        ? "\n$secondsStr sec"
        : "$minutesStr min\n$secondsStr sec";
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Are you sure you want to quit?'),
            content: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Exiting out of this session early ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'PermanentMarker',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'WILL',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'PermanentMarker'),
                  ),
                  TextSpan(
                    text: ' require you to ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'PermanentMarker'),
                  ),
                  TextSpan(
                    text: 'REPURCHASE',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'PermanentMarker'),
                  ),
                  TextSpan(
                    text: ' the app.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'PermanentMarker'),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  sub.cancel();
                  Navigator.pushNamed(
                    context,
                    FailPage.id,
                  );
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showMyDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          print('quit button clicked');
          return AlertDialog(
            title: Text('Are you sure you want to quit?'),
            content: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Exiting out of this session early ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'PermanentMarker',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'WILL',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'PermanentMarker'),
                  ),
                  TextSpan(
                    text: ' require you to ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'PermanentMarker'),
                  ),
                  TextSpan(
                    text: 'REPURCHASE',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'PermanentMarker'),
                  ),
                  TextSpan(
                    text: ' the app.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'PermanentMarker'),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  sub.cancel();
                  Navigator.pushNamed(
                    context,
                    FailPage.id,
                  );
                },
                child: Text("YES"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;

    return Screenshot(
      controller: _controller,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/rope.jpg"), fit: BoxFit.cover)),
          child: Scaffold(
            appBar: AppBar(
              leading: Container(),
              backgroundColor: Colors.transparent,
              title: Text(
                'FOCUSING ON...',
                style: TextStyle(fontSize: 30),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          args,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'PermanentMarker',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        '${formatMMSS(_current)}\nremaining',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'PermanentMarker',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: FlatButton(
                        color: Colors.grey,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        onPressed: () {
                          // ignore: unnecessary_statements
                          _showMyDialog();

//                          Navigator.pushNamed(
//                            context,
//                            MainPage.id,
//                          );
                        },
                        child: Container(
                          width: 120,
                          child: Text(
                            'QUIT',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            strutStyle: StrutStyle(
                              forceStrutHeight: true,
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ),
      ),
    );
  }
}

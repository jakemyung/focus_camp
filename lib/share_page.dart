import 'package:flutter/material.dart';
import 'menu_button.dart';
import 'focusing_page.dart';

import 'package:flutter_share/flutter_share.dart';

import 'package:screenshot/screenshot.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SharePage extends StatefulWidget {
  static const String id = 'share_page';
  final String willFocusOn;

  SharePage({Key key, this.willFocusOn}) : super(key: key);
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Requesting Check-in',
        text:
            'I am going to focus by not using my phone for the next one hour. '
            'Please check in with me after an hour if I made it!',
        linkUrl: '',
        chooserTitle: 'Request Check-in');
  }

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;

    print('focusingOn from warning page is $args');

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/dumbell_metal.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Recommendation',
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
                    Icons.textsms,
                    color: Colors.white,
                  ),
                )),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Text(
                    'Ask a friend \nto check in with you after '
                    'an hour if you have focused!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: FlatButton(
                    color: Colors.grey,
                    padding: EdgeInsets.all(0.0),
                    splashColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    onPressed: share,
                    child: Container(
                      width: 120,
                      child: Text(
                        'Ask a Friend',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(
                          forceStrutHeight: true,
                        ),
                      ),
                    ),
                  )),
            ),
            MenuButton(
              title: 'start',
              screen: FocusingPage.id,
              focusingOn: args,
            ),
            Expanded(child: Container()),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

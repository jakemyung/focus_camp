import 'package:flutter/material.dart';
import 'menu_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'share_page.dart';

class WarningPage extends StatefulWidget {
  static const String id = 'warning_page';
  final String willFocusOn;

  WarningPage({Key key, this.willFocusOn}) : super(key: key);
  @override
  _WarningPageState createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> {
  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bar.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'WARNING',
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
                  child: FaIcon(
                    FontAwesomeIcons.exclamationTriangle,
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
                      text: 'Exiting out of this session early ',
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
                          text: ' require you to ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'PermanentMarker'),
                        ),
                        TextSpan(
                          text: 'REPURCHASE',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'PermanentMarker'),
                        ),
                        TextSpan(
                          text:
                              ' the app. That\'s \$10! Are you sure you want to start?',
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
            MenuButton(
              title: 'start',
              screen: SharePage.id,
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

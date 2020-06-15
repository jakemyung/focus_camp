import 'package:flutter/material.dart';
import 'menu_button.dart';
import 'warning_page.dart';

class FocusInputPage extends StatefulWidget {
  static const String id = 'focus_input_page';

  @override
  _FocusInputPageState createState() => _FocusInputPageState();
}

class _FocusInputPageState extends State<FocusInputPage> {
  String toDoString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/rack_mirror.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'INPUT TASK',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  border: Border.all(
                    color: Colors.white,
                    width: 6,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    maxLength: 150,
                    maxLengthEnforced: true,
                    onChanged: (text) {
                      setState(() {
                        toDoString = text;
                      });
                    },
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(0),
                      enabledBorder: null,
                      disabledBorder: null,
                      focusedBorder: null,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            MenuButton(
              title: 'start focusing!',
              screen: WarningPage.id,
              focusingOn: toDoString,
            ),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

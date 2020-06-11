import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key key,
    this.title,
    this.screen,
    this.focusingOn,
  }) : super(key: key);
  final String title;
  final String screen;
  final String focusingOn;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: FittedBox(
          fit: BoxFit.contain,
          child: RaisedButton(
            elevation: 2,
            color: Colors.grey,
            padding: EdgeInsets.all(0.0),
            splashColor: Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: () {
              print(focusingOn);
              Navigator.pushNamed(
                context,
                screen,
                arguments: focusingOn,
              );
            },
            child: Container(
              width: 120,
              child: Text(
                title,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                ),
              ),
            ),
          )),
    );
  }
}

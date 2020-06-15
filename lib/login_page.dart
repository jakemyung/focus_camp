import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'main_page.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

final FirebaseAuth _auth = FirebaseAuth.instance;
void _showButtonPressDialog(BuildContext context, String provider) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('$provider Button Pressed!'),
    backgroundColor: Colors.black26,
    duration: Duration(milliseconds: 400),
  ));
}

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool showSpinner = false;

  GoogleSignInAccount _currentUser;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      setState(() {
        showSpinner = true;
      });
      await _googleSignIn.signIn();
      setState(() {
        showSpinner = false;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void addUserToFirebase() async {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await _currentUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
  }

  void moveOn() async {
    showSpinner = true;

    await addUserToFirebase();
    showSpinner = false;
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainPage.id, (Route<dynamic> route) => false,
        arguments: true);
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      moveOn();
      return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
              ),
            ),
            Card(
              elevation: 2,
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " Focus Camp ",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Column(),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
    } else {
      return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
              ),
            ),
            Card(
              elevation: 2,
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " Focus Camp ",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.85,
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: _handleSignIn,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/dumbell_2.jpg"), fit: BoxFit.cover)),
      child: _buildBody(),
    ));
  }
}

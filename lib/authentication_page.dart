import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'main_page.dart';
import 'login_page.dart';

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

class AuthenticationPage extends StatefulWidget {
  static const String id = 'authentication_page';

  @override
  State createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationPage> {
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

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    _currentUser=null;
  }

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

  Widget _buildBody() {
    showSpinner = true;

    if (_currentUser != null) {
      addUserToFirebase();
      showSpinner = false;

      return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: _currentUser,
              ),
              title: Text(_currentUser.displayName ?? ''),
              subtitle: Text(_currentUser.email ?? ''),
            ),
            const Text("Signed in successfully."),
            RaisedButton(
              child: const Text('SIGN OUT'),
              onPressed: _handleSignOut,
            ),
            RaisedButton(
              child: const Text('Main Screen'),
              onPressed: () {
                _currentUser = null;
                Navigator.pop(context);
              },
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
                  Opacity(
                    opacity: 0.85,
                    child: SignInButton(
                      Buttons.Facebook,
                      onPressed: () {
                        _showButtonPressDialog(context, 'Facebook');
                      },
                    ),
                  ),
                  Opacity(
                    opacity: 0.85,
                    child: SignInButton(
                      Buttons.Apple,
                      onPressed: () {
                        _showButtonPressDialog(context, 'Apple');
                      },
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

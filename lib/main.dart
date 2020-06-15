import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'main_page.dart';
import 'focus_input_page.dart';
import 'focusing_page.dart';
import 'warning_page.dart';
import 'fail_page.dart';
import 'success_page.dart';
import 'login_page.dart';
import 'authentication_page.dart';
import 'share_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'PermanentMarker',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cursorColor: Colors.white,
        ),
        initialRoute: LoginPage.id,
        routes: {
          MainPage.id: (context) => MainPage(),
          FocusInputPage.id: (context) => FocusInputPage(),
          FocusingPage.id: (context) => FocusingPage(),
          WarningPage.id: (context) => WarningPage(),
          FailPage.id: (context) => FailPage(),
          SuccessPage.id: (context) => SuccessPage(),
          LoginPage.id: (context) => LoginPage(),
          AuthenticationPage.id: (context) => AuthenticationPage(),
          SharePage.id: (context) => SharePage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

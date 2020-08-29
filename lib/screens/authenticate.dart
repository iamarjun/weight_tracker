import 'package:flutter/material.dart';
import 'package:weight_tracker/screens/register.dart';
import 'package:weight_tracker/screens/sign_in.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = false;

  void toggleView() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignIn
        ? SignIn(
            toggleView: toggleView,
          )
        : Register(
            toggleView: toggleView,
          );
  }
}

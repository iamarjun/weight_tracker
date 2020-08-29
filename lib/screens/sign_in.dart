import 'package:flutter/material.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/service/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Container(
          child: RaisedButton(
            onPressed: () async {
              dynamic result = await _authService.signInAnonymous();
              if (result != null) {
                debugPrint('signed in');
                print(result);
              } else {
                debugPrint('error signin in');
              }
            },
            child: Text('Sing In'),
          ),
        ),
      ),
    );
  }
}

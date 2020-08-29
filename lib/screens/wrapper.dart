import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/models/user.dart';
import 'package:weight_tracker/screens/home_page.dart';
import 'package:weight_tracker/screens/sign_in.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      child: user != null ? MyHomePage(title: 'Weight Tracker',) : SignIn(),
    );
  }
}

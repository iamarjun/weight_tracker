import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/models/user.dart';
import 'package:weight_tracker/screens/authenticate.dart';
import 'package:weight_tracker/screens/home_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      child: user != null
          ? MyHomePage(
              title: 'Weight Tracker',
            )
          : Authenticate(),
    );
  }
}

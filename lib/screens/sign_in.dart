import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/service/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  AuthService _authService;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Email',
                    border: InputBorder.none,
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String email) {
                    return EmailValidator.validate(email)
                        ? null
                        : 'Please enter a valid email';
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _passwordTextController,
                  onTap: () {},
                  obscureText: true,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: InputBorder.none,
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String password) {
                    Pattern pattern =
                        r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(password))
                      return '''Password that must contain at least one letter, at least one number, and be longer than six charaters''';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                RaisedButton(
                  child: Text('Sign In'),
                  onPressed: () async {
                    // dynamic result = await _authService.signInAnonymous();
                    // if (result != null) {
                    //   debugPrint('signed in');
                    //   print(result);
                    // } else {
                    //   debugPrint('error signin in');
                    // }

                    if (_formKey.currentState.validate()) {
                      print(_emailTextController.text);
                      print(_passwordTextController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

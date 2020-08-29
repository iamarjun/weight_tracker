import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/service/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({Key key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  AuthService _authService;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;
  TextEditingController _reEnterPasswordTextController;

  bool _obscureText;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _obscureText = false;
    _authService = AuthService();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _reEnterPasswordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(
          'Register',
        ),
        actions: [
          FlatButton(
            onPressed: () => widget.toggleView(),
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
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
                  obscureText: !_obscureText,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => _toggle(),
                    ),
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
                  height: 15,
                ),
                TextFormField(
                  controller: _reEnterPasswordTextController,
                  onTap: () {},
                  obscureText: !_obscureText,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => _toggle(),
                    ),
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
                  color: Colors.blue,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate() &&
                        _passwordTextController.text ==
                            _reEnterPasswordTextController.text) {
                      var email = _emailTextController.text;
                      var passowrd = _passwordTextController.text;

                      print(email);
                      print(passowrd);

                      dynamic result = await _authService
                          .registerWithEmailAndPassword(email, passowrd);
                      if (result != null) {
                        print('registered');
                        print(result);
                      } else {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Something went wrong'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
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

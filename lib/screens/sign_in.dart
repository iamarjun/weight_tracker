import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/screens/loading.dart';
import 'package:weight_tracker/service/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({Key key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  AuthService _authService;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;

  bool _obscureText;
  bool _loading;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _obscureText = false;
    _loading = false;
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
        actions: [
          FlatButton(
            onPressed: () => widget.toggleView(),
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _loading
          ? Loading()
          : Center(
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
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });

                            print(_emailTextController.text);
                            print(_passwordTextController.text);

                            var email = _emailTextController.text;
                            var passowrd = _passwordTextController.text;

                            print(email);
                            print(passowrd);

                            dynamic result = await _authService
                                .signInWithEmailAndPassword(email, passowrd);
                            if (result != null) {
                              print('signed in');
                              print(result);
                            } else {
                              setState(() {
                                _loading = false;
                              });

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

import 'package:flutter/material.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/screens/weight_chart.dart';
import 'package:weight_tracker/service/auth.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  DateTime _selectedDate;
  TextEditingController _controller;
  AuthService _authService;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _controller.text = _selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  void _resetDate() {
    setState(() {
      _controller.text = '';
    });
  }

  void _addWeight() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Add a record',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Weight',
                        border: InputBorder.none,
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                        return value.contains('@')
                            ? 'Do not use the @ char.'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      controller: _controller,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.date_range),
                        hintText: 'Add Date',
                        border: InputBorder.none,
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                        return value.contains('@')
                            ? 'Do not use the @ char.'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlineButton(
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        color: Colors.grey[200],
                        child: Text('Cancel'),
                        onPressed: () {
                          _resetDate();
                          Navigator.of(context).pop();
                        },
                      ),
                      MaterialButton(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _controller = TextEditingController();
    _authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FlatButton(
            onPressed: () async {
              _authService.signOut();
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: WeightChart(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWeight,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

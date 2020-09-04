import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/models/user.dart';
import 'package:weight_tracker/models/weight_record.dart';
import 'package:weight_tracker/screens/weight_chart.dart';
import 'package:weight_tracker/service/auth.dart';
import 'package:weight_tracker/service/database.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _dateController;
  TextEditingController _weightController;
  AuthService _authService;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
  }

  void _resetDate() {
    setState(() {
      _dateController.text = DateTime.now().toLocal().toString().split(' ')[0];
    });
  }

  void _addWeight(DatabaseService db) {
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Add a record',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        decoration: const InputDecoration(
                          hintText: 'Weight',
                          border: InputBorder.none,
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return int.parse(value) > 130
                              ? 'Weight limit exceeded.'
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
                        readOnly: true,
                        showCursor: false,
                        controller: _dateController,
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              var weight = _weightController.text;
                              var date = _dateController.text;
                              db.addWeightRecord(weight, date);
                              _resetDate();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
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
    _dateController = TextEditingController();
    _weightController = TextEditingController();
    _authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return MultiProvider(
        providers: [
          Provider<DatabaseService>(
            create: (context) => DatabaseService(uid: user.uid),
          )
        ],
        builder: (context, _) {
          final db = Provider.of<DatabaseService>(context, listen: false);
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
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            body: Center(
              child: StreamProvider<List<WeightRecord>>(
                create: (context) => db.weightRecords,
                builder: (context, child) => WeightChart(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addWeight(db),
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
          );
        });
  }
}

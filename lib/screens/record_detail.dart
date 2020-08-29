import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/colors.dart';
import 'package:weight_tracker/models/weight_record.dart';
import 'package:weight_tracker/service/database.dart';

class RecordDetail extends StatefulWidget {
  final DatabaseService databaseService;
  final String title;
  RecordDetail({Key key, this.databaseService, this.title}) : super(key: key);

  @override
  _RecordDetailState createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  var _weightController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  void _deleteRecord(WeightRecord weightRecord) async {
    await widget.databaseService.deleteWeightRecord(weightRecord.date);
  }

  void _editRecord(WeightRecord weightRecord) {
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
                      'Edit record',
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
                              ? 'Weight limit exceeded'
                              : null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
                              widget.databaseService
                                  .addWeightRecord(weight, weightRecord.date);
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
  Widget build(BuildContext context) {
    return StreamProvider<List<WeightRecord>>(
      create: (context) => widget.databaseService.weightRecords,
      child: Consumer<List<WeightRecord>>(
        builder: (context, list, _) => Scaffold(
          backgroundColor: AppColors.primaryColor,
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Container(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(
                    Icons.line_weight,
                    color: Colors.white,
                  ),
                  title: Text(
                    list[index].date,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Weight: ${list[index].weight}Kg',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Wrap(
                    children: [
                      Visibility(
                        visible: list.length > 2,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => {
                            _deleteRecord(
                              list.removeAt(index),
                            ),
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () => _editRecord(list[index]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/models/item.dart';

class AddToDoScreen extends StatefulWidget {
  static const routeName = 'add-screen';
  @override
  _AddToDoScreenState createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  var _isInit = true;
  var _newItem = Items(
    id: null,
    title: '',
    description: '',
  );

  var _initialValues = {
    'title': '',
    'description': '',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final itemId = ModalRoute.of(context).settings.arguments as String;
      if (itemId != null) {
        _newItem = Provider.of<ItemsList>(context).findById(itemId);
      }
    }
    _isInit = false;
  }

  void onSubmit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    if (_newItem.id == null) {
      setState(
        () {
          Provider.of<ItemsList>(context, listen: false).addItem(
            _newItem,
            _selectedDate.toIso8601String(),
            _selectedTime.toString(),
          );
        },
      );
    }
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then(
      (_pickedDate) {
        if (_pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = _pickedDate;
        });
      },
    );
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((_pickedTime) {
      if (_pickedTime == null) {
        return;
      }
      setState(() {
        _selectedTime = _pickedTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add To-Do task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initialValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                    _descriptionFocusNode,
                  );
                },
                onSaved: (value) {
                  _newItem = Items(
                    id: _newItem.id,
                    title: value,
                    description: _newItem.description,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                maxLines: 2,
                onSaved: (value) {
                  _newItem = Items(
                    id: _newItem.id,
                    title: _newItem.title,
                    description: value,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      (_selectedDate == null || _selectedTime == null)
                          ? 'No Date/Time Chosen'
                          : 'Picked Date and Time:  ' +
                              '\n' +
                              '\n' +
                              '${_selectedTime.format(context)},' +
                              '\n' +
                              '${DateFormat.yMMMd().format(_selectedDate)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Choose Date/Time',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100),
              Container(
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: onSubmit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

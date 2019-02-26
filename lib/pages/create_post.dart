import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import '../types/post.dart';

class PostCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostCreatePageState();
  }
}

List<String> rinks = ["Canlan", "Port Credit", "Scotia", null];

class _PostCreatePageState extends State<PostCreatePage> {
  double _currentPrice = 100;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //List<String> rinks = ["Canlan", "Port Credit", "Scotia"];
  final Map<String, dynamic> _formData = {
    "title": null,
    "date": DateTime.now(),
    "description": null,
    "selectedRink": "Canlan",
    "price": null,
    "image":
        'https://i1.wp.com/www.benaco.ca/wp-content/uploads/2015/10/05.jpg?fit=954%2C537'
  };

//METHOD
  void _submitForm(Function addPost) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    _formData['price'] = 222.0;
    addPost(
        _formData['title'],
        _formData['description'],
        _formData['selectedRink'],
        _formData["date"],
        _formData['image'],
        _formData['price']);
    Navigator.pushReplacementNamed(context, '/posts');
  }

//WIDGET
  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RaisedButton(
        child: Text('Save'),
        color: Theme.of(context).primaryColorDark,
        textColor: Colors.white,
        onPressed: () {
          _submitForm(model.addPost);
        },
      );
    });
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.decimal(
            minValue: 10,
            maxValue: 500,
            title: new Text("Pick a new price"),
            initialDoubleValue: 100.0,
          );
        }).then((int value) {
      if (value != null) {
        setState(() => _currentPrice = value / 1);
      }
    });
  }

  //BUILD METHOD
  @override
  Widget build(BuildContext context) {
    DateTime day;
    List<DropdownMenuItem<String>> mydrop = [
      DropdownMenuItem<String>(child: Text("canlan")),
      DropdownMenuItem<String>(child: Text("port credit")),
      DropdownMenuItem<String>(child: Text("IceLand")),
      DropdownMenuItem<String>(child: Text("F"))
    ];
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Post Title'),
              validator: (String value) {
                if (value.trim().length <= 0) {
                  return 'Title is required';
                }
              },
              onSaved: (String value) {
                _formData["title"] = value;
              },
            ),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Post Description'),
              validator: (String value) {
                if (value.trim().length <= 0) {
                  return 'Description is required';
                }
              },
              onSaved: (String value) {
                _formData["description"] = value;
              },
            ),
            TextFormField(
                decoration: new InputDecoration(labelText: "Enter your number"),
                keyboardType: TextInputType.number),
            /*FloatingActionButton(
                child: new Icon(Icons.attach_money), onPressed: _showDialog),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Post Price'),
              onSaved: (String value) {
                _formData["price"] = double.parse(value);
              },
            ),
            DropdownButton<String>( //IDK WHAT IS GOING ON WITH THIS 
                //hint: Text("test"),
                value: _formData["selectedRink"],
                onChanged: (String newValue) {
                  setState(() {
                    _formData["selectedRink"] = newValue;
                  });
                },
                items: mydrop),*/
            SizedBox(
              height: 10.0,
            ),
            Center(child: Container(child: Text(_formData['date'].toString()))),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Select Date'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: () {
                showDatePicker(
                        firstDate: DateTime.now().add(new Duration(days: -60)),
                        lastDate: DateTime.now().add(new Duration(days: 60)),
                        initialDate: DateTime.now(),
                        context: context)
                    .then((DateTime result) {
                  day = result;
                });
                ;
              },
            ),
            RaisedButton(
              child: Text('Select Time'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              onPressed: () {
                showTimePicker(
                  initialTime: TimeOfDay(hour: 15, minute: 0),
                  context: context,
                ).then((TimeOfDay result) {
                  day = day.add(
                      Duration(hours: result.hour, minutes: result.minute));
                  _formData["date"] = day;
                });
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}

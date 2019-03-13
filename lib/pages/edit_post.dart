import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import '../types/post.dart';

class PostEditPage extends StatefulWidget {
  final int index;
  PostEditPage(this.index);

  @override
  State<StatefulWidget> createState() {
    return _PostEditPageState();
  }
}

List<String> rinks = ["Canlan", "Port Credit", "Scotia", null];

class _PostEditPageState extends State<PostEditPage> {
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
  //METHOD need this to delete current post and return to edit page
  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

//METHOD
  void _submitForm(Function updatePost) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    updatePost(
        _formData['title'],
        _formData['description'],
        _formData['selectedRink'],
        _formData["date"],
        _formData['image'],
        _formData['price']);
    Navigator.pop(context);
  }

//WIDGET
  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(//might be able to gas this........
        builder: (BuildContext context, Widget child, MainModel model) {
      return RaisedButton(
        child: Text('Save'),
        color: Theme.of(context).primaryColorDark,
        textColor: Colors.white,
        onPressed: () {
          _submitForm(model.updatePost);
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

    return WillPopScope(onWillPop: () {
      print('Back button pressed!');
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: Container(child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Post currPost = model.posts[widget.index];
      _formData["price"] = currPost.price;
      _formData["title"] = currPost.title;
      _formData["description"] = currPost.description;
      _formData["date"] = currPost.date;
      return Scaffold(
          appBar: AppBar(
            title: Text(currPost.title),
          ),
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: currPost.title,
                    decoration: InputDecoration(labelText: "Title"),
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
                    initialValue: currPost.description,
                    decoration: InputDecoration(labelText: "description"),
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
                      initialValue: currPost.price.toString(),
                      decoration: new InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                      child: Container(child: Text(currPost.date.toString()))),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Select Date'),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: () {
                      showDatePicker(
                              firstDate:
                                  DateTime.now().add(new Duration(days: -60)),
                              lastDate:
                                  DateTime.now().add(new Duration(days: 60)),
                              initialDate: currPost.date,
                              context: context)
                          .then((DateTime result) {
                        day = result;
                      });
                      ;
                    },
                  ),
                  RaisedButton(
                    child: Text(currPost.date.toString()),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: () {
                      showTimePicker(
                        initialTime: TimeOfDay(hour: 15, minute: 0),
                        context: context,
                      ).then((TimeOfDay result) {
                        day = day.add(Duration(
                            hours: result.hour, minutes: result.minute));
                        _formData["date"] = day;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildSubmitButton(),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      color: Colors.redAccent,
                      child: Text('DELETE Does not work'),
                      onPressed: () => _showWarningDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          ));
    })));
  }
}

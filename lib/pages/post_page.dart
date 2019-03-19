import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import '../types/post.dart';

//This is the page when u click on a booking or product

class PostPage extends StatelessWidget {
  final String postID;

  PostPage(this.postID);

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

  @override
  Widget build(BuildContext context) {
    print("in post build");
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        model.selectPost(postID);
        final Post currPost = model.selectedPost;
        return Scaffold(
          appBar: AppBar(
            title: Text("Book Now!"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(currPost.img),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Title" + currPost.title),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Price" + currPost.price.toString()),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Description" + currPost.description),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('BOOK'),
                  onPressed: () => _showWarningDialog(context),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

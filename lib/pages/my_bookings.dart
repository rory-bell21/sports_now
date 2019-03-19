import 'package:flutter/material.dart';
import 'package:sports_now/Other/post_displayer.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import 'package:sports_now/widgets/hamburger_menu.dart';

class MyBookingsPage extends StatefulWidget {
  final MainModel model;
  MyBookingsPage(this.model);
  @override
  createState() {
    return MyBookingsPageState();
  }
}

class MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    widget.model.fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HamburgerMenu("anything for now"),
        appBar: AppBar(
          title: Text('My Bookings'),
        ),
        body: Column(
          children: [Expanded(child: PostDisplayer("CHANGE THIS"))],
        ));
  }
}

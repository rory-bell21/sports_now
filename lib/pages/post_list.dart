import 'package:flutter/material.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import 'package:sports_now/widgets/hamburger_menu.dart';

import '../Other/post_displayer.dart';

//import '../posts.dart';

//this is the main page
class PostListPage extends StatefulWidget {
  final MainModel model;
  PostListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return PostListPageState();
  }
}

class PostListPageState extends State<PostListPage> {
  @override
  void initState() {
    widget.model.fetchAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HamburgerMenu("anything here rn"),
        appBar: AppBar(
          title: Text('SportsNow'),
        ),
        body: Column(
          children: [Expanded(child: PostDisplayer())],
        ));
  }
}

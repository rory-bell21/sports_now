import 'package:flutter/material.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import 'package:sports_now/widgets/hamburger_menu.dart';

import '../Other/post_displayer.dart';

//import '../posts.dart';

//this is the main page to scroll through posts
class PostListPage extends StatefulWidget {
  final MainModel model;
  PostListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return PostListPageState();
  }
}

class PostListPageState extends State<PostListPage> {
  TextEditingController controller = new TextEditingController();
  String filter;
  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    widget.model.fetchAllPosts();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HamburgerMenu("anything here rn"),
        appBar: AppBar(
          title: Text('SportsNow'),
        ),
        body: Column(
          children: [
            TextField(
              decoration: new InputDecoration(labelText: "Search something"),
              controller: controller,
            ),
            Expanded(child: PostDisplayer(filter))
          ],
        ));
  }
}

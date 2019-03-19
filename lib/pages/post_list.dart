import 'package:flutter/material.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import 'package:sports_now/widgets/hamburger_menu.dart';

import '../Other/post_displayer.dart';

//import '../posts.dart';

//this is the main page to scroll through posts
class PostListPage extends StatefulWidget {
  String newValue;

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
    widget.model.fetchPosts();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> filterOptions = [
      DropdownMenuItem<String>(value: "Date", child: Text("Date")),
      DropdownMenuItem<String>(value: "Title", child: Text("Title"))
    ];
    return Scaffold(
        drawer: HamburgerMenu("anything here rn"),
        appBar: AppBar(
          title: Text('SportsNow'),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              ),
              controller: controller,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Filters",
                    textAlign: TextAlign.center,
                    //style: TextStyle(fontWeight: FontWeight.bold)
                  )),
                  Expanded(
                    child: DropdownButton<String>(
                      value: "Date",
                      items: filterOptions,
                      onChanged: (String newValue) {
                        setState(() {
                          //CALL A METHOD IN CONNECTED TO SORT
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: PostDisplayer(filter))
          ],
        ));
  }
}

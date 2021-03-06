import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sports_now/pages/edit_post.dart';
import 'package:sports_now/scoped_models/main_model.dart';

import '../types/post.dart';

//import 'scoped_models/posts_model.dart';
//import 'types/post.dart';

class PostDisplayer extends StatelessWidget {
  String filter;
  PostDisplayer(this.filter);

  //method
  Widget _buildPostItem(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Post currPost = model.allPosts[index];
      if (filter == null ||
          filter == "" ||
          currPost.title.toLowerCase().contains(filter.toLowerCase())) {
        return Card(
          child: Row(
            children: <Widget>[
              Flexible(child: Image.network(currPost.img)),
              Column(
                children: <Widget>[
                  Text("IDD: " + currPost.id),
                  Text("Title: " + currPost.title),
                  Text("Price: " + currPost.price.toString()),
                  Text("Description: " + currPost.description),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Book'),
                          onPressed: () {
                            model.selectPost(currPost.id);
                            Navigator.pushNamed<bool>(
                                context, '/post/' + currPost.id);
                          }
                          //specifying a page to push to stack?,
                          )
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      }
      return Card();
    });
  }

  //method
  Widget _buildPostList(List<Post> posts) {
    Widget postCards;
    if (posts.length > 0) {
      postCards = ListView.builder(
        itemBuilder: _buildPostItem,
        itemCount: posts.length,
      );
    } else {
      postCards = Container();
    }
    return postCards;
  }

  //BUILD Method
  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
        model.fetchPosts();
      return _buildPostList(model.allPosts);
    });
  }
}

class EditPostPage {}

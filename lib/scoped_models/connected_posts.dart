import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:sports_now/types/post.dart';
import 'package:sports_now/types/user.dart';
import 'package:http/http.dart' as http;

//CONNECTEDPOST MODEL*****************
mixin ConnectedPosts on Model {
  List<Post> posts = [];
  List<Post> myPosts = [];
  User authenticatedUser;
  int selPostIndex;
  int selMyPostIndex;

  Future<Null> addPost(String title, String description, String selectedRink,
      DateTime date, String img, double price) {
    Post currPost = Post(
        userEmail: authenticatedUser.email,
        userID: authenticatedUser.id,
        title: title,
        description: description,
        selectedRink: selectedRink,
        date: date,
        img: img,
        price: price);
    final Map<String, dynamic> postData = {
      //convert to format for DB
      'title': currPost.title,
      'description': currPost.description,
      'image': currPost.img,
      'price': currPost.price,
      'date': currPost.date.toString(),
      'selectedRink': currPost.selectedRink,
      'userEmail': authenticatedUser.email,
      'userID': authenticatedUser.id
    };
    http
        .post('https://sportsnow-4e1cf.firebaseio.com/posts.json',
            body: json.encode(postData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Post newPost = Post(
        id: responseData["name"],
        title: currPost.title,
        description: currPost.description,
        selectedRink: currPost.selectedRink,
        price: currPost.price,
        userEmail: authenticatedUser.email,
        userID: authenticatedUser.id,
        date: currPost.date,
        img: currPost.img,
      );
      posts.add(newPost);
    });
  }
}

//POSTMODEL******************
mixin PostsModel on ConnectedPosts {
  List<Post> get allPosts {
    return List.from(posts); //pass by value
  }

  Future<Null> fetchPosts() {
    http
        .get('https://sportsnow-4e1cf.firebaseio.com/posts.json')
        .then((http.Response response) {
      final List<Post> fetchedPosts = [];
      final Map<String, dynamic> postData = json.decode(response.body);
      postData.forEach((String postID, dynamic postData) {
        final Post currPost = Post(
          id: postID,
          title: postData['title'],
          description: postData['description'],
          selectedRink: postData['selectedRink'],
          price: postData['price'],
          date: DateTime.parse(postData['date']),
          img: postData['image'],
          userID: postData['userID'],
          userEmail: postData['userEmail'],
        );
        fetchedPosts.add(currPost);
      });
      posts = fetchedPosts;
      notifyListeners();
    });
  }

  Future<Null> updatePost(String title, String description, String selectedRink,
      DateTime date, String img, double price) {
    notifyListeners();
    final Map<String, dynamic> updateData = {
      //convert to format for DB
      'title': title,
      'description': description,
      'image': selectedPost.img,
      'price': price,
      'date': date.toString(),
      'selectedRink': selectedPost.selectedRink,
      'userEmail': authenticatedUser.email,
      'userID': authenticatedUser.id
    };
    return http
        .put(
            'https://sportsnow-4e1cf.firebaseio.com/posts/${selectedPost.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      final Post updatedPost = Post(
          id: selectedPost.id,
          title: title,
          description: description,
          img: img,
          date: selectedPost.date,
          selectedRink: selectedPost.selectedRink,
          price: price,
          userEmail: selectedPost.userEmail,
          userID: selectedPost.userID);
      posts[selectedPostIndex] = updatedPost;
      notifyListeners();
    });
  }

//--------------------------------
  void fetchAllPosts() {
    http
        .get('https://sportsnow-4e1cf.firebaseio.com/posts.json')
        .then((http.Response response) {
      final List<Post> fetchedPosts = [];
      final Map<String, dynamic> postData = json.decode(response.body);
      postData.forEach((String postID, dynamic postData) {
        if (postID != null) {
          final Post currPost = Post(
              id: postID,
              title: postData['title'],
              description: postData['description'],
              selectedRink: postData['selectedRink'],
              price: postData['price'],
              date: DateTime.parse(postData['date']),
              img: postData['image'],
              userEmail: postData['userEmail'],
              userID: postData['userID']);
          fetchedPosts.add(currPost);
        }
      });
      posts = fetchedPosts;
      notifyListeners();
    });
  }

//special ones for myposts list
  void selectMyPost(int index) {
    selMyPostIndex = index;
    notifyListeners();
  }

  Post get selectedMyPost {
    if (selMyPostIndex == null) {
      return null;
    }
    return myPosts[selMyPostIndex];
  }

  void selectPost(int index) {
    selPostIndex = index;
    notifyListeners();
  }

  Post get selectedPost {
    if (selPostIndex == null) {
      return null;
    }
    return posts[selPostIndex];
  }

  int get selectedMyPostIndex {
    return selMyPostIndex;
  }

  int get selectedPostIndex {
    return selPostIndex;
  }

  void deletePost(int index) {
    final deletedPostID = selectedPost;
    http
        .delete(
            'https://sportsnow-4e1cf.firebaseio.com/posts/${selectedPost.id}.json')
        .then((http.Response response) {
      posts.removeAt(index);
    });
    notifyListeners();
  }
}

//USER MODEL********************************
mixin UserModel on ConnectedPosts {
  void login(String email, String password) {
    authenticatedUser = User(id: 'vfvfv', email: email, password: password);
  }
}

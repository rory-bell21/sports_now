import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:sports_now/types/post.dart';
import 'package:sports_now/types/user.dart';
import 'package:http/http.dart' as http;

//CONNECTEDPOST MODEL*****************
mixin ConnectedPosts on Model {
  List<Post> posts = [];
  List<Post> myPosts = [];
  bool _isLoading = false;
  User authenticatedUser;
  int selPostIndex;
  int selMyPostIndex;
  String selPostID;

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

//*******************************************************POSTMODEL*******************************************************
mixin PostsModel on ConnectedPosts {
  void sortPosts() {
    allPosts.sort((a, b) => a.title.compareTo(b.title));
  }

  //get all the posts in a list
  List<Post> get allPosts {
    return List.from(posts); //pass by value
  }

  //returns the selected post
  Post get selectedPost {
    if (selPostID == null) {
      return null;
    }
    return posts.firstWhere((Post post) {
      return post.id == selPostID;
    });
  }

  //select a post based on the id
  void selectPost(String postId) {
    selPostID = postId;
    if (postId != null) {
      notifyListeners();
    }
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
  void fetchPosts() {
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

  //do we need?
  /*Post get selectedMyPost {
    if (selMyPostIndex == null) {
      return null;
    }
    return myPosts[selMyPostIndex];
  }*/
  //int get selectedMyPostIndex {
  //  return selMyPostIndex;
  //}

  //need
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
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDXdle-9OnW8ZBFhCrHdq-0Jb9u10Df8k8',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDXdle-9OnW8ZBFhCrHdq-0Jb9u10Df8k8',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}
mixin UtilityModel on ConnectedPosts {
  bool get isLoading {
    return _isLoading;
  }
}

import 'package:flutter/material.dart';
import 'package:sports_now/pages/auth.dart';
import 'package:sports_now/pages/edit_post.dart';
import 'package:sports_now/pages/info_page.dart';
import 'package:sports_now/pages/manage_posts.dart';
import 'package:sports_now/pages/my_bookings.dart';
import 'package:sports_now/pages/post_page.dart';
import 'package:sports_now/pages/post_list.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:sports_now/scoped_models/main_model.dart';

// import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        //passes scoped model down widget tree
        model: model,
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.grey,
              fontFamily: "assets/Oswald-Bottfld.ttf"),
          // home: AuthPage(),
          routes: {
            //This allows you to specify these keys from other classes to navigate
            '/': (BuildContext context) => AuthPage(),
            '/posts': (BuildContext context) => PostListPage(model),
            '/bookings': (BuildContext context) => MyBookingsPage(model),
            '/admin': (BuildContext context) => ManagePosts(model),
            '/info': (BuildContext context) => InfoPage(),
            //'/post': (BuildContext context) => InfoPage(),
            //'/edit' : (BuildContext context) => PostEditPage(),
          },
          //below gets called when name not in routes, dynamically pass data too post page....
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'post') {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => PostPage(index),
              );
            } else if (pathElements[1] == 'edit') {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => PostEditPage(index),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => PostListPage(model));
          },
        ));
  }
}

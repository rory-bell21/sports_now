import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:sports_now/types/post.dart';
import 'package:sports_now/types/user.dart';
import './connected_posts.dart';

class MainModel extends Model
    with ConnectedPosts, UserModel, PostsModel, UtilityModel {}

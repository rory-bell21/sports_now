import 'package:scoped_model/scoped_model.dart';
import '../types/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String password;

  User({@required this.id, @required this.email, @required this.password});
}

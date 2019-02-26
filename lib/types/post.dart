import 'package:flutter/material.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final String selectedRink;
  final DateTime date;
  final String img;
  final double price;
  final String userEmail;
  final String userID;

  Post(
      {this.id,
      @required this.title,
      @required this.description,
      @required this.selectedRink,
      @required this.date,
      @required this.img,
      @required this.price,
      @required this.userEmail,
      @required this.userID});
}

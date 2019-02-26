import 'package:flutter/material.dart';

import 'package:sports_now/widgets/hamburger_menu.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HamburgerMenu("in info page"),
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: Text("Information regarding the app and business will go here"),
    );
  }
}

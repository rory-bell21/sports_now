import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  String currPage;

  HamburgerMenu(this.currPage);

  @override
  Widget build(BuildContext context) {
    return (Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('All Posts'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/posts');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Posts'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('My Bookings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/boookings');
            },
          ),
           ListTile(
            leading: Icon(Icons.info),
            title: Text('Info'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/info');
            },
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
    ));
  }
}

import 'package:eco_connect/Pages/Explore/explore.dart';
import 'package:eco_connect/Pages/MakePost/makepost.dart';
import 'package:eco_connect/security_code_screen.dart';
import 'package:eco_connect/Pages/ListPosts/listposts.dart';
import 'package:eco_connect/security_code_screen.dart';
import 'package:eco_connect/home.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case '/explore':
      // Validation of correct data type
        return MaterialPageRoute(builder: (_) => MyExplorePage());
      case '/makepost':
        return MaterialPageRoute(builder: (_) => MyMakePostPage());

        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
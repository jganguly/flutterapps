import 'package:flutter/material.dart';
import 'package:flutterapp/screens/screen_B.dart';

import 'acc.dart';

/// Route
class RouteGenerator {
    static Route<dynamic> generateRoute(RouteSettings settings) {
        // Getting arguments passed in while calling Navigator.pushNamed
        final args = settings.arguments;

        switch (settings.name) {
            case '/':
                return MaterialPageRoute(builder: (_) => Acc());
            case '/FormB':
                // Validation of correct data type
                if (args is String) {
                    return MaterialPageRoute( builder: (_) => FormB( data: args, ), );
                }
                return _errorRoute(); // If args is not of the correct type, return an error page. You can also throw an exception while in development.

            default:
                return _errorRoute();  // If there is no such named route in the switch statement, e.g. /third
        }
    }

    static Route<dynamic> _errorRoute() {
        return MaterialPageRoute(builder: (_) {
            return Scaffold(
                appBar: AppBar(
                    title: Text('ERROR'),
                ),
                body: Center(
                    child: Text('ERROR'),
                ),
            );
        });
    }
}
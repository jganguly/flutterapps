/// App with Tab

import 'package:flutter/material.dart';
import 'package:flutterapp/screens/Route.dart';
import 'package:flutterapp/screens/acc.dart';
import 'package:flutterapp/screens/ord.dart';
import 'package:flutterapp/screens/screen_Map.dart';

void main() => runApp(JiffyApp());

class JiffyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jiffy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomePage(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class HomePage extends StatelessWidget {
  /// TabBar
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 5,

      /// JG
      child: Scaffold(
        appBar: AppBar(
          title: Text('Jiffy',
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Roboto_Condensed',
                  color: Colors.orangeAccent)),
          bottom: PreferredSize(
            preferredSize: Size(400.0, 50.0),
            child: Container(
              width: 1000.0,
              height: 60.0,
              child: TabBar(
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 5.0, color: Colors.red),
                      insets: EdgeInsets.symmetric(horizontal: 16.0)),
                  tabs: [
                    Container(
                      height: 50.0,
                      child: Tab(
                          icon: Icon(Icons.add_shopping_cart), text: 'Order'),
                    ),
                    Container(
                      height: 50.0,
                      child: Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
                    ),
                    Container(
                      height: 50.0,
                      child: Tab(icon: Icon(Icons.schedule), text: 'Arrival'),
                    ),
                    Container(
                      height: 50.0,
                      child: Tab(
                          icon: Icon(Icons.account_balance_wallet),
                          text: 'Wallet'),
                    ),
                    Container(
                      height: 50.0,
                      child: Tab(icon: Icon(Icons.person), text: 'A/c'),
                    ),
                  ]),
            ),
          ),
        ),
        body: TabBarView(children: [
          Ord(),
          Acc(),
          Acc(),
          Acc(),
          Acc(),
//                        MyMap()
        ]),
      ),
    ));
  }
}

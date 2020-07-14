import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapp/models/jmodel.dart';
import 'package:flutterapp/screens/acc.dart';
import 'package:flutterapp/screens/ord.dart';
import 'package:http/http.dart';

/// FloatingActionButton
FloatingActionButton createFAB(BuildContext context, IconData iconData, Color iconColor, Color iconBackgroundColor, String msg) {
    return FloatingActionButton(
        child: Icon(iconData, color: iconColor),
        backgroundColor: iconBackgroundColor,
        onPressed: () {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blueAccent,
                content: Text(msg),
                duration: Duration(seconds: 2),
            ));
        }
    );
}

/// BottomNavigationBar
BottomAppBar createBottomNavBar() {
    return BottomAppBar(
        child: Row(
            children: <Widget>[
                Icon(Icons.home),
                IconButton(
                    icon: Icon(Icons.airline_seat_recline_normal),
                    tooltip: "Seating",
                    onPressed: () {
                        print("Forward");
                    },
                ),
                IconButton(
                    icon: Icon(Icons.schedule),
                    tooltip: "Flight Schedule",
                    onPressed: () {
                        print("Backward");
                    },
                )
            ],
        )
    );
}

/// PersistentFooterButtons
List<Widget> createPFB(BuildContext context) {
    return (
        <Widget>[
            IconButton(icon: Icon(Icons.account_balance),
                onPressed: () {
                    print("Clicked");
                },),
            IconButton(icon: Icon(Icons.games)),
        ]
    );
}


/// jText
// ignore: non_constant_identifier_names
TextFormField jText( IconData iconData, TextInputType textInputType, String label, String hint, String errMsg, TextEditingController ctrlText, String value, bool enabled) {

    TextStyle textStyle    = TextStyle( fontFamily: 'Roboto_Condensed', color: Colors.black, fontSize: 18 );
    TextStyle jErrorStyle   = TextStyle( fontFamily: 'Roboto_Condensed', color: Colors.orangeAccent, fontSize: 16.0 );

//    ctrlText.text = value;

    return TextFormField(
        enabled: enabled,
        keyboardType: textInputType,
        controller: ctrlText,
        style: textStyle,
        //
        decoration: InputDecoration(
            icon: Icon(iconData),
            labelText: label,
            hintText: hint, hintStyle: TextStyle(color:Colors.black26),
            labelStyle: TextStyle(color: Colors.blueAccent),
            errorStyle: jErrorStyle,
        ),
        //
        // ignore: missing_return
        validator: (String value) {
            if (value.isEmpty) {
                return validateNumber(value, errMsg);
            }
        },
        onChanged: (String value) {
            print("Value changed to: " + value);
        },
    );
}

/// Validate Number
String validateNumber(String value, String errMsg) {
    if (value.isEmpty) {
        return errMsg;
    }
    return "";
}


/// DropdownButton
DropdownButton<String> dropdownButton(List<String> listOfOptions, String itemSelected, AccState accState) {
    return (
        DropdownButton<String>(
            items: jList(listOfOptions),
            value: itemSelected,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 32,
            style: TextStyle(
                color: Colors.blueAccent, fontSize: 18.0 ),
//                underline: Container( height: 2    , color: Colors.red,),
            onChanged: (String newItemSelected) {
                // ignore: invalid_use_of_protected_member
                accState.setState(() {
                    accState.itemSelected = newItemSelected;
                });
            },
        )
    );
}

/// List
List<DropdownMenuItem<String>> jList(List<String> listOfOptions) {
    var jList = listOfOptions.map((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(fontFamily: 'Roboto_Condensed') )
        );
    }).toList();
    return jList;
}

/// showSnackBar
void showSnackBar(BuildContext context, AccState accState, String msg) {
    // ignore: invalid_use_of_protected_member
    accState.setState(() {
        Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text(msg),
            duration: Duration(seconds: 2),
        ));
    });
}

/// showSnackBar
void showSnackBar2(BuildContext context, OrdState ordState, String msg) {
    // ignore: invalid_use_of_protected_member
    ordState.setState(() {
        Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text(msg),
            duration: Duration(seconds: 2),
        ));
    });
}
/// dialog
void showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[

            FlatButton(
                child: Text("OK"),
                onPressed: () {
                    /// code on OK
                    print("OK");
                    Navigator.of(context).pop();
                },
            ),
            FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                    /// Code on cancel
                    print('Cancel');
                    Navigator.of(context).pop();
                },
            ),

        ],
    );

    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
}

/// getImage
Widget getImage(String img, double width, double height) {
    final double minimumPadding = 10.0;
    AssetImage assetImage = AssetImage(img);
    Image image = Image(
        image: assetImage,
        width: width,
        height: height,
    );

    return Container(
        child: image,
        margin: EdgeInsets.all(minimumPadding),
    );
}

/// Test
Future<DateTime> getDate(BuildContext context) async {
    // Imagine that this function is more complex and slow.
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
            return Theme(
                data: ThemeData.light(),
                child: child,
            );
        },
    );
}

/// post
Future<String> postRequest(String type, String reqJson) async {
    String url;
    if (type.compareTo("read") == 0)
        url = 'http://10.0.2.2:3001/read';
    if (type.compareTo("create") == 0)
        url = 'http://10.0.2.2:3001/create';
    if (type.compareTo("update") == 0)
        url = 'http://10.0.2.2:3001/update';

    Map<String, String> headers = {"Content-type": "application/json"};

    Response response = await post(url, headers: headers, body: reqJson);
    int statusCode = response.statusCode;
    print(statusCode);

    // this API passes back the id of the new item added to the body
    String body = response.body;
    return body;
}

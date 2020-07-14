import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/JUtil.dart';
import 'dart:convert';

class FormB extends StatefulWidget {

    final String data;

    FormB( { Key key, @required this.data }) : super(key: key);

    @override
    FormBState createState() {
        return FormBState(data);
    }
}

class FormBState extends State<FormB> {
    String data;
    String msg = "";
    var finalDate;

    FormBState(String data) {
        this.data = data;
    }

    /// Declare state variables
    final _formKey = GlobalKey<FormState>();

    var listOfOptions = ['Rupees', 'Dollars', 'Pounds'];
    var itemSelected = '';
    var displayResult = '';
    final double _minimumPadding = 5.0;
    TextEditingController ctrlText = TextEditingController();


    /// init the variables
    @override
    void initState() {
        super.initState();
        itemSelected = listOfOptions[0];
        var result = json.decode(data);
        print(data);
        print(result);
        msg = result['name'];
        print(msg);
    }

    @override
    Widget build(BuildContext context) {

        /// style
        TextStyle textStyle = Theme
            .of(context)
            .textTheme
            .title;
        TextStyle textStyle2 = TextStyle(color: Colors.black, fontSize: 16);
        TextStyle jErrorStyle = TextStyle(
            color: Colors.yellowAccent, fontSize: 16.0);
        TextEditingController ctrlText = TextEditingController();

        return Scaffold(

            /// AppBar
            appBar: AppBar(
                title: Text("Screen B"), backgroundColor: Colors.orange),

            floatingActionButton: Builder(builder: (BuildContext context) {
                return new FloatingActionButton(
                    child: Icon(Icons.beach_access, color: Colors.red),
                    backgroundColor: Colors.green,
                    onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Message " + msg),
                            duration: Duration(seconds: 5),
                        ));
                    }
                );
            }),


            /// Bottom Navigation
            bottomNavigationBar: BottomAppBar(
                child: Row(
                    children: <Widget>[
                        Icon(Icons.home),
                        IconButton(
                            icon: Icon(Icons.forward),
                            onPressed: () {
                                print("Forward");
                            },
                        ),
                        IconButton(
                            icon: Icon(Icons.backspace), tooltip: "tooltip!",
                            onPressed: () {
                                print("Backward");
                            },
                        )
                    ],
                )
            ),

            /// Persistent Footer Buttons
            persistentFooterButtons: <Widget>[
                IconButton(icon: Icon(Icons.account_balance),
                    onPressed: () {
                        print("Clicked");
                    },),
                IconButton(icon: Icon(Icons.games)),
            ],
            backgroundColor: Colors.white,

            body: Form(

                key: _formKey,

                child: ListView(

                    children: <Widget>[

                        TextFormField(
                            decoration: const InputDecoration(
                                icon: const Icon(Icons.person),
                                hintText: 'Enter your name',
                                labelText: 'Name',
                            )
                        ),

                        TextFormField(
                            keyboardType: TextInputType.phone,
                            style: textStyle2,
                            controller: ctrlText,
                            decoration: const InputDecoration(
                                icon: const Icon(Icons.phone),
                                labelText: 'Telephone',
                                hintText: 'Enter Telephone',
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 16.0),
                            ),
                            // ignore: missing_return
                            validator: (String value) {
                                if (value.isEmpty) {
                                    return ('Enter phone number');
                                }
                            },
                        ),

                        Row(
                            children: <Widget>[
                                SizedBox(width: 40),

                                Expanded(
                                    flex: 3,
                                    child: DropdownButton<String>(
                                        items: jList(listOfOptions),
                                        value: itemSelected,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                            color: Colors.deepPurple
                                        ),
                                        underline: Container(
                                            height: 24,
                                            color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newItemSelected) {
                                            onDropDownItemSelected(
                                                newItemSelected);
                                        },
                                    )
                                ),

                                SizedBox(width: 50),

                                Builder(
                                    builder: (context) =>
                                        RaisedButton(
                                            color: Theme
                                                .of(context)
                                                .accentColor,
                                            textColor: Theme
                                                .of(context)
                                                .primaryColorLight,
                                            child: Text('Calculate',
                                                textScaleFactor: 1.5),
                                            onPressed: () {
                                                setState(() {
                                                    Scaffold.of(context)
                                                        .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Show Snackbar'),
                                                        duration: Duration(
                                                            seconds: 3),
                                                    ));
                                                    if (!_formKey.currentState
                                                        .validate()) {
                                                        print(
                                                            'Validation Error');
                                                    }
                                                });
                                            },
                                        ),
                                ),
                            ]
                        )
                    ]
                )
            )
        );
    }


    /// Methods

    Widget getImageAsset() {
        AssetImage assetImage = AssetImage('images/dollar.jpg');
        Image image = Image(
            image: assetImage,
            width: 250.0,
            height: 250.0,
        );

        return Container(
            child: image,
            margin: EdgeInsets.all(_minimumPadding * 10),
        );
    }

    /* onDropDownItemSelected */
    void onDropDownItemSelected(String newValueSelected) {
        setState(() {
            this.itemSelected = newValueSelected;
        });
    }

    String _calculateTotalReturns() {
        double principal = double.parse(ctrlText.text);
        String result = principal.toStringAsFixed(2);
        return result;
    }

    void _reset() {
        ctrlText.text = '';
        displayResult = '';
        itemSelected = listOfOptions[0];
    }


    /// snackbar
    void showSnackBar(BuildContext context, String message) {
        final snackBar = SnackBar(content: Text(message));
        Scaffold.of(context).showSnackBar(snackBar);
    }


    /// dialog
    void showAlertDialog(String title, String message) {
        AlertDialog alertDialog = AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
                FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                )
            ],
        );

        showDialog(
            context: context,
            builder: (_) => alertDialog
        );
    }


    /// Date
    void callDatePicker() async {
        var order = await getDate(context);
        setState(() {
            finalDate = order;
        });
    }

    Future<DateTime> getDate(BuildContext context) {
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
}

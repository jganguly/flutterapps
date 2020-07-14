import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/JUtil.dart';

class Acc extends StatefulWidget {
    @override
    AccState createState() {
        return AccState();
    }
}

class AccState extends State<Acc> {
    /// Essential state variables
    AccState get accState => this;
    final _formKey = GlobalKey<FormState>();

    /// state variables
    var listOfStates  = ['State', 'Hariyana', 'Karnataka', 'Telangana'];
    var itemSelected = '';

    TextEditingController ctrlTextPmk  = TextEditingController();
    TextEditingController ctrlTextNam  = TextEditingController();
    TextEditingController ctrlTextNum  = TextEditingController();
    TextEditingController ctrlTextStr  = TextEditingController();
    TextEditingController ctrlTextCit  = TextEditingController();
    TextEditingController ctrlListSta  = TextEditingController();
    TextEditingController ctrlTextPin  = TextEditingController();
    TextEditingController ctrlTextPh1  = TextEditingController();

    /// init state variables
    @override
    void initState() {
        super.initState();
        itemSelected = listOfStates[0];
    }

    @override
    Widget build(BuildContext context) {
        /// Scaffold
        return Scaffold(

            /// AppBar
            appBar: AppBar(title: Text("Acount", style: TextStyle(
                fontFamily: 'Roboto_Condensed', fontSize: 20.0),),
                backgroundColor: Colors.blueAccent),

            /// Background Color
            backgroundColor: Colors.white,

            /// FAB
            floatingActionButton: Builder(builder: (BuildContext context) {
                return createFAB(context, Icons.update, Colors.orangeAccent, Colors.green, 'FAB Clicked!!');
            }),

/*            /// BottomNavBar
            bottomNavigationBar: createBottomNavBar(),

            /// PersistentFooterButtons
            persistentFooterButtons: createPFB(context),*/

            /// Form
            body: Form(key: _formKey,
                child: ListView(children: <Widget>[
                    jText(Icons.person,TextInputType.text,'ID','Your ID','errormsg Name',ctrlTextPmk, "", true),
                    jText(Icons.person,TextInputType.text,'Name','Enter your full name','errormsg Name',ctrlTextNam, "", true),
                    jText(Icons.home,TextInputType.text,'Apt/House Number','Enter your apt or house number','errormsg Name',ctrlTextNum, "", true),
                    jText(null,TextInputType.text,'Street Address','Enter your street address','errormsg Name',ctrlTextStr, "", true),
                Row(
                    children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Icon(Icons.place),
                        ),
                        SizedBox(width:0.0),
                        Expanded(
                            flex: 60,
                            child: jText(null,TextInputType.text,'City','Enter city name','errormsg Name',ctrlTextCit, "", true),
                        ),
                        Expanded(
                            flex: 40,
                            child: dropdownButton(listOfStates, itemSelected, accState),
                        ),
                        Expanded(
                            flex: 40,
                            child: jText(null,TextInputType.text,'Pin','Enter your Pin','errormsg Name',ctrlTextPin, "", true),
                        ),
                    ]),
                    jText(Icons.phone,TextInputType.phone,'Phone Number','000-000-0000','errormsg Name',ctrlTextPh1, "", true),

                    Row(
                        children: <Widget>[
                            SizedBox(width: 40, height: 100.0,),
                            Builder( builder: (context) =>
                                RaisedButton(color: Theme.of(context).accentColor, textColor: Theme.of(context).primaryColorLight,
                                    child: Text( 'Submit', textScaleFactor: 1.25 ),
                                    onPressed: () async {
                                        /// AlertDialog
//                                        showAlertDialog(context, "Title", "Hello");

                                        /// jsonData & then navigate with Data
//                                        var jsonStr = getData();
//                                        print(jsonStr);
//                                        Navigator.of(context).pushNamed('/FormB', arguments: jsonStr);

                                        /// POST
                                        var reqJson = getData();
                                        print(reqJson);
                                        /// read, create, update
                                        String resJson = await postRequest('read', reqJson);
                                        print(resJson);
                                        /// SnackBar
                                        showSnackBar(context, accState, "Your information has been updated");
                                    },
                                ),
                            ),
                        ]
                    ),
                ])
            )
        );
    }
    
    String getData() {
        var str = {
            'Nam' : ctrlTextNam.text,
            'Num' : ctrlTextNum.text,
            'Str' : ctrlTextStr.text,
            'Cit' : ctrlTextCit.text,
            'Sta' : itemSelected,
            'Pin' : ctrlTextPin.text,
            'Ph1' : ctrlTextPh1.text,
            'Pmk' : ctrlTextPmk.text,
        };

        var jsonStr = json.encode(str);
        print(jsonStr);
        return jsonStr;
    }

} //FormAState




import 'package:flutter/material.dart';
import 'package:flutterapp/models/jmodel.dart';
import 'package:flutterapp/widgets/JUtil.dart';

class Ord extends StatefulWidget {
    @override
    OrdState createState() {
        return OrdState();
    }
}

class OrdState extends State<Ord> {
    /// Essential state variables
    OrdState get ordState => this;
    final _formKey = GlobalKey<FormState>();

    /// state variables
    var listOfQty  = ['0','1', '2', '3', '4'];
    var itemSelected = '';

    /// init state variables
    @override
    void initState() {
        super.initState();
        itemSelected = listOfQty[0];
    }

    List<JModel> jdata = [
        JModel("http://tineye.com/images/widgets/mona.jpg", "Leonardo Da Vinci", "0"),
        JModel("http://tineye.com/images/widgets/mona.jpg", "Rembrant", "0"),
        JModel("http://tineye.com/images/widgets/mona.jpg", "Picaso", "0"),
    ];


    @override
    Widget build(BuildContext context) {

            return  Container(
                color: Colors.white,  // Color(0xff258DED)
                height: 400.0,
                alignment: Alignment.center,

                child:  Column(
                    children: [
                        SizedBox(height:20),
                        Container(
                            width: 100.0,
                            height: 40.0,
                            child: RaisedButton(color: Theme.of(context).accentColor, textColor: Theme.of(context).primaryColorLight,
                                child: Text( 'Order', textScaleFactor: 1.25 ),
                                onPressed: () async {
                                    /// SnackBar
                                    showSnackBar2(context, ordState, "Your information has been updated");
                                },
                            ),
                        ),

                        Container(
                            height: 400.0,
                            width: 400.0,
                            child:  ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),

                                // ignore: missing_return
                                itemCount: jdata.length,
                                 // itemBuilder: (BuildContext context, int index) => jlrView(context, index)
                                itemBuilder: (BuildContext context, int index) {
                                    return (
                                        GestureDetector(
                                            child: jlrView(context, index),
//                                            onTap: () => print(index),
                                        onTap: () {
                                                print(index);
                                                print(jdata[index].qty);
                                        }
                                        )
                                    );
                                }
                            )
                        )
                    ]
                )
            );
    }

    /// jlrView method
    Widget jlrView(BuildContext context, int index) {

        final data = jdata[index];

        TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 18);
        TextStyle jErrorStyle = TextStyle(
            color: Colors.orangeAccent, fontSize: 16.0);
        TextEditingController ctrlText1 = TextEditingController();
        TextEditingController ctrlText2 = TextEditingController();

        Widget widget = Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 2,

            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(20.0),

            /// decoration
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                ),

                borderRadius: BorderRadius.circular(12),

                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                        Color(0xff0d69ff).withOpacity(0.0),
                        Color(0xff0069ff).withOpacity(0.8),
                    ],
                ),
            ),

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Expanded(
                                flex: 1,
                                child: jText(Icons.people, TextInputType.text, "Item", 'Hint Name', 'errormsg Name', ctrlText1, jdata[index].name, true),
                            ),
                            Expanded(
                                flex: 1,
                                child: jText(Icons.people, TextInputType.text, "Qty", 'Hint Name', 'errormsg Name', ctrlText2, "0", true),
                            ),
                        ],
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Expanded(
                                child: Container(
                                    height: 200.0,
                                    child: Image.network(jdata[index].imgURL, scale: 1.00),
                                ),
                            ),
                            RaisedButton(color: Theme.of(context).accentColor, textColor: Theme.of(context).primaryColorLight,
                                child: Text( 'Add to Cart', textScaleFactor: 1.25 ),
                                onPressed: () async {
                                    jdata.removeAt(index);
                                    showSnackBar2(context, ordState, "Added to Cart");
                                },
                            ),
                        ],
                    ),
                ],
            ),
        );

        return widget;
    }
}

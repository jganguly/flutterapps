/// Speech recognition app
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/JUtil.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:permission/permission.dart';

void main() => runApp(SpeechRecog());

class SpeechRecog extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SpeechHome()
        );
    }
}

class SpeechHome extends StatefulWidget {
    @override
//    State<StatefulWidget> createState() => _SpeechHomeState();
    State<StatefulWidget> createState() {
        return _SpeechHomeState();
    }
}

class _SpeechHomeState extends State<SpeechHome> {
    SpeechRecognition _speechRecognition;
    bool _isAvailable = false;
    bool _isListening = false;

    String resultText = "";

    TextEditingController ctrlText;
    TextFormField jt;

    @override
    void initState() {
        super.initState();
        print("init");

        ctrlText  = TextEditingController();
        jt = jText(Icons.language, TextInputType.text, "Speech Recognition", 'Hint Name', 'errormsg Name', ctrlText, "Say something", true);
        ctrlText.text = "Say something!";

        print("Requesting Permission ...");
        Future<PermissionStatus> status = requestPermission();
        print("status: $status");
        initSpeechRecognizer();
    }


    void initSpeechRecognizer() {
        _speechRecognition = SpeechRecognition();

        _speechRecognition.setAvailabilityHandler( (bool result) {
                setState( () {
                    _isAvailable = result;
                });
//                print("SR available-1: $_isAvailable");
            }
        );

        _speechRecognition.setRecognitionStartedHandler( () {
                setState( () {
                    _isListening = true;
                });
//                print("SR listening-1: $_isListening");
            }
        );

        _speechRecognition.setRecognitionResultHandler( (String speech) {
                setState( () {
                   resultText = speech;
                });
                print("SR listening-2: $resultText");
                ctrlText.text = resultText;
            }
        );

        _speechRecognition.setRecognitionCompleteHandler( () {
                setState( () {
                    _isListening = false;
                });
//                print("SR listening-3: $_isListening");
            }
        );

        _speechRecognition.activate().then( (result) {
                setState(() {
                    _isAvailable = result;
                });
//                print("SR available-2: $_isAvailable");
            }
        );
    }

    Future<PermissionStatus> requestPermission() async { // ignore: missing_return
        Future<PermissionStatus> res = (await Permission.requestSinglePermission(PermissionName.Microphone)) as Future<PermissionStatus>;
        print("permission status: $res");
        return res;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                FloatingActionButton(
                                    child: Icon(Icons.cancel),
                                    mini: true,
                                    backgroundColor: Colors.deepOrange,
                                    onPressed: () {
                                        if (_isListening)
                                            _speechRecognition.cancel().then( (result) {
                                                setState( () {
                                                    _isListening = result;
                                                    resultText = "";
                                                    ctrlText.text = "";
                                                });
                                            });
                                        },
                                ),
                                FloatingActionButton(
                                    child: Icon(Icons.mic),
                                    backgroundColor: Colors.pink,
                                    onPressed: () {
                                        print("Clicked Mic $_isAvailable $_isListening");
                                        if (_isAvailable && !_isListening) {
                                            print("In here");
                                            _speechRecognition.listen(locale: "en_US").then( (result) {
                                                print("*** " + '$result');
                                            });
                                        }
                                    },
                                ),
                                FloatingActionButton(
                                    child: Icon(Icons.stop),
                                    mini: true,
                                    backgroundColor: Colors.deepPurple,
                                    onPressed: () {
                                        if (_isListening)
                                            _speechRecognition.stop().then( (result) {
                                                    setState( () {
                                                        _isListening = result;
                                                    });
                                                }
                                            );
                                        },
                                )
                            ],
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            decoration: BoxDecoration(
                                color: Colors.cyanAccent[100],
                                borderRadius: BorderRadius.circular(6.0)
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0,
                            ),
                            child: jt
                        )
                    ],
                )
            )
        );
  }
}







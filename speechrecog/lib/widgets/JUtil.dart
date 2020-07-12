import 'package:flutter/material.dart';

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




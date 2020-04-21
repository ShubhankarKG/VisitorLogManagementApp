import 'package:flutter/material.dart';

class Visitor extends StatefulWidget {
  Visitor({Key key}) : super(key: key);
  _VisitorState createState() => _VisitorState();
}

class _VisitorState extends State<Visitor> {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Full Name
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            // Phone Number
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            // Email
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
            ),
            // Address
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter address";
                }
                return null;
              },
            ),
            // Reason for Meeting
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter reason for meeting';
                }
                return null;
              },
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // Work here.
                  }
                },
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

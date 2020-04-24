import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visitor_log_app/faculty.dart';

class VisitorInfo {
  final String visitorName;
  final String address;
  final String gender;
  final Faculty faculty;
  final int number;
  final String description;
  final String email;

  VisitorInfo(
      {this.visitorName,
      this.address,
      this.gender,
      this.faculty,
      this.number,
      this.description,
      this.email});

  factory VisitorInfo.fromJson(Map<String, dynamic> json) {
    return VisitorInfo(
        visitorName: json['visitorName'],
        address: json['address'],
        gender: json['gender'],
        faculty: Faculty.fromJson(json['faculty']),
        number: json['number'],
        description: json['description'],
        email: json['email']);
  }
}

class Visitor extends StatefulWidget {
  Visitor({Key key}) : super(key: key);
  _VisitorState createState() => _VisitorState();
}

class _VisitorState extends State<Visitor> {
  final _formKey = GlobalKey<FormState>();

  String _validateUsername(String username) {
    if (username.isEmpty) {
      return "Please enter some text";
    } else {
      if (username.length > 20 || username.length < 4) {
        return "Username should be within 5 to 19 characters long.";
      }
    }
    return null;
  }

  String _isEmpty(String text) {
    if (text.isEmpty) return 'Please enter some text';
    return null;
  }

  String _isNumber(String number) {
    String _number = number.toString();
    if (_number.isEmpty)
      return 'Please enter Contact Number';
    else if (_number.length != 10) return 'Please enter valid contact number';
    return null;
  }

  _launchURL() async {
    const url = 'http://www.vjti.ac.in';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No Internet Connection."),
      ));
    }
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Form Submitted"),
      ));
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: _launchURL,
                  child: Image.asset(
                    "assets/images/download.jpeg",
                    width: 200,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "WELCOME VISITOR!",
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.black),
              ),
            ),
            // Full Name
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
                keyboardType: TextInputType.text,
                validator: this._validateUsername,
              ),
            ),

            // Address
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                keyboardType: TextInputType.multiline,
                validator: this._isEmpty,
              ),
            ),

            // Gender
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Gender'),
                keyboardType: TextInputType.text,
                initialValue: 'Male',
                validator: this._isEmpty,
              ),
            ),

            // Faculty
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Faculty to meet',
                ),
                validator: this._isEmpty,
              ),
            ),

            // Number
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Please enter Contact Number'),
                validator: this._isNumber,
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Please enter reason for meeting',
                ),
                validator: this._isEmpty,
              ),
            ),

            // Email
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration:
                    InputDecoration(labelText: 'Please enter your Email-ID'),
                validator: this._isEmpty,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: _submitForm,
                color: Colors.amber[800],
                child: Text(
                  "submit".toUpperCase(),
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

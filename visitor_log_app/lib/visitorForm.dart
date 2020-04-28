import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class VisitorInfo {
  final String visitorName;
  final String address;
  final String gender;
  final String contactNumber;
  final String description;
  final String email;

  VisitorInfo({this.visitorName, this.address, this.gender, this.contactNumber, this.description, this.email});

  Map toJson() {
    var map = new Map<String, dynamic>();
    map["visitorName"] = visitorName;
    map["address"] = address;
    map["gender"] = gender;
    map["contactNumber"] = contactNumber;
    map["description"] = description;
    map["email"] = email;

    return map;
  }
}

// Future <VisitorInfo> createVisitor(String url, {Map body}) async {
//   return http.post(url).then((http.Response response) {
//     final int statusCode = response.statusCode;
//     if (statusCode < 200 || statusCode > 400 || json == null) {
//       throw new Exception("Error while fetching data");
//     }
//     return VisitorInfo.fromJson(json.decode(response.body));
//   }); 
}

class VisitorForm extends StatefulWidget {
  VisitorForm({Key key}) : super(key: key);
  _VisitorState createState() => _VisitorState();
}

class _VisitorState extends State<VisitorForm> {
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
                    .headline4
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
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: this._isNumber,
              ),
            ),

            // Email
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email-ID'),
                validator: this._isEmpty,
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Reason',
                ),
                validator: this._isEmpty,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: RaisedButton(
                  onPressed: _submitForm,
                  color: Colors.amber[800],
                  child: Text(
                    "submit".toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

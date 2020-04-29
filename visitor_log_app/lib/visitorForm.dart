import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:visitor_log_app/faculty.dart';
import 'package:visitor_log_app/otpField.dart';

class VisitorInfo {
  final String visitorName;
  final String address;
  final String gender;
  final String contactNumber;
  final String description;
  final String email;

  VisitorInfo(
      {this.visitorName,
      this.address,
      this.gender,
      this.contactNumber,
      this.description,
      this.email});

  Map toJson() {
    List<String> names = visitorName.split(" ");
    var map = new Map<String, dynamic>();
    map["firstName"] = names[0];
    map["lastName"] = names[1];
    map["address"] = address;
    map["gender"] = gender;
    map["contact"] = contactNumber;
    map["description"] = description;
    map["email"] = email;

    return map;
  }
}

class Otp {
  final String otp;
  Otp({this.otp});

  factory Otp.fromJson(Map<String, dynamic> parsedJson) {
    return Otp(otp: parsedJson["otp"]);
  }
}

class VisitorForm extends StatefulWidget {
  VisitorForm({Key key}) : super(key: key);
  _VisitorState createState() => _VisitorState();
}

class _VisitorState extends State<VisitorForm> {
  final _formKey = GlobalKey<FormState>();
  final visitorName = TextEditingController();
  final address = TextEditingController();
  final gender = TextEditingController();
  final faculty = TextEditingController();
  final number = TextEditingController();
  final email = TextEditingController();
  final description = TextEditingController();

  void initState() {
    super.initState();
    getData();
  }

  void dispose() {
    visitorName.dispose();
    address.dispose();
    gender.dispose();
    faculty.dispose();
    number.dispose();
    email.dispose();
    description.dispose();
    super.dispose();
  }

  List<FacultyInfo> faculties;

  void createVisitor(VisitorInfo visitorInfo) async {
    final http.Response response = await http.post(
        "https://sleepy-peak-76140.herokuapp.com/api/visitor/validate",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8 ',
        },
        body: jsonEncode(visitorInfo.toJson()));
    if (response.statusCode == 200) {
      String otp = Otp.fromJson(json.decode(response.body)).otp;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "Form submitted successfully, please check you email address to verify"),
      ));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpField(visitor: visitorInfo, otp: otp)));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Oops! There was an error. Please try again"),
      ));
    }
  }

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

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      VisitorInfo newVisitor = new VisitorInfo(
          visitorName: visitorName.text,
          address: address.text,
          gender: gender.text,
          email: email.text,
          description: description.text);
      createVisitor(newVisitor);
    }
  }

  Future getData() async {
    getFacultyInfo().then((value) {
      setState(() {
        faculties = value;
        print(faculties);
      });
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
                controller: visitorName,
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
                controller: address,
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
                controller: gender,
                decoration: InputDecoration(labelText: 'Gender'),
                keyboardType: TextInputType.text,
                validator: this._isEmpty,
              ),
            ),

            // Faculty
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: faculty,
                decoration: InputDecoration(
                  labelText: 'Faculty to meet',
                  suffixIcon: PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      faculty.text = value;
                    },
                    itemBuilder: (context) {
                      return faculties.map<PopupMenuItem<String>>((e) {
                        return new PopupMenuItem(
                          child: Text(e.name),
                          value: e.name,
                        );
                      }).toList();
                    },
                  ),
                ),
                validator: this._isEmpty,
              ),
            ),
            
            // Number
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: number,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: this._isNumber,
              ),
            ),

            // Email
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email-ID'),
                validator: this._isEmpty,
              ),
            ),

            // Description
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: description,
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

  Widget row(FacultyInfo maker) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          maker.name,
          style: TextStyle(color: Colors.blue),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          maker.email,
          style: TextStyle(color: Colors.orange),
        ),
      ],
    );
  }
}

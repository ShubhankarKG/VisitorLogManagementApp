import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:visitor_log_app/faculty.dart';
import 'package:visitor_log_app/visitorInfo.dart';
import 'package:visitor_log_app/facultyInfo.dart';

class Otp {
  final int otp;
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

  VisitorInfo sendVisitor;
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
  Future<Otp> futureOtp;
  Future<Otp> createVisitor(VisitorInfo visitorInfo) async {
    final http.Response response = await http.post(
        "https://sleepy-peak-76140.herokuapp.com/api/visitor/create",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8 ',
        },
        body: jsonEncode(visitorInfo.toJson()));
    if (response.statusCode == 200) {
      print(response);
      return Otp.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send server');
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
          description: description.text,
          contactNumber: number.text);
      setState(() {
        futureOtp = createVisitor(newVisitor);
        sendVisitor = newVisitor;
      });
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

  Widget getFutureBuilder() {
    return FutureBuilder<Otp>(
      future: futureOtp,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // snapshot.data.otp.toString() has otp
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    child:
                        Text("Please enter the 6 digit pin sent to your email:", style: Theme.of(context).textTheme.headline4.copyWith(color : Colors.black),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PinEntryTextField(
                    fields: 6,
                    onSubmit: (String pin) async {
                      if (pin == snapshot.data.otp.toString()) {
                        print("OTP Valid ${sendVisitor.email}");
                        final http.Response response = await http.post(
                            "https://sleepy-peak-76140.herokuapp.com/api/visitor/validate",
                            headers: <String, String>{
                              "Content-Type": "application/json"
                            },
                            body: jsonEncode(sendVisitor.toJson()));
                        if (response.statusCode == 200) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Verification Successful. Please wait while requested Faculty sends the details"),
                          ));
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("${response.reasonPhrase}"),
                          ));
                        }
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Verification failed. Please try again"),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: (futureOtp == null)
            ? Column(
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
              )
            : getFutureBuilder(),
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:visitor_log_app/visitorForm.dart';
import 'package:http/http.dart' as http;

class OtpField extends StatelessWidget {
  final String otp;
  final VisitorInfo visitor;
  OtpField({this.visitor, this.otp});

  Widget build(BuildContext context) {
    return Scaffold(
      body: PinEntryTextField(
        fields: 6,
        onSubmit: (String pin) async {
          if (pin == otp) {
            final http.Response response = await http.post(
                "https://sleepy-peak-76140.herokuapp.com/api/visitor/validate",
                headers: <String, String>{"Content-Type": "application/json"},
                body: jsonEncode(visitor.toJson()));
            if (response.statusCode == 200) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Verification Successful. Please wait while requested Faculty sends the details"),
              ));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("${response.toString()}"),
              ));
            }
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Verification failed. Please try again"),
            ));
          }
        },
      ),
    );
  }
}

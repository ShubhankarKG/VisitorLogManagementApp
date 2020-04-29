import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:visitor_log_app/facultyInfo.dart';

Future<List<FacultyInfo>> getFacultyInfo() async {
  try {
    final response =
        await http.get("https://sleepy-peak-76140.herokuapp.com/api/faculty/");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((faculty) => new FacultyInfo.fromJson(faculty))
          .toList();
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

class FacultyDisplay extends StatefulWidget {
  FacultyDisplay({Key key}) : super(key: key);
  _FacultyDisplayState createState() => _FacultyDisplayState();
}

class _FacultyDisplayState extends State<FacultyDisplay> {
  ListView _facultyListView(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return facultyBox(data[index]);
      },
    );
  }

  Widget facultyBox(FacultyInfo faculty) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(faculty.name.toString()),
              subtitle: Text(faculty.email.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<FacultyInfo>>(
      future: getFacultyInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<FacultyInfo> data = snapshot.data;
          return _facultyListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

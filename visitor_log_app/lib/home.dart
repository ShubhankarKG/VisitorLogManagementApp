import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {

  _launchURL() async {
    const url = 'http://www.vjti.ac.in';
    if (await canLaunch(url)) {
      await launch(url);
    } 
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Welcome! This online Visitor Log Management System is an attempt to use online tools for the ease of communication process, thereby ensuring smooth transition between a visitor and a faculty and decrease latency time.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Divider(
            height: 2,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "This project is designed by Group G6, as part of DBMS project under Dr. V. B. Nikam for the IV Semester. The students involved in the project are :",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "1.   Shubhankar K Gupta (Project Head) \n2.   Harsimran Singh Virk \n3.   Jash Seta \n4.   Rishikesh Hirde",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "2.   Harsimran Singh Virk",
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "3.   Jash Seta",
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "4.   Rishikesh Hirde",
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "We would like to thank everyone for their help in making this successful, especially our professors!",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}

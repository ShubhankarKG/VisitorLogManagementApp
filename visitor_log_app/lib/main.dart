import 'package:flutter/material.dart';
import 'package:visitor_log_app/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // WidgetsFlutterBinding.ensureInitialized();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VLoGS - VJTI",
      home: MyHomepage(),
    );
  }
}

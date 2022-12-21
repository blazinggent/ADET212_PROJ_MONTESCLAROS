// A mobile application that can report a covid protocol violator with their
// photo, name, and mobile number.
// by Ian Montesclaros

import 'package:flutter/material.dart';
import 'demo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Local Database',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Demo(),
    );
  }
}

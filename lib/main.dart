import 'package:flutter/material.dart';
import 'package:todo_app/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: MyHomePage(),
      routes: {'home': (context) => MyHomePage()},
    );
  }
}

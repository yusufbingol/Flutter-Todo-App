import 'package:flutter/material.dart';
import 'package:todo_app/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        playSound: true,
        enableLights: true,
        enableVibration: true,
        ledColor: Colors.white)
  ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
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

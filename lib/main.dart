import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mars_rover_photos/home.dart';

void main() => runApp(App());

class App extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Mars Rover Photos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Home(),
    );
  }

  
}

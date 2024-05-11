import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

//other files
import 'package:starter_name/cticonlink.dart';
import 'package:starter_name/news.dart';
import 'package:starter_name/tokenlist.dart';
import 'package:starter_name/tokenselect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentindex = 0;
  List<Widget> body = [TokenList(), NewsPage()];

//แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    print("Call Build");
    return Scaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.orange,
            backgroundColor: Colors.deepPurple,
            currentIndex: _currentindex,
            onTap: (int NewIndex) {
              setState(() {
                _currentindex = NewIndex;
                print(_currentindex);
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.currency_bitcoin), label: 'Token'  ),
              BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
            ],
          ),
        ),
        backgroundColor: const Color(343947),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Crypto Market",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20), child: body[_currentindex]));
  }
}

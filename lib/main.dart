import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

//other files
import 'package:starter_name/cticonlink.dart';
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
  late Timer timer; //create timer variable
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    getExRate(); //call function fetch api
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => getExRate()); //refresh time
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  void getExRate() async {
    print("Fetch API");
    const url =
        'https://data-api.binance.vision/api/v3/ticker/tradingDay?symbols=[%22BTCUSDT%22,%22ETHUSDT%22,%22BNBUSDT%22,%22SOLUSDT%22,%22DOTUSDT%22]';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = await jsonDecode(body);
    print("Decode Complete!!");
    setState(() {
      data = json;
    });
  }

  int _currentindex = 0;

//แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    print("Call Build");
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          onTap: (int NewIndex){
            setState(() {
              _currentindex = NewIndex;
              print(_currentindex);
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.currency_bitcoin),
                label: 'Token'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'News'
            ),

          ],

        ),
        backgroundColor: const Color(343947),
        appBar: AppBar(
          title: Text("Crypto Market (Binance)"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                //variable
                final data_item = data[index];
                final symbol = data[index]['symbol'];
                final price = double.parse(data[index]['lastPrice']);
                final percent_chg = double.parse(
                    data[index]['priceChangePercent']);
                final vol = double.parse(data[index]['quoteVolume']) /
                    1000000;
                Color percent_color = percent_chg > 0
                    ? Colors.green
                    : percent_chg < 0 ? Colors.red : Colors.grey;

                //img
                String currency_pic = '';
                CryptoImgLink.links.forEach((key, value) {
                  if (key == symbol) {
                    currency_pic = value.toString();
                  }
                });

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            TokenSelect(selecttoken: data_item,
                              token_img: currency_pic,)));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[700]!.withOpacity(
                                        0.3),
                                    borderRadius: BorderRadius.circular(15),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //       color: Colors.grey[700]!,
                                    //       offset: const Offset(4, 4),
                                    //       blurRadius: 5)
                                    // ]
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.network(
                                        currency_pic),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      '$symbol',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "${NumberFormat('#.#').format(
                                          percent_chg)}%",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: percent_color),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$ ${NumberFormat('#,###.##').format(
                                      price)}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Vol.' + "${NumberFormat('#,###.##')
                                      .format(vol)}" + 'm',
                                  style:
                                  TextStyle(fontSize: 15, color: Colors.grey
                                      .withOpacity(0.7)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}

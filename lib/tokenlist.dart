import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:starter_name/tokenselect.dart';

import 'cticonlink.dart';

class TokenList extends StatefulWidget {
  const TokenList({super.key});

  @override
  State<TokenList> createState() => _TokenListState();
}


class _TokenListState extends State<TokenList> {
  late Timer timer; //create timer variable
  List<dynamic> data = [];

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
        });
  }
}

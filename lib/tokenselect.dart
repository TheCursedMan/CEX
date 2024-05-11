import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starter_name/Chartmodel.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';


class TokenSelect extends StatefulWidget {
  var selecttoken;
  var token_img;
  var graphid;

  TokenSelect({this.selecttoken, this.token_img, this.graphid});

  @override
  State<TokenSelect> createState() => _TokenSelectState();
}

class _TokenSelectState extends State<TokenSelect> {


  late TrackballBehavior trackballBehavior;

  List<ChartModel>? itemChart;

  Future<void> getChart(String graphid) async {
    String url =
        'https://api.coingecko.com/api/v3/coins/${graphid}/ohlc?vs_currency=usd&days=1';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      Iterable x = jsonDecode(response.body);
      List<ChartModel> modellist = x
          .map((e) => ChartModel.fromJson(e))
          .toList();
      setState(() {
        itemChart = modellist;
      });
    }
    else {
      print(response.statusCode);
    }
  }

  late Timer timer;
  @override
  void initState() {
    super.initState();
    trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.doubleTap
    );
    getChart(widget.graphid.toString());
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => [getChart(widget.graphid.toString())]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      // backgroundColor: const Color(343947),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     IconButton(onPressed: (){
                    //       Navigator.pop(context);
                    //     }, icon: Icon(Icons.arrow_back))
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: () {
                              Navigator.pop(context);
                            },
                              icon: Icon(Icons.arrow_back),
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                            ),
                            Container(
                              height: 60,
                              child: Image.network(widget.token_img),
                            ),
                            SizedBox(
                                width: 10
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.selecttoken['symbol'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500
                                  ),),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$ ${NumberFormat('#,###.##').format(
                                double.parse(
                                    widget.selecttoken['lastPrice']))}',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.red
                              ),),
                            Text(widget.selecttoken['priceChangePercent']
                                .toString() + '%',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: double.parse(widget
                                      .selecttoken['priceChangePercent']) > 0
                                      ? Colors.green
                                      : Colors.red
                              ),),
                          ],
                        ),
                      ],
                    ),
                  ]
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('High',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                          ),),
                        SizedBox(height: 10,),
                        Text('\$ ${NumberFormat('#,###.##').format(
                            double.parse(widget.selecttoken['highPrice']))}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text('Low',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                          ),),
                        SizedBox(height: 10,),
                        Text('\$ ${NumberFormat('#,###.##').format(
                            double.parse(widget.selecttoken['lowPrice']))}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text('Volume(asset)',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                          ),),
                        SizedBox(height: 10,),
                        Text('${NumberFormat('#,###.##').format(
                            double.parse(widget.selecttoken['volume']))}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),),
                      ],
                    ),
                  ],

                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 500,
                width: 500,
                color: Colors.transparent,
                child: SfCartesianChart(
                  trackballBehavior: trackballBehavior,
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                      zoomMode: ZoomMode.x
                  ),
                  series: <CandleSeries>[
                    CandleSeries <ChartModel, int>(
                      enableSolidCandles: true,
                      enableTooltip: true,
                      bullColor: Colors.green,
                      bearColor: Colors.red,
                      dataSource: itemChart!,
                      xValueMapper: (ChartModel sales, _) => sales.time,
                      lowValueMapper: (ChartModel sales, _) => sales.low,
                      highValueMapper: (ChartModel sales, _) => sales.high,
                      openValueMapper: (ChartModel sales, _) => sales.open,
                      closeValueMapper: (ChartModel sales, _) => sales.close,
                      animationDuration: 55,
                    )

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

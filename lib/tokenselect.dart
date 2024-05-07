import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokenSelect extends StatefulWidget {
  var selecttoken;
  var token_img;
  TokenSelect({this.selecttoken , this.token_img});

  @override
  State<TokenSelect> createState() => _TokenSelectState();
}

class _TokenSelectState extends State<TokenSelect> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Row(
                   children: [
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
                      Text('\$ ${NumberFormat('#,###.##').format(double.parse(widget.selecttoken['lastPrice']))}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red
                      ),),
                      Text(widget.selecttoken['priceChangePercent'].toString() + '%',
                        style: TextStyle(
                            fontSize: 15,
                            color: double.parse(widget.selecttoken['priceChangePercent']) > 0 ? Colors.green : Colors.red
                        ),),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('High',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),),
                      SizedBox(height: 10,),
                      Text('\$ ${NumberFormat('#,###.##').format(double.parse(widget.selecttoken['highPrice']))}',
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
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),),
                      SizedBox(height: 10,),
                      Text('\$ ${NumberFormat('#,###.##').format(double.parse(widget.selecttoken['lowPrice']))}',
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
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),),
                      SizedBox(height: 10,),
                      Text('${NumberFormat('#,###.##').format(double.parse(widget.selecttoken['volume']))}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

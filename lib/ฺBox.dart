import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class MoneyBox extends StatelessWidget {
  String title;
  Color color;
  double size;
  double amount;

  MoneyBox(this.title , this.color , this.size , this.amount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10)),
      height: size,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '${NumberFormat("#,###.##").format(amount)}',
              style: TextStyle(
                  fontSize: 25, color: Colors.white , fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),

          )
        ],
      ),
    );
  }
}

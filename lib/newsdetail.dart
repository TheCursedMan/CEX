import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsDetail extends StatefulWidget {
  String? news_title;
  String? news_content;

  String? news_img;

  NewsDetail({super.key, this.news_title, this.news_content, this.news_img});

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back))
      ),
      backgroundColor: const Color(343947),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30
            ),
            Text(
              widget.news_title as String,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Image.network(
              widget.news_img as String,
              width: 250,
              height: 250,
            ),
            Text(widget.news_content as String,
              style: TextStyle(fontSize: 16, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}

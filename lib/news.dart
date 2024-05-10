import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> news_data = [];

  void getNews() async{
    print("Fetch News API");
    const news_url = "https://newsdata.io/api/1/news?apikey=pub_439106073c4cb8add696e8d1b025d7c67d2fc&q=pegasus&language=en";
    final news_uri = Uri.parse(news_url);
    final news_response = await http.get(news_uri);
    final news_body = news_response.body;
    final news_json = await jsonDecode(news_body);
    setState(() {
      news_data = news_json;
    });
  }

  @override
  void initState(){
      super.initState();
      getNews();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(343947),
      appBar: AppBar(
        title: Text("Crypto Market (Binance)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: news_data.length,
            itemBuilder: (context , index){
              return Column(
                children: [
                  Text('$index')
                ],
              );
            }),
      ),
    );
  }
}

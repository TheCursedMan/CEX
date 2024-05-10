import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> news_data = [];

  void getNews() async {
    final String apiUrl = "https://mboum-finance.p.rapidapi.com/v2/markets/news?tickers=AAPL&type=ALL";
    final Map<String, String> headers = {
      "X-Rapidapi-Key": "8cd6b88910msh68f1bbe8e590734p14069djsndd7fc06a3bb5",
      "X-Rapidapi-Host": "mboum-finance.p.rapidapi.com",
      "Host": "mboum-finance.p.rapidapi.com"
    };

    final news_response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (news_response.statusCode == 200) {
      final news_body = news_response.body;
      final news_json = jsonDecode(news_body);

      if (news_json.containsKey('body')) {
        setState(() {
          news_data = news_json['body'];
          print(news_data);
        });
      } else {
        print("Results key not found in response");
      }
    } else {
      print("Failed to fetch news. Status code: ${news_response.statusCode}");
    }
  }




  @override
  void initState(){
      super.initState();
      getNews();
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
          itemCount: news_data.length,
          itemBuilder: (context , index){

            final data_item = news_data[index];
            final news_title = data_item['title'];
            final news_content = data_item['text'];
            final news_img = data_item['img'];
            final news_time = data_item['time'];
            final news_ago = data_item['ago'];


            return GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Container()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(news_img , width: 150, height: 150,),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${news_title}' , style: TextStyle(color: Colors.white) , maxLines: 2 , overflow: TextOverflow.ellipsis,),
                            Text('${news_time}' , style: TextStyle(color: Colors.grey , fontSize: 12),),
                            Text('${news_ago}' , style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      )

                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_news_app/model/article.dart';
import 'package:flutter_news_app/style/theme.dart' as Style;
import 'package:url_launcher/url_launcher.dart';

class NewDetail extends StatefulWidget {
  final ArticleModel article;
  NewDetail({Key key, @required this.article}) : super(key: key);
  @override
  _NewDetailState createState() => _NewDetailState(article);
}

class _NewDetailState extends State<NewDetail> {
  final ArticleModel article;
  _NewDetailState(this.article);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          launch(article.url);
        },
        child: Container(
          decoration: BoxDecoration(color: Style.Colors.mainColor),
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Read more",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0))
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          article.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Style.Colors.mainColor,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/img/placeholder.jpg',
              image: article.urlToImage,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  article.date.substring(0, 10),
                  style: TextStyle(
                      color: Style.Colors.mainColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  article.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Html(
                  data: article.context,
                  defaultTextStyle: TextStyle(
                      fontSize: 15.0, height: 1.3, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

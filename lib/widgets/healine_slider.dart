import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/bloc/get_tophealine_bloc.dart';
import 'package:flutter_news_app/elements/error_element.dart';
import 'package:flutter_news_app/elements/loader_element.dart';
import 'package:flutter_news_app/model/article.dart';
import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/screens/new_detail.dart';
import 'package:timeago/timeago.dart' as timeago;

class HealineSlider extends StatefulWidget {
  @override
  State<HealineSlider> createState() => _HealineSliderState();
}

class _HealineSliderState extends State<HealineSlider> {
  @override
  void initState() {
    super.initState();
    getTopHealineBloc..getHeadline();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleReponse>(
        stream: getTopHealineBloc.subject.stream,
        builder: (context, AsyncSnapshot<ArticleReponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return buildErrorWidget(snapshot.data.error);
            }
            return _buildHeadlineSlider(snapshot.data);
          } else if (snapshot.hasError) {
            return buildErrorWidget(snapshot.error);
          } else {
            return buildLoadingWidget();
          }
        });
  }

  Widget _buildHeadlineSlider(ArticleReponse data) {
    List<ArticleModel> articles = data.articles;
    return Container(
      child: CarouselSlider(
          options: CarouselOptions(
              enlargeCenterPage: false, height: 220.0, viewportFraction: 0.9),
          items: getExpenseSlider(articles)),
    );
  }

  getExpenseSlider(List<ArticleModel> articles) {
    return articles
        .map(
          (articles) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewDetail(article: articles)));
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: articles.urlToImage == null
                            ? AssetImage("assets/img/placeholder.jpg")
                            : NetworkImage(articles.urlToImage),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.1, 0.9],
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.white.withOpacity(0.0)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      width: 250.0,
                      child: Column(
                        children: <Widget>[
                          Text(
                            articles.title,
                            style: TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    left: 10.0,
                    child: Text(
                      articles.source.name,
                      style: TextStyle(color: Colors.white54, fontSize: 9.0),
                    ),
                  ),
                  Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: Text(
                        timeUnit(DateTime.parse(articles.date)),
                        style: TextStyle(color: Colors.white54, fontSize: 9.0),
                      ))
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  String timeUnit(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}

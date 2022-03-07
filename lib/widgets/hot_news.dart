import 'package:flutter/material.dart';
import 'package:flutter_news_app/bloc/get_hotnews_bloc.dart';
import 'package:flutter_news_app/model/article.dart';
import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/style/theme.dart' as Style;
import '../elements/error_element.dart';
import '../elements/loader_element.dart';
import 'package:timeago/timeago.dart' as Timeago;

import '../screens/new_detail.dart';

class HotNews extends StatefulWidget {
  @override
  State<HotNews> createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  @override
  void initState() {
    super.initState();
    getHotNewsBloc.getHotNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleReponse>(
      stream: getHotNewsBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleReponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildHotNews(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHotNews(ArticleReponse data) {
    final List<ArticleModel> articles = data.articles;
    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "No more news",
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: articles.length / 2 * 210.0,
        padding: EdgeInsets.all(10.0),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.85),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewDetail(article: articles[index])));
                  },
                  child: Container(
                    height: 220.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(1.0, 1.0),
                              color: Colors.grey[100]),
                        ]),
                    child: Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0),
                                ),
                                image: DecorationImage(
                                    image: articles[index].urlToImage == null
                                        ? AssetImage(
                                            "assets/img/placeholder.jpg")
                                        : NetworkImage(
                                            articles[index].urlToImage),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: Text(
                            articles[index].title,
                            style: TextStyle(height: 1.3, fontSize: 15.0),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              width: 180,
                              height: 1.0,
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                            ),
                            Container(
                              width: 50.0,
                              height: 3.0,
                              color: Style.Colors.mainColor,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                articles[index].source.name,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Style.Colors.mainColor),
                              ),
                              Text(
                                timeAgo(DateTime.parse(
                                  articles[index].date,
                                )),
                                style: TextStyle(fontSize: 11.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    }
  }

  String timeAgo(DateTime date) {
    return Timeago.format(date, allowFromNow: true, locale: 'en');
  }
}

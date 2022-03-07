import 'package:flutter/material.dart';

import 'package:flutter_news_app/bloc/get_source_new_bloc.dart';
import 'package:flutter_news_app/model/article.dart';
import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/model/source.dart';
import 'package:flutter_news_app/style/theme.dart' as Style;
import '../elements/loader_element.dart';
import 'package:timeago/timeago.dart' as Timeago;

class SourceDetail extends StatefulWidget {
  final SourceModel source;
  SourceDetail({Key key, @required this.source}) : super(key: key);
  @override
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final SourceModel source;
  _SourceDetailState(this.source);
  @override
  void initState() {
    super.initState();
    getSourceNewBloc..getSourceNews(source.id);
  }

  @override
  void dispose() {
    getSourceNewBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Style.Colors.mainColor,
          elevation: 0.0,
          title: Text(""),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            color: Style.Colors.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Hero(
                  tag: source.id,
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2.0, color: Colors.white),
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/logos/${source.id}.png",
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  source.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  source.description,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<ArticleReponse>(
              stream: getSourceNewBloc.subject.stream,
              builder: (context, AsyncSnapshot<ArticleReponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return Container();
                  }
                  return _buildSourceNewsWidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return buildLoadingWidget();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSourceNewsWidget(ArticleReponse data) {
    List<ArticleModel> articles = data.articles;
    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No Articles"),
          ],
        ),
      );
    } else {
      return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                
              },
              child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200], width: 1.8),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 3 / 5,
                      child: Column(
                        children: <Widget>[
                          Text(
                            articles[index].title,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    timeUnit(
                                      DateTime.parse(articles[index].date),
                                    ),
                                    style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      width: MediaQuery.of(context).size.width * 2 / 5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: articles[index].urlToImage == null
                              ? AssetImage(
                                  "assets/img/placeholder.jpg",
                                )
                              : NetworkImage(articles[index].urlToImage,
                                  scale: 1.0),
                        ),
                      ),
                      // child: FadeInImage.assetNetwork(
                      //   alignment: Alignment.topCenter,
                      //   placeholder: 'assets/img/placeholder.jpg',
                      //   image: articles[index].urlToImage == null
                      //       ? "https://shahpourpouyan.com/wp-content/uploads/2018/10/orionthemes-placeholder-image-1.png"
                      //       : articles[index].urlToImage,
                      //   fit: BoxFit.fitHeight,
                      //   width: double.maxFinite,
                      //   height: MediaQuery.of(context).size.height * 1 / 3,
                      // ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  String timeUnit(DateTime date) {
    return Timeago.format(date, allowFromNow: true, locale: 'en');
  }
}

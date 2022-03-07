import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/bloc/search_bloc.dart';
import 'package:flutter_news_app/elements/error_element.dart';
import 'package:flutter_news_app/model/article.dart';
import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/screens/new_detail.dart';

import '../../elements/loader_element.dart';

import 'package:flutter_news_app/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchBloc..search("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc..search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.grey[100],
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc..search(_searchController.text);
                        });
                      },
                      icon: Icon(EvaIcons.backspaceOutline))
                  : Icon(
                      EvaIcons.searchOutline,
                      color: Colors.grey[500],
                      size: 16.0,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[100].withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[100].withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
              labelText: "Search...",
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Style.Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            autocorrect: false,
          ),
        ),
        Expanded(
            child: StreamBuilder<ArticleReponse>(
                stream: searchBloc.subject.stream,
                builder: (context, AsyncSnapshot<ArticleReponse> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.error != null &&
                        snapshot.data.error.length > 0) {
                      return Container();
                    }
                    return _buildSearchNews(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Container();
                  } else {
                    return buildLoadingWidget();
                  }
                }))
      ],
    );
  }

  Widget _buildSearchNews(ArticleReponse data) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) =>
                            NewDetail(article: articles[index])));
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
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}

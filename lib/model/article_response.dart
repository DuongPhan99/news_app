import 'package:flutter_news_app/model/article.dart';

class ArticleReponse {
  final List<ArticleModel> articles;
  final String error;
  ArticleReponse(this.articles, this.error);
  ArticleReponse.fromJson(Map<String, dynamic> json)
      : articles = (json["articles"] as List)
            .map((i) => new ArticleModel.fromJson(i))
            .toList(),
        error = "";
  ArticleReponse.withError(String errorValue)
      : articles = List(),
        error = errorValue;
}

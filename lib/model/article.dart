import 'package:flutter_news_app/model/source.dart';

class ArticleModel {
  final SourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String date;

  final String context;

  ArticleModel(this.source, this.author, this.context, this.date,
      this.description, this.urlToImage, this.title, this.url);
  ArticleModel.fromJson(Map<String, dynamic> json)
      : source = SourceModel.fromJson(json["source"]),
        author = json["author"],
        title = json["title"],
        description = json["description"],
        url = json["url"],
        urlToImage = json["urlToImage"],
        date = json["publishedAt"],
        context = json["content"];
}

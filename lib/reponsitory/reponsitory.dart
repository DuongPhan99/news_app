import 'package:dio/dio.dart';
import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/model/source_response.dart';
import 'dart:async';

class NewsRepository {
  static String mainUrl = "https://newsapi.org/v2/";
  final String apiKey = "1cd545a802d84cdfaa42582d6b0ccb57";
  final Dio _dio = Dio();
  var getSourceUrl = '$mainUrl/sources';
  var getTopHeadlineUrl = '$mainUrl/top-headlines';
  var everythingUrl = "$mainUrl/everything";

  Future<SourceReponse> getSources() async {
    var params = {"apikey": apiKey, "language": "en", "country": "us"};
    try {
      Response response = await _dio.get(getSourceUrl, queryParameters: params);
      return SourceReponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SourceReponse.withError("$error");
    }
  }

  Future<ArticleReponse> getTopHeadlines() async {
    var params = {"apikey": apiKey, "country": "us"};
    try {
      Response response =
          await _dio.get(getTopHeadlineUrl, queryParameters: params);
      return ArticleReponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured:$error stackTrace:$stacktrace");
      return ArticleReponse.withError("$error");
    }
  }

  Future<ArticleReponse> search(String value) async {
    var params = {"apikey": apiKey, "q": "${value}", "sortBy": "popularity"};
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleReponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured:$error stackTrace:$stacktrace");
      return ArticleReponse.withError("$error");
    }
  }

  Future<ArticleReponse> getHotNews() async {
    var params = {"apikey": apiKey, "sortBy": "popularity", "q": "apple"};
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleReponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured:$error stackTrace:$stacktrace");
      return ArticleReponse.withError("$error");
    }
  }

  Future<ArticleReponse> getSourceNews(String sourceId) async {
    var params = {"apikey": apiKey, "sources": sourceId};
    try {
      Response response =
          await _dio.get(getTopHeadlineUrl, queryParameters: params);
      return ArticleReponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured:$error stackTrace:$stacktrace");
      return ArticleReponse.withError("$error");
    }
  }
}

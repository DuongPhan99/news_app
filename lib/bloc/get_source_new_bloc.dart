import 'package:flutter/material.dart';
import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/reponsitory/reponsitory.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceNewBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleReponse> _subject =
      BehaviorSubject<ArticleReponse>();
  getSourceNews(String sourceId) async {
    ArticleReponse reponse = await _repository.getSourceNews(sourceId);
    _subject.sink.add(reponse);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<ArticleReponse> get subject => _subject;
}

final getSourceNewBloc = GetSourceNewBloc();

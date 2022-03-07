import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/reponsitory/reponsitory.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleReponse> _subject =
      BehaviorSubject<ArticleReponse>();
  search(String value) async {
    ArticleReponse reponse = await _repository.search(value);
    _subject.sink.add(reponse);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleReponse> get subject => _subject;
}

final searchBloc = SearchBloc();

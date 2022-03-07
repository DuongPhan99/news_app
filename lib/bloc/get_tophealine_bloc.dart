import 'package:flutter_news_app/model/article_response.dart';
import 'package:flutter_news_app/reponsitory/reponsitory.dart';
import 'package:rxdart/rxdart.dart';

class GetTopHealineBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleReponse> _subject =
      BehaviorSubject<ArticleReponse>();
  getHeadline() async {
    ArticleReponse reponse = await _repository.getTopHeadlines();
    _subject.sink.add(reponse);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleReponse> get subject => _subject;
}

final getTopHealineBloc = GetTopHealineBloc();

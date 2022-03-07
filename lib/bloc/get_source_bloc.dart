import 'package:flutter_news_app/model/source_response.dart';
import 'package:flutter_news_app/reponsitory/reponsitory.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<SourceReponse> _subject =
      BehaviorSubject<SourceReponse>();
  getSource() async {
    SourceReponse reponse = await _repository.getSources();
    _subject.sink.add(reponse);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<SourceReponse> get subject => _subject;
}

final getSourceBloc = GetSourceBloc();

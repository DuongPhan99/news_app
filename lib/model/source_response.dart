import 'package:flutter_news_app/model/source.dart';

class SourceReponse {
  final List<SourceModel> sources;
  final String error;
  SourceReponse(this.sources, this.error);
  SourceReponse.fromJson(Map<String, dynamic> json)
      : sources = (json["sources"] as List)
            .map((i) => new SourceModel.fromJson(i))
            .toList(),
        error = "";
  SourceReponse.withError(String errorValue)
      : sources = List(),
        error = errorValue;
}

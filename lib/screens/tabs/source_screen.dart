import 'package:flutter/material.dart';
import 'package:flutter_news_app/bloc/get_source_bloc.dart';
import 'package:flutter_news_app/model/source.dart';
import 'package:flutter_news_app/model/source_response.dart';

import '../../elements/error_element.dart';
import '../../elements/loader_element.dart';
import '../source_detail.dart';

class SourceScreen extends StatefulWidget {
  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  @override
  void initState() {
    super.initState();
    getSourceBloc..getSource();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceReponse>(
      stream: getSourceBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceReponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildSource(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildSource(SourceReponse data) {
    List<SourceModel> sources = data.sources;
    return GridView.builder(
        itemCount: sources.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.86),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SourceDetail(source: sources[index])));
              },
              child: Container(
                width: 100.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        color: Colors.grey[100])
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: sources[index].id,
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/logos/${sources[index].id}.png",
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      child: Text(
                        sources[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

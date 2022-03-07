import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/bloc/get_source_bloc.dart';
import 'package:flutter_news_app/model/source.dart';
import 'package:flutter_news_app/model/source_response.dart';
import 'package:flutter_news_app/screens/source_detail.dart';

import '../elements/error_element.dart';
import '../elements/loader_element.dart';

class TopChannels extends StatefulWidget {
  @override
  State<TopChannels> createState() => _TopChannelsState();
}

class _TopChannelsState extends State<TopChannels> {
  @override
  void initState() {
    super.initState();
    getSourceBloc.getSource();
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
            return _buildTopChannels(snapshot.data);
          } else if (snapshot.hasError) {
            return buildErrorWidget(snapshot.error);
          } else {
            return buildLoadingWidget();
          }
        });
  }

  Widget _buildTopChannels(SourceReponse data) {
    List<SourceModel> sources = data.sources;
    if (sources.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Text("No sources"),
          ],
        ),
      );
    } else {
      return Container(
        height: 130.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sources.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(top: 10.0, right: 0.0),
                width: 80.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SourceDetail(source: sources[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: sources[index].id,
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1.0, 1.0),
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0)
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/logos/${sources[index].id}.png"))),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        sources[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            height: 1.4,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        sources[index].category,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:
                            TextStyle(color: Colors.blue[900], fontSize: 9.0),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}

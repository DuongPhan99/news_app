import 'package:flutter/material.dart';

import '../../widgets/healine_slider.dart';
import '../../widgets/hot_news.dart';
import '../../widgets/top_channels.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        HealineSlider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Top channels",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              Text(
                "See more",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: Colors.grey),
              ),
            ],
          ),
        ),
        TopChannels(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Hot news",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              Text(
                "See more",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: Colors.grey),
              ),
            ],
          ),
        ),
        HotNews()
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:onepiece_zoro/main.dart';

class FPSPage extends StatefulWidget {
  static String pageName = 'flutter://fsp_watch_page';
  static Map<String, dynamic> appBarConfig = {
    'title': 'FPS监测',
  };

  const FPSPage({this.params});

  final Map<String, dynamic> params;

  @override
  _FPSPageState createState() => _FPSPageState();
}

class _FPSPageState extends State<FPSPage> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 100,
      separatorBuilder: (BuildContext context, int index) => Container(
        height: 1,
        color: Colors.black26,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.all(50),
          child: Text(index.toString()),
        );
      }
    );
  }
}
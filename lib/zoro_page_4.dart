import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'zoro_framework.dart';
import 'zoro_page.dart';
import 'zoro_page_3.dart';

class ZoroFlutterPage4 extends StatefulWidget {

  static String pageName = 'flutter://zoro_flutter_page4';
  static Map<String, dynamic> appBarConfig = {
    'title': '第四个页面',
  };

  const ZoroFlutterPage4({this.params});

  final Map<String, dynamic> params;

  @override
  _ZoroFlutterPage4 createState() => _ZoroFlutterPage4();
}

class _ZoroFlutterPage4 extends State<ZoroFlutterPage4> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Text(
              'params:${widget.params}',
              style: TextStyle(fontSize: 28.0, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
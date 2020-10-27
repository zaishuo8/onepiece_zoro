import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'zoro_framework.dart';
import 'zoro_page_4.dart';

class ZoroFlutterPage3 extends StatefulWidget {

  static String pageName = 'flutter://zoro_flutter_page3';
  static Map<String, dynamic> appBarConfig = {
    'title': '第三个页面',
  };

  const ZoroFlutterPage3({this.params});

  final Map<String, dynamic> params;

  @override
  _ZoroFlutterPage3 createState() => _ZoroFlutterPage3();
}

class _ZoroFlutterPage3 extends State<ZoroFlutterPage3> {

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
            FlatButton(
              child: Text('reset'),
              onPressed: () => Zoro.reset(
                  ZoroFlutterPage4.pageName,
                  urlParams: {
                    'phone': '0571',
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
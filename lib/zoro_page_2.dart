import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'zoro_framework.dart';
import 'zoro_page.dart';
import 'zoro_page_3.dart';

class ZoroFlutterPage2 extends StatefulWidget {

  static String pageName = 'flutter://zoro_flutter_page2';
  static Map<String, dynamic> appBarConfig = {
    'title': '第二个页面',
  };

  const ZoroFlutterPage2({this.params});

  final Map<String, dynamic> params;

  @override
  _ZoroFlutterPage2 createState() => _ZoroFlutterPage2();
}

class _ZoroFlutterPage2 extends State<ZoroFlutterPage2> {

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
              child: Text('pushAndRemove'),
              onPressed: () => Zoro.pushAndRemove(
                ZoroFlutterPage3.pageName,
                urlParams: {
                  'sex': 'girl',
                },
                exts: {
                  'removePageNames': [ZoroFlutterPage2.pageName, ZoroFlutterPage.pageName]
                }
              ),
            ),
            FlatButton(
              child: Text('正常 open'),
              onPressed: () => Zoro.pushAndRemove(
                  ZoroFlutterPage3.pageName,
                  urlParams: {
                    'sex': 'girl',
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
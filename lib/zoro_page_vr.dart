import 'package:flutter/material.dart';

import 'zoro_framework.dart';
import 'zoro_page_4.dart';

class ZoroPageVr extends StatelessWidget {

  static String pageName = 'flutter://zoro_vr';

  const ZoroPageVr({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FlatButton(
          child: Text(
            "Flutter端部分，点击跳转下一个页面，返回来 PlatformView 中的内容是否还能交互",
            style: TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.w500),
          ),
          onPressed: () => Zoro.push(ZoroFlutterPage4.pageName),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          // action button
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AndroidView(
        viewType: 'plugins.vr/view',
        onPlatformViewCreated: (int id) {},
      ),
    );
  }
}
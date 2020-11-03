import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'simple_page_widgets.dart';
import 'zoro_framework.dart';
import 'zoro_page_2.dart';
import 'zoro_page_vr.dart';

class ZoroFlutterPage extends StatefulWidget {

  static String pageName = 'flutter://zoro_flutter_page';
  static Map<String, dynamic> appBarConfig = {
    'title': '第一个页面，配置标题',
  };

  const ZoroFlutterPage({this.params});

  final Map<String, dynamic> params;

  @override
  _ZoroFlutterPage createState() => _ZoroFlutterPage();
}

class _ZoroFlutterPage extends State<ZoroFlutterPage> {

  // flutter 侧 MethodChannel 配置，channel name 需要和 native 侧一致
  static const MethodChannel _methodChannel = MethodChannel('flutter_native_channel');
  String _systemVersion = '';
  _getPlatformVersion() async {
    try {
      final String result = await _methodChannel.invokeMethod('getPlatformVersion');
      print('getPlatformVersion:' + result);
      setState(() {
        _systemVersion = result;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }


  @override
  void initState() {
    super.initState();

    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'boolParamFromNative') {
        print('--- boolParamFromNative ---');
        print(call.arguments);
      }
    });
  }

  testBoolParams() async {
    try {
      final bool result = await _methodChannel.invokeMethod('boolParam', true);
      print('--- testBoolParams result ---');
      print(result);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'params:${widget.params}',
                    style: TextStyle(fontSize: 28.0, color: Colors.blue),
                  ),
                  FlatButton(
                    child: Text('open 页面'),
                    onPressed: () => Zoro.push(ZoroFlutterPage2.pageName, urlParams: {
                      'name': 'Jhon',
                      /// urlParams 布尔类型的参数会报错，exts 是参数可以
                      /// 'boolParam': true,
                    }),
                  ),
                  FlatButton(
                    child: Text('replace 页面'),
                    onPressed: () => Zoro.replace(ZoroFlutterPage2.pageName, urlParams: {
                      'name': 'Jhon',
                    }),
                  ),
                  FlatButton(
                    child: Text('跳转 Vr 页面'),
                    onPressed: () => Zoro.push(ZoroPageVr.pageName),
                  ),
                  FlatButton(
                    child: Text('跳转 PlatformView'),
                    onPressed: () => Zoro.push(PlatformRouteWidget.pageName),
                  ),
                  FlatButton(
                    child: Text('testBoolParams'),
                    onPressed: testBoolParams,
                  ),
                ],
              ),
              alignment: AlignmentDirectional.center,
            ),
          ],
        ),
      ),
    );
  }
}
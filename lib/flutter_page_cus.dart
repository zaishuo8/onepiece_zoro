import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';


class FlutterPageCus extends StatefulWidget {

  const FlutterPageCus({this.params});

  final Map<String, dynamic> params;

  @override
  _FlutterPageCus createState() => _FlutterPageCus();
}

class _FlutterPageCus extends State<FlutterPageCus> {

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: const Text(
          'flutter_page_cus',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text(
                  'params:${widget.params}',
                  style: TextStyle(fontSize: 28.0, color: Colors.blue),
                ),
                alignment: AlignmentDirectional.center,
              ),
              /*const CupertinoTextField(
                prefix: Icon(
                  CupertinoIcons.person_solid,
                  color: CupertinoColors.lightBackgroundGray,
                  size: 28.0,
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                clearButtonMode: OverlayVisibilityMode.editing,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0.0, color: CupertinoColors.inactiveGray),
                  ),
                ),
                placeholder: 'Name',
              ),*/
              /// 打开原生页面
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'open native page',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),

                /// 后面的参数会在 native 的 IPlatform.startActivity 方法回调中拼接到 url 的 query 部分。
                /// 例如：sample://nativePage?p1=v1
                onTap: () {

                  /// 这个 url 的协议是在 native 自定义的，定义在了 PageRoute 里面
                  String url = 'sample://nativePage';
                  Map<String, dynamic> query = {
                    'p1': 'v1',
                  };
                  Map<String, dynamic> urlParams = {
                    'query': query,
                  };

                  FlutterBoost.singleton.open(
                    url,
                    urlParams: urlParams,
                  );
                },
              ),
              /// 打开 flutter 页面，和打开原生页面用的是同一个方法
              /// 在 native 端会根据自定义的 url 来判断打开 native 页面还是 flutter 页面
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'open first cus',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),

                /// 后面的参数会在 native 的 IPlatform.startActivity 方法回调中拼接到 url 的 query 部分。
                /// 例如：sample://first?aaa=bbb
                onTap: () {
                  String url = 'firstCus';
                  Map<String, dynamic> query = {
                    'p2': 'v2',
                  };
                  Map<String, dynamic> urlParams = {
                    'query': query,
                  };

                  FlutterBoost.singleton.open(
                    url,
                    urlParams: urlParams,
                  );
                },
              ),
              /*InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'open second',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),

                /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                /// 例如：sample://nativePage?aaa=bbb
                onTap: () => FlutterBoost.singleton.open(
                  'second',
                  urlParams: <String, dynamic>{
                    'query': <String, dynamic>{'aaa': 'bbb'}
                  },
                ),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'open tab',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),

                /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                /// 例如：sample://nativePage?aaa=bbb
                onTap: () => FlutterBoost.singleton.open(
                  'tab',
                  urlParams: <String, dynamic>{
                    'query': <String, dynamic>{'aaa': 'bbb'}
                  },
                ),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'open flutter page',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),

                /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
                /// 例如：sample://nativePage?aaa=bbb
                onTap: () => FlutterBoost.singleton.open(
                  'sample://flutterPage',
                  urlParams: <String, dynamic>{
                    'query': <String, dynamic>{'aaa': 'bbb'}
                  },
                ),
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'push flutter widget',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),
                onTap: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(builder: (_) => PushWidget()),
                  );
                },
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'push Platform demo',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),
                onTap: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (_) => PlatformRouteWidget()),
                  );
                },
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.yellow,
                  child: const Text(
                    'open flutter fragment page',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                ),
                onTap: () =>
                    FlutterBoost.singleton.open('sample://flutterFragmentPage'),
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    child: Text(
                      'get system version by method channel:' + _systemVersion,
                      style: TextStyle(fontSize: 22.0, color: Colors.black),
                    )),
                onTap: () => _getPlatformVersion(),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
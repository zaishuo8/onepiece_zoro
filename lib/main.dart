import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'simple_page_widgets.dart';
import 'zoro_framework.dart';
import 'zoro_page.dart';
import 'zoro_page_2.dart';
import 'zoro_page_3.dart';
import 'zoro_page_4.dart';
import 'zoro_page_vr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();


    Zoro.registerPageBuilders(<String, BuilderConfig>{
      ZoroFlutterPage.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return ZoroFlutterPage(params: params);
        },
        appBarConfig: ZoroFlutterPage.appBarConfig,
      ),
      ZoroFlutterPage2.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return ZoroFlutterPage2(params: params);
        },
        appBarConfig: ZoroFlutterPage2.appBarConfig,
      ),
      ZoroFlutterPage3.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return ZoroFlutterPage3(params: params);
        },
        appBarConfig: ZoroFlutterPage3.appBarConfig,
      ),
      ZoroFlutterPage4.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return ZoroFlutterPage4(params: params);
        },
        appBarConfig: ZoroFlutterPage4.appBarConfig,
      ),
      ZoroPageVr.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return ZoroPageVr();
        },
      ),
      PlatformRouteWidget.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return PlatformRouteWidget();
        },
      ),
    });



    /*FlutterBoost.singleton.registerPageBuilders(<String, PageBuilder>{
      'embeded': (String pageName, Map<String, dynamic> params, String _) =>
          EmbeddedFirstRouteWidget(),
      'first': (String pageName, Map<String, dynamic> params, String _) => FirstRouteWidget(),
      'firstFirst': (String pageName, Map<String, dynamic> params, String _) =>
          FirstFirstRouteWidget(),
      'second': (String pageName, Map<String, dynamic> params, String _) => SecondRouteWidget(),
      'secondStateful': (String pageName, Map<String, dynamic> params, String _) =>
          SecondStatefulRouteWidget(),
      'tab': (String pageName, Map<String, dynamic> params, String _) => TabRouteWidget(),
      'platformView': (String pageName, Map<String, dynamic> params, String _) =>
          PlatformRouteWidget(),
      'flutterFragment': (String pageName, Map<String, dynamic> params, String _) =>
          FragmentRouteWidget(params),

      /// 可以在native层通过 getContainerParams 来传递参数
      'flutterPage': (String pageName, Map<String, dynamic> params, String _) {
        print('flutterPage params:$params');

        return FlutterRouteWidget(params: params);
      },







      /// cus
      'flutterPageCus': (String pageName, Map<String, dynamic> params, String _) {
        return FlutterPageCus(params: params);
      },
      'firstCus': (String pageName, Map<String, dynamic> params, String _) {
        return FirstCus();
      }

    });*/
    FlutterBoost.singleton.addBoostNavigatorObserver(TestBoostNavigatorObserver());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        home: Container(color: Colors.white)
    );
  }

  void _onRoutePushed(
    String pageName,
    String uniqueId,
    Map<String, dynamic> params,
    Route<dynamic> route,
    Future<dynamic> _,
  ) {}
}

class TestBoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPush');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPop');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didRemove');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print('flutterboost#didReplace');
  }
}

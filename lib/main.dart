import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:onepiece_zoro/fps_page.dart';
import 'package:onepiece_zoro/version_page.dart';
import 'error_catch_page.dart';
import 'simple_page_widgets.dart';
import 'zoro_framework.dart';
import 'zoro_page.dart';
import 'zoro_page_2.dart';
import 'zoro_page_3.dart';
import 'zoro_page_4.dart';
import 'zoro_page_vr.dart';

class Statistics {
  /// 错误发生数量统计
  static int errorCount = 0;
  /// 页面打开次数统计
  static int pagePV = 0;
}

typedef FpsWatchCallback = void Function(double fps);
class FPS {
  /// 原始回调
  static var _originalCallback;
  /// 取样帧数
  static final int _maxFrames = 25;
  /// 帧列表
  static final List<FrameTiming> _lastFrames = List<FrameTiming>();
  /// 基准 VSync 信号周期 1/60 s
  static final _frameInterval =
    const Duration(microseconds: Duration.microsecondsPerSecond ~/ 60);

  /// 检测的回调函数
  static FpsWatchCallback fpsWatchCallback;

  static void _onReportTimings(List<FrameTiming> timings) {
    /// 先拼接到 lastFrames 上
    _lastFrames.addAll(timings);
    /// 截取最后的 25 帧
    if (_lastFrames.length > _maxFrames) {
      _lastFrames.removeRange(0, _lastFrames.length - _maxFrames);
    }
    /// 执行回调函数
    if (fpsWatchCallback != null) {
      fpsWatchCallback(fps);
    }
    /// 如果有原始回调函数，执行
    if (_originalCallback != null) {
      _originalCallback(timings);
    }
  }
  
  static double get fps {
    if (_lastFrames.length <= 0) return 0;
    /// 原本应该渲染的帧数
    int shouldRender = 0;
    for (FrameTiming timing in _lastFrames) {
      // 计算每一帧耗时
      int duration = timing.timestampInMicroseconds(FramePhase.rasterFinish) -
          timing.timestampInMicroseconds(FramePhase.buildStart);
      // 计算原本因渲染的帧数
      if(duration < _frameInterval.inMicroseconds) {
        shouldRender += 1;
      } else {
        //有丢帧，向上取整
        int count = (duration / _frameInterval.inMicroseconds).ceil();
        shouldRender += count;
      }
    }
    return _lastFrames.length / shouldRender * 60;
  }

  static _init() {
    if (_originalCallback == null) {
      _originalCallback = window.onReportTimings;
      window.onReportTimings = FPS._onReportTimings;
    }
  }

  static startWatch(FpsWatchCallback fpsWatchCallback) {
    _init();
    FPS.fpsWatchCallback = fpsWatchCallback;
  }

  static endWatch() {
    fpsWatchCallback = null;
  }
}

void _reportError(dynamic e, StackTrace stack) {
  /// 统一错误处理
  Statistics.errorCount++;
  print('--- 错误发生总数: ${Statistics.errorCount} ----');
  print('--- 页面打开总数: ${Statistics.pagePV} ---');
  print('--- 页面错误率 ---');
  if (Statistics.pagePV == 0) Statistics.pagePV++;
  print('--- 页面错误率: ${Statistics.errorCount / Statistics.pagePV} ---');
  print('--- 统一错误处理: $e ---');
  print('--- 错误栈: $stack ---');
}

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (dynamic e, StackTrace stack) {
    _reportError(e, stack);
  });

  FlutterError.onError = (FlutterErrorDetails details) async {
    /// 转发到 Zone 中统一处理
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
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
      ErrorCatchPage.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return ErrorCatchPage(params: params);
        },
        appBarConfig: ErrorCatchPage.appBarConfig,
      ),
      FPSPage.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return FPSPage(params: params);
        },
        appBarConfig: FPSPage.appBarConfig,
      ),
      VersionPage.pageName: BuilderConfig(
        builder: (String pageName, Map<String, dynamic> params, String _) {
          return VersionPage(params: params);
        },
        appBarConfig: VersionPage.appBarConfig,
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
    
    
    
    FlutterBoost.singleton.addBoostNavigatorObserver(BoostNavigatorObserver());
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

class BoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPush');
    Statistics.pagePV++;
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

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:onepiece_zoro/main.dart';

import 'utils/device.dart';
import 'utils/http.dart';

/// 针对 FlutterBoost 的问题再上层封装一层
/// 问题：
///   - 缺少 replace popUntil close多个页面的接口
///   - 丢失了 AppBar 中统一的返回按钮
/// 功能：
///   - 实现 push()、pop(String num)、popUntil(String routeName)、replace() 接口
///   - 统一 AppBar
/// 顺带解决：
///   - FPS 统一监测
///   - 页面加载市场问题

class Zoro {

  static FlutterBoost get flutterBoost => FlutterBoost.singleton;

  static void registerPageBuilders(Map<String, BuilderConfig> builderConfig) {

    Map<String, PageBuilder> buildersWithDefaultAppBar = {};

    builderConfig.forEach((String pageName, BuilderConfig builderConfig) {
      buildersWithDefaultAppBar[pageName] =
          generateBuilderWithDefaultAppBar(
            builderConfig.builder,
            builderConfig.appBarConfig
          );
    });

    flutterBoost.registerPageBuilders(buildersWithDefaultAppBar);
  }

  static PageBuilder generateBuilderWithDefaultAppBar(
    PageBuilder builder,
    Map<String, dynamic> appBarConfig
  ) {
    return (String pageName, Map<String, dynamic> params, String uniqueId) {
      return WidgetWithDefaultAppBar(
        child: builder(pageName, params, uniqueId),
        appBarConfig: appBarConfig,
        flutterBoost: flutterBoost,
        pageName: pageName,
        uniqueId: uniqueId,
      );
    };
  }

  static void replace(String url, {
    Map<String, dynamic> urlParams,
    Map<String, dynamic> exts,
  }) {

    if (exts == null) {
      exts = { 'navigatorType': 'replace' };
    } else {
      exts['navigatorType'] = 'replace';
    }

    flutterBoost.open(
      url,
      urlParams: urlParams,
      exts: exts,
    );

  }

  static void reset(String url, {
    Map<String, dynamic> urlParams,
    Map<String, dynamic> exts,
  }) {

    if (exts == null) {
      exts = { 'navigatorType': 'reset' };
    } else {
      exts['navigatorType'] = 'reset';
    }

    flutterBoost.open(
      url,
      urlParams: urlParams,
      exts: exts,
    );

  }

  static void push(String url, {
    Map<String, dynamic> urlParams,
    Map<String, dynamic> exts,
  }) {
    flutterBoost.open(
      url,
      urlParams: urlParams,
      exts: exts,
    );
  }

  static void pushAndRemove(String url, {
    Map<String, dynamic> urlParams,
    Map<String, dynamic> exts,
  }) {

    if (exts == null) exts = {};
    if (exts['removePageNames'] == null) exts['removePageNames'] = [];

    flutterBoost.open(
      url,
      urlParams: urlParams,
      exts: exts,
    );

  }


}

class BuilderConfig {
  final PageBuilder builder;
  final Map<String, dynamic> appBarConfig;

  const BuilderConfig({
    @required this.builder,
    this.appBarConfig,
  });
}

class WidgetWithDefaultAppBar extends StatefulWidget {

  final Widget child;
  final Map<String, dynamic> appBarConfig;
  final FlutterBoost flutterBoost;
  final String pageName;
  final String uniqueId;

  /// 页面加载时间戳
  int startTime;
  /// 页面首次渲染完毕时间戳
  int renderedTime;

  WidgetWithDefaultAppBar({
    Key key,
    @required this.child,
    this.appBarConfig,
    this.flutterBoost,
    this.pageName,
    this.uniqueId,
  }) : super(key: key) {
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  _WidgetWithDefaultAppBarState createState() =>
      _WidgetWithDefaultAppBarState();
}

class _WidgetWithDefaultAppBarState extends State<WidgetWithDefaultAppBar> {

  List<double> fpsList = List<double>();
  reportFps() {
    final deviceInfo = DeviceUtil.getDeviceInfo();
    HttpUtil.post(HttpConfig.monitorReport, body: {
      'type': 2,
      'appId': 1,
      'phoneType': deviceInfo.phoneType,
      'phoneOs': deviceInfo.phoneOs,
      'phoneOsVersion': deviceInfo.phoneOsVersion,
      'pageName': widget.pageName,
      'fps': fpsList,
    });
  }

  reportLoadDuration() {
    final deviceInfo = DeviceUtil.getDeviceInfo();
    HttpUtil.post(HttpConfig.monitorReport, body: {
      'type': 3,
      'appId': 1,
      'phoneType': deviceInfo.phoneType,
      'phoneOs': deviceInfo.phoneOs,
      'phoneOsVersion': deviceInfo.phoneOsVersion,
      'pageName': widget.pageName,
      'duration': widget.renderedTime - widget.startTime,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: widget.child,
    );
  }

  buildAppBar() {
    if (widget.appBarConfig == null) {
      return null;
    }
    var title = widget.appBarConfig['title'];
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
        onPressed: () {
          widget.flutterBoost.close(widget.uniqueId);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    /// 检测 FPS
    FPS.startWatch((double fps) {
      print('-------- page: ${widget.pageName} ++++ fps: $fps --------');
      fpsList.add(fps);
    });

    /// 该帧渲染完会回调 addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.renderedTime = DateTime.now().millisecondsSinceEpoch;
      int timeSpend = widget.renderedTime - widget.startTime;
      print('-------- page: ${widget.pageName} ++++ timeSpend: $timeSpend ms --------');
      reportLoadDuration();
    });
  }

  @override
  void dispose() {
    FPS.endWatch();
    reportFps();
    super.dispose();
  }
}

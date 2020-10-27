import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boost/flutter_boost.dart';

/// 针对 FlutterBoost 的问题再上层封装一层
/// 问题：
///   - 缺少 replace popUntil close多个页面的接口
///   - 丢失了 AppBar 中统一的返回按钮
/// 功能：
///   - 实现 push()、pop(String num)、popUntil(String routeName)、replace() 接口
///   - 统一 AppBar

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
      return StatelessWidgetWithDefaultAppBar(
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

class StatelessWidgetWithDefaultAppBar extends StatelessWidget {

  final Widget child;
  final Map<String, dynamic> appBarConfig;
  final FlutterBoost flutterBoost;
  final String pageName;
  final String uniqueId;

  const StatelessWidgetWithDefaultAppBar({
    Key key,
    @required this.child,
    this.appBarConfig,
    this.flutterBoost,
    this.pageName,
    this.uniqueId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: child,
    );
  }

  buildAppBar() {
    if (appBarConfig == null) {
      return null;
    }
    var title = appBarConfig['title'];
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
          flutterBoost.close(uniqueId);
        },
      ),
    );
  }
}

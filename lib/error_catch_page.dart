import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

void isolate(String _) {
  throw StateError("Error in Isolate");
}

class ErrorCatchPage extends StatefulWidget {

  static String pageName = 'flutter://error_catch_page';
  static Map<String, dynamic> appBarConfig = {
    'title': '错误捕获测试',
  };

  const ErrorCatchPage({this.params});

  final Map<String, dynamic> params;

  @override
  _ErrorCatchPageState createState() => _ErrorCatchPageState();
}

class _ErrorCatchPageState extends State<ErrorCatchPage> {

  @override
  void initState() {
    super.initState();
  }

  testCatchError() async {
    /// 1. 同步函数 try - catch
    try {
      throw StateError('同步异常');
    } catch(e) {
      print('--- 同步异常 ---');
      print(e);
    }

    /// 2. Future try - catch
    try {
      Future.delayed(Duration(seconds: 1))
        .then((e) => throw StateError('try catch Future error'));
    } catch(e) {
      print('--- try catch Future error ---');
      print(e);
    }

    /// 3. Future catchError
    Future.delayed(Duration(seconds: 1))
      .then((e) => throw StateError('catchError future error'))
      .catchError((e) {
        print('--- catchError future error ---');
        print(e);
      });

    /// 4. async try - catch
    try {
      await Future.delayed(Duration(seconds: 1));
      throw StateError('try catch await error');
    } catch(e) {
      print('--- try catch await error ---');
      print(e);
    }
  }

  testRunZone() {
    runZoned(() {
      /// 1.同步抛出异常
      throw StateError('同步异常');
    }, onError: (dynamic e, StackTrace stack) {
      print(e);
    });

    runZoned(() {
      /// 2.异步抛出异常
      Future.delayed(Duration(seconds: 1))
          .then((e) => throw StateError('异步异常'));
    }, onError: (dynamic e, StackTrace stack) {
      print(e);
    });

    runZoned(() async {
      /// 3.await 抛出异常
      await Future.delayed(Duration(seconds: 1));
      throw StateError('await 异常');
    }, onError: (dynamic e, StackTrace stack) {
      print(e);
    });
  }
  
  throwAsyncError() {
    Future.delayed(Duration(seconds: 1))
        .then((e) => throw StateError('异步异常'));
  }

  throwSyncError() async {
    throw StateError('同步异常');
  }

  throwAwaitError() async {
    await Future.delayed(Duration(seconds: 1));
    throw StateError('await异常');
  }

  throwErrorInIsolate() async {
    final error = ReceivePort();
    await Isolate.spawn(
        isolate, "",
        onError: error.sendPort
    );
    final errorReceive = await error.first as List<dynamic>;
    final errorMessage = errorReceive[0] as String;
    print('--- error message from error sendPort');
    print(errorMessage);
    throw StateError(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("错误捕获测试"),
              onPressed: testCatchError,
            ),
            FlatButton(
              child: Text("runZone 错误回调测试"),
              onPressed: testRunZone,
            ),
            FlatButton(
              child: Text("抛出同步错误，测试顶层是否能捕获"),
              onPressed: throwSyncError,
            ),
            FlatButton(
              child: Text("抛出异步错误，测试顶层是否能捕获"),
              onPressed: throwAsyncError,
            ),
            FlatButton(
              child: Text("抛出await错误，测试顶层是否能捕获"),
              onPressed: throwAwaitError,
            ),
            FlatButton(
              child: Text("Isolate 内部错误，测试顶层是否能捕获"),
              onPressed: throwErrorInIsolate,
            ),
          ],
        ),
      ),
    );
  }
}
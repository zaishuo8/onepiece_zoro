import 'package:flutter/material.dart';
import 'config/version.dart';

class VersionPage extends StatefulWidget {
  static String pageName = 'flutter://flutter_version_page';
  static Map<String, dynamic> appBarConfig = {
    'title': 'Flutter 业务版本号',
  };

  const VersionPage({this.params});

  final Map<String, dynamic> params;

  @override
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Version.versionNumber)
    );
  }
}
import 'dart:convert';

import 'package:fair/fair.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'package:dynamic_project/plugins/net/fair_net_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fair_widget_page.dart';
import 'src/module.fair.dart' as g;

@FairBinding(packages: [
  'package:flutter_staggered_grid_view/src/widgets/staggered_grid.dart',
  'package:flutter_staggered_grid_view/src/widgets/masonry_grid_view.dart',
])
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FairPushy.init(debug: true);

  //这里的path是item的fair bundle产物
  FairDevTools.fairWidgetBuilder = (name, path) {
    return FairWidget(name: name, path: path, data: {
      'fairProps': jsonEncode({}),
    });
  };
  FairDevTools.config = FairDevConfig()
    ..addEnv(OnlineEnvInfo(
        envName: '环境1',
        updateUrl: 'https://fangfe.58.com/fairapp/module_patch_bundle',
        readOnly: true))
    ..addEnv(OnlineEnvInfo(envName: '环境2', updateUrl: '', readOnly: false));

  FairApp.runApplication(
    FairApp(
      generated: g.FairAppModule(),
      child: MyApp(),
    ),
    plugins: {'FairNet': FairNet()},
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fair Dynamic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('fair组件模板'),
      ),
      body: ListView(
        children: [
          addItem('gridview模板 + 网络请求插件', () {
            showWidget(
              fairPath: 'assets/fair/lib_template_gridview_template.fair.json',
              fairName: 'lib_template_gridview_template',
            );
          }),
          addItem('Fair开发者选项', () {
            FairDevTools.openDevPage(context);
          }),
        ],
      ),
    );
  }

  void showWidget({required fairPath, fairArguments, required fairName}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return FairWidgetPage(
        fairArguments: fairArguments,
        fairPath: fairPath,
        fairName: fairName,
      );
    }));
  }

  Widget addItem(String itemName, dynamic onPress) {
    return GestureDetector(
        onTap: onPress,
        child: Container(
            alignment: Alignment.centerLeft,
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0.5))),
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            )));
  }
}

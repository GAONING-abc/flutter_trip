import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'navigator/tab_navigator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String showResult = '';
  String countString = '';
  String localCounter = '';

  Future<CommonModel> fetchPost() async {
    final response = await http
        .get('http://www.devio.org/io/flutter_app/json/test_common_model.json');
    Utf8Decoder utf8decoder = Utf8Decoder(); //fix 中文乱码
    final result = json.decode(utf8decoder.convert(response.bodyBytes));
    return CommonModel.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Futur与FutureBuilder'),
          ),
          body: Column(
            children: <Widget>[
              FutureBuilder<CommonModel>(
                  future: fetchPost(),
                  builder: (BuildContext context,
                      AsyncSnapshot<CommonModel> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('input a url to start');
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          );
                        } else {
                          return Column(children: <Widget>[
                            Text('icon:${snapshot.data.icon}'),
                            Text('icon:${snapshot.data.title}'),
                            Text('icon:${snapshot.data.url}')
                          ]);
                        }
                    }
                  }),
              RaisedButton(
                  onPressed: _incrementCount(), child: Text('Increment Count')),
              RaisedButton(onPressed: _getCounter(), child: Text('Get Count')),
              Text(
                countString,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                localCounter,
                style: TextStyle(fontSize: 20),
              ),
            ],
          )),
    );
  }

  _incrementCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countString = countString + "1";
    });
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
  }

  _getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      localCounter = prefs.getInt('counter').toString();
    });
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
  }
}

class CommonModel {
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;

  CommonModel(
      {this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      statusBarColor: json['statusBarColor'],
      hideAppBar: json['hideAppBar'],
    );
  }
}

import 'package:flutter/material.dart';

import 'hotel_app_theme.dart';

import 'package:webview_flutter/webview_flutter.dart';

class SettingScreenPage extends StatefulWidget {
  @override
  _SettingScreenPage createState() => _SettingScreenPage();
}

class _SettingScreenPage extends State<SettingScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(  // leadingプロパティにIconButtonを使用
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black, // アイコンの色を赤色に設定
        ),
        title: Text('privacy policy',style: TextStyle(color: Colors.black),),
        backgroundColor: HotelAppTheme
            .buildLightTheme()
            .colorScheme
            .background,
      ),
      body: WebView(
        initialUrl: 'https://puni-pro.github.io/Kosen_share/',  //表示したいWebページを指定する
        javascriptMode: JavascriptMode.unrestricted, // JavaScriptを有効にする
      ),
      );

  }
}
/*
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
title: Text("ログアウトしますか？"),
actions: <Widget>[
TextButton(
child: Text(
"キャンセル", style: TextStyle(color: HotelAppTheme
    .buildLightTheme()
    .primaryColor),),
onPressed: () {
Navigator.of(context).pop();
},
),
TextButton(
child: Text(
"ログアウト", style: TextStyle(color: HotelAppTheme
    .buildLightTheme()
    .primaryColor)),
onPressed: () {
_handleSignOut();
Navigator.of(context).pushReplacement(
MaterialPageRoute(
builder: (context) => App()),
);
},
),
],
);
},
);

 */
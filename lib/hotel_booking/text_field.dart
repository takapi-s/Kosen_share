import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController textController; // テキストコントローラーを追加

  MyTextField({required this.textController});
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController textController;


  @override
  void initState() {
    super.initState();
    textController.addListener(_onTextChanged); // テキストが変更された際に呼び出されるリスナーを登録
  }

  @override
  void dispose() {
    textController.dispose(); // コントローラを解放
    super.dispose();
  }

  void _onTextChanged() {
    // テキストが変更された時に実行される処理
    final enteredText = textController.text;
    // 入力したテキストを保存したい場合はここに保存する処理を追加する
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Subject',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: TextField(

            controller: textController, // コントローラを指定
            decoration: InputDecoration(

              hintText: '数学',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            autofocus: true, // ウィジェットが表示された際に自動でフォーカスされるようにする
          ),
        ),
      ],
    );
  }
}

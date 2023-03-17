import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:kosen_test_trades/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosen_test_trades/hotel_booking/hotel_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';

import 'hotel_booking/hotel_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'KOSEN SHARES',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  static bool login = false;
  static User? user = null;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        App.login = true;
        App.user = user;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Widget body;
    if (false == App.login) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Expanded(child: SizedBox()),
            Text(
              '津山高専の過去問が集まる場所',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 2.0, color: Colors.grey),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                  // アカウント作成の処理をここに記述
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: HotelAppTheme
                        .buildLightTheme()
                        .primaryColor,),
                    SizedBox(width: 10),
                    Text('アカウント作成',
                        style: TextStyle(fontSize: 18, color: HotelAppTheme
                            .buildLightTheme()
                            .primaryColor)),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Text.rich(
              TextSpan(
                text: 'アカウントをお持ちの方は',
                children: [
                  TextSpan(
                    text: 'ログイン',
                    style: TextStyle(
                      color: HotelAppTheme
                          .buildLightTheme()
                          .primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                        // ログインをクリックしたときの処理
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      body = EmailVerificationScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOSEN SHARES',
      home: Scaffold(
        body: body,
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namewordController = TextEditingController();
  String? error;


  Future<void> _signUp() async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await FirebaseAuth.instance.currentUser?.updateDisplayName(_namewordController.text);

      final User? user = userCredential.user;
      // ユーザーの作成に成功した場合は、ログイン後の画面に移動する
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(),
          ),
        );
      }else{
        print(user);
      }
    } catch (e) {
      print(e);
      print('fgfff');
      setState(() {
        error = e.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create your account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              Text(
                '過去問共有頑張って',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: _namewordController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _signUp();
                },
                child: Text('アカウント作成'),
              ),
              Text(
                error ?? '',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              ),

              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}



class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      // ログインに成功した場合は、ログイン後の画面に移動する
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'ユーザーが見つかりませんでした。';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'パスワードが間違っています。';
      } else {
        errorMessage = 'エラーが発生しました。もう一度お試しください。';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      print(e);
    }
  }



  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      // パスワード再発行のメールが送信された旨を表示する
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('パスワード再発行用のメールを送信しました'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'ユーザーが見つかりませんでした。';
      } else {
        errorMessage = 'エラーが発生しました。もう一度お試しください。';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Log In'),
            ),
            TextButton(
              onPressed: _resetPassword,
              child: Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}


class EmailVerificationScreen extends StatefulWidget {

  @override
  _EmailVerificationScreen createState() => _EmailVerificationScreen();
}

class _EmailVerificationScreen extends State<EmailVerificationScreen> {

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getEmailVeri() async  {
    await user!.reload();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
    );

  }


  Future<void> createDocumentWithId(String collectionName, String? documentName) async {
    try {
      await FirebaseFirestore.instance.collection(collectionName).doc(documentName).set({
        'Likes' : []
      });
      print('Document created successfully!');
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    if (user != null && user!.emailVerified) {
      // メール認証が完了している場合は、次の画面に遷移する
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HotelHomeScreen()),
        );
      });
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // メール認証が完了していない場合は、確認画面を表示する
      return Scaffold(
        appBar: AppBar(title: Text('確認'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('メールを確認してください'),
              Text('メールアドレス'+ (user?.email ?? '')),
              ElevatedButton(
                child: Text('再送信'),
                onPressed: () {
                  user?.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('確認メールを再送信しました'),
                    ),
                  );
                },
              ),
              ElevatedButton(
                  child: Text('次へ'),
                  onPressed: () {
                    createDocumentWithId('User', user!.email);
                    getEmailVeri();
                  }
              ),
            ],
          ),
        ),
      );

    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/Auth/emailSignIn.dart';
import 'package:preblo/Auth/googleAuth.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../StartPage.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool _isObscure = true;
  String? address;
  String? password;
  String? email;
  String? errorText;

//////////////////////////////////////////////////email承認//////////////////////////////////////////////
  void signInWithEmailAndPassword(emailAddress, password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return const StartPage();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(() {
          errorText = '登録されていないアドレスです。';
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        setState(() {
          errorText = 'パスワードが違います。';
        });
      }
    }
  }

//////////////////////////////////////////////////google//////////////////////////////////////////////
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  trySignGoogle() async {
    try {
      await signInWithGoogle();
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return const googleAuthPage();
      }));
    } catch (e) {
      print(e);
    }
    ;
  }

//////////////////////////////////////////////////twitter//////////////////////////////////////////////
  Future<UserCredential> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final twitterLogin = new TwitterLogin(
        apiKey: 'J8OAT8BFPbC4EcCjXMsYP8svz',
        apiSecretKey: 'dqgQHdyfck4XyuX2EXciKQShFiBs3BA8XVvLK76rNikhrQQZbL',
        redirectURI:
            'https://my-project-34953-b6df5.firebaseapp.com/__/auth/handler');

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(twitterAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NewGradientAppBar(
          title: Text('ログイン'),
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
          ),
        ),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "▼下記フォームからログインしてください",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        children: [
                          SizedBox(
                              width: 300,
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'メールアドレスを入力してください',
                                  ),
                                  onChanged: (val) {
                                    email = val;
                                    setState(() {
                                      errorText = null;
                                    });
                                  })),
                          SizedBox(
                              width: 300,
                              child: TextFormField(
                                  onChanged: (val) {
                                    password = val;
                                  },
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      labelText: 'パスワードを入力してください',
                                      suffixIcon: IconButton(
                                          icon: Icon(_isObscure
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                              errorText = null;
                                            });
                                          })))),
                          errorText == null
                              ? SizedBox.shrink()
                              : Text(
                                  errorText!,
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton(
                                child: Text('ログイン'),
                                onPressed: () {
                                  signInWithEmailAndPassword(email, password);
                                }),
                          )
                        ],
                      ),
                    ),
                    SignInButton(Buttons.Email, onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => emailSignIn()));
                    }),
                    SignInButton(Buttons.Google, onPressed: () {
                      trySignGoogle();
                    }),
                    // SignInButton(Buttons.Twitter, onPressed: () {
                    //   signInWithTwitter();
                    // }),
                  ],
                )),
          ],
        ));
  }
}

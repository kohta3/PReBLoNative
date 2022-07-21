import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/Auth/addDatabaseFromEmail.dart';

import '../main.dart';
import 'VerifyEmail.dart';

class emailSignIn extends StatefulWidget {
  const emailSignIn({Key? key}) : super(key: key);

  @override
  State<emailSignIn> createState() => _emailSignInState();
}

class _emailSignInState extends State<emailSignIn> with RouteAware {
  String? email;
  String Email='';
  String? password;
  String? ErrorLog;
  String? PasswordCheck;
  bool isVisible = false;
  bool chkJudge = false;
  int? passwordLength;

  void toggleShowPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  JudgeCheckPassword(password, passwordCheck) {
    setState(() {
      chkJudge = (password == passwordCheck);
    });
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  createUserWithEmailAndPassword(emailAddress, password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => addDatabaseFromEmail(
                passwordLength: '${PasswordCheck}', mailAddress: Email)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        setState(() {
          ErrorLog = '入力されたアドレスは登録済みです';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text('新規登録'),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidateText.email,
                      decoration: const InputDecoration(
                          filled: true, hintText: 'メールアドレス'),
                      onChanged: (text) {
                        setEmail(text);
                        setState((){Email = text;});
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidateText.password,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              toggleShowPassword();
                            },
                          ),
                          filled: true,
                          hintText: 'パスワード'),
                      onChanged: (text) {
                        setPassword(text);
                      },
                      obscureText: !isVisible,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidateText.password,
                      decoration:
                          InputDecoration(filled: true, hintText: 'パスワード確認用'),
                      onChanged: (text) {
                        setState(() {
                          PasswordCheck = text;
                          chkJudge = (PasswordCheck == this.password);
                        });
                      },
                    ),
                    chkJudge
                        ? SizedBox.shrink()
                        : Row(
                            children: [
                              SizedBox(width: 11),
                              Text(
                                'パスワードが一致しません',
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 12),
                              ),
                            ],
                          ),
                    ElevatedButton(
                      onPressed: () {
                        chkJudge
                            ? createUserWithEmailAndPassword(email, password)
                            : print('mistake');
                      },
                      child: const Text("新規登録"),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class ValidateText {
  static String? name(String? value) {
    if (value != null) {
      String pattern = r'^[a-zA-Z0-9]{3,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return '3文字以上の英数字を入力してください';
      }
    }
  }

  static String? password(String? value) {
    if (value != null) {
      String pattern = r'^[a-zA-Z0-9]{6,}$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return '6文字以上の英数字を入力してください';
      }
    }
  }

  static String? email(String? value) {
    if (value != null) {
      String pattern = r'^[0-9a-z_./?-]+@([0-9a-z-]+\.)+[0-9a-z-]+$';
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return '正しいメールアドレスを入力してください';
      }
    }
  }
}

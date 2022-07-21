import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/setting/TermsOfUse.dart';
import 'package:preblo/setting/resourse.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future onLaunchMail() async {
    final email = Uri(
      scheme: "mailto",
      path: "preblo.offficial@gmail.com",
      queryParameters: {
        "subject": "PReBLo問い合わせ",
        "body": "内容",
      },
    );
    if (await canLaunch(email.toString())) {
      await launch(email.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NewGradientAppBar(
        title: const Text('設定'),
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    alignment: Alignment.topLeft,
                    width: screenSize.width * 1,
                    child: Text('問い合わせ',
                        style: TextStyle(fontSize: 24, color: Colors.blue)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                    )),
                onTap: () {
                  onLaunchMail();
                },
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    alignment: Alignment.topLeft,
                    width: screenSize.width * 1,
                    child: Text('利用規約',
                        style: TextStyle(fontSize: 24, color: Colors.blue)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        top: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                    )),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ternsOfUsePage();
                      },
                    ),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    alignment: Alignment.topLeft,
                    width: screenSize.width * 1,
                    child: Text('リリース',
                        style: TextStyle(fontSize: 24, color: Colors.blue)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                    )),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return resources();
                      },
                    ),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    alignment: Alignment.topLeft,
                    width: screenSize.width * 1,
                    child: Text('寄付',
                        style: TextStyle(fontSize: 24, color: Colors.blue)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                    )),
                onTap: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}

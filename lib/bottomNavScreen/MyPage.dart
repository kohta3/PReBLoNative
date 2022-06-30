import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                width: screenSize.width*1,
                  decoration: BoxDecoration(
                      border: Border(
                        bottom:BorderSide(
                          width:1,
                          color: Colors.grey
                        ),
                      )
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "過去の投稿",
                        style: TextStyle(fontSize: 24),
                      ))),
              Container(
                  width: screenSize.width*1,
                  decoration: BoxDecoration(
                      border: Border(
                        bottom:BorderSide(
                            width:1,
                            color: Colors.grey
                        ),
                      )
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "アカウント管理",
                        style: TextStyle(fontSize: 24),
                      ))),Container(
                  width: screenSize.width*1,
                  decoration: BoxDecoration(
                      border: Border(
                        bottom:BorderSide(
                            width:1,
                            color: Colors.grey
                        ),
                      )
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "投稿の修正",
                        style: TextStyle(fontSize: 24),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}

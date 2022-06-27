import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:preblo/submissionDetailsPage.dart';

class DetailPage extends StatelessWidget {
  final genre;
  final region;
  final pref;
  final city;

  DetailPage({
    this.genre,
    this.region,
    this.pref,
    this.city,
  });

  _firstFunction(word) {
    return Text(
      word,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  List testImage = [
    'https://pbs.twimg.com/media/FTA5xHzVsAAkiZx?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRzvnCJagAAoSU7?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRyc4p8acAAcmq8?format=jpg&name=small',
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTA5xHzVsAAkiZx?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRzvnCJagAAoSU7?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRyc4p8acAAcmq8?format=jpg&name=small',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTA5xHzVsAAkiZx?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRzvnCJagAAoSU7?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRyc4p8acAAcmq8?format=jpg&name=small',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTA5xHzVsAAkiZx?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRzvnCJagAAoSU7?format=jpg&name=small',
    'https://pbs.twimg.com/media/FRyc4p8acAAcmq8?format=jpg&name=small',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
    'https://pbs.twimg.com/media/FURkhtlVEAAbXEP?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTS2p_SaQAEYye0?format=jpg&name=4096x4096',
    'https://pbs.twimg.com/media/FTQPDUrUsAA2JVY?format=jpg&name=large',
    'https://pbs.twimg.com/media/FTOKuYGVsAEhKJ9?format=jpg&name=large',
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NewGradientAppBar(
        title: (genre == "")
            ? _firstFunction('検索結果 ( 地域:' + pref + '>' + city + " ) ")
            : _firstFunction('検索結果 ( カテゴリー:' + genre + " ) "),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_box_rounded),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: Wrap(alignment: WrapAlignment.spaceEvenly, children: [
              for (var image in testImage)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => submissionDetailsPage()),
                    );
                  },
                  child: Image(
                    image: NetworkImage(image),
                    width: screenSize.width * 0.33,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
            ]),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'DetailPage.dart';

class SearchGenrePage extends StatefulWidget {
  const SearchGenrePage({Key? key}) : super(key: key);

  @override
  State<SearchGenrePage> createState() => _SearchGenrePageState();
}

class _SearchGenrePageState extends State<SearchGenrePage> {
  List<String> selectedGenre = [
    "観光地",
    "自然",
    "建物",
    "買い物",
    "体験",
    "施設",
    "イベント",
    "宿泊施設",
    "旅館",
    "ホテル",
    "民宿",
    "ゲストハウス",
    "キャンプ場",
    "車中泊",
    "ライダーハウス",
    "飲食店",
    'ご当地グルメ',
    '和食',
    '洋食',
    'ファストフード',
    'ファミレス',
    '喫茶店',
    '居酒屋',
    'エスニック',
    'ジョイフル'
  ];
  var nextGenre = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: const Text('ジャンル検索'),
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
      body: ListView.builder(
        itemCount: selectedGenre.length,
        itemBuilder: (BuildContext context, int index) {
          return (index == 0)
              ? Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.only(left: 10, top: 7),
                  child: Row(children: [
                    const Icon(Icons.luggage),
                    Text(selectedGenre[index])
                  ]))
              : (index == 7)
                  ? Container(
                      color: Colors.grey[300],
                      padding: const EdgeInsets.only(left: 10, top: 7),
                      child: Row(children: [
                        const Icon(Icons.hotel),
                        Text(selectedGenre[index])
                      ]))
                  : (index == 15)
                      ? Container(
                          color: Colors.grey[300],
                          padding: const EdgeInsets.only(left: 10, top: 7),
                          child: Row(children: [
                            const Icon(Icons.restaurant),
                            Text(selectedGenre[index])
                          ]))
                      : TextButton(
                          onPressed: () {
                            nextGenre = selectedGenre[index];
                            print(nextGenre);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    genre: nextGenre, region: "",
                                    pref: "",
                                    city: ""
                                  )),
                            );
                          },
                          child: Text(selectedGenre[index]));
        },
      ),
    );
  }
}

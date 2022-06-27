import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({Key? key}) : super(key: key);

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  String _location = "no data";

  bool isChecked = false;
  bool dontKnow = true;
  bool holiday = false;

  File? _image;
  final picker = ImagePicker();

  TimeOfDay _timeStart = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _timeClose = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _timeStart2 = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _timeClose2 = TimeOfDay(hour: 0, minute: 00);

  void _selectTime1() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart,
    );
    if (newTime != null) {
      setState(() {
        _timeStart = newTime;
      });
    }
  }
  void _selectTime2() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart,
    );
    if (newTime != null) {
      setState(() {
        _timeClose = newTime;
      });
    }
  }
  void _selectTime3() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart2,
    );
    if (newTime != null) {
      setState(() {
        _timeStart2 = newTime;
      });
    }
  }
  void _selectTime4() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeClose2,
    );
    if (newTime != null) {
      setState(() {
        _timeClose2 = newTime;
      });
    }
  }

  void getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = position.toString();
      });
      print(position);
    } catch (e) {
      print(e);
    }
  }

  Map<String, bool> dayOfTheWeeksBools = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };
  List<String> dayOfTheWeeks = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  //カメラ用
  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //写真ライブラリの読み込み用
  Future _getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: ListView(children: [
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text('👇今の気持ちを教えてください。'),
                ),
                SizedBox(
                    width: screenSize.width * 1,
                    child: const TextField(
                      maxLength: 20,
                      obscureText: false,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        hintText: 'ひとことどうぞ。',
                        icon: Icon(Icons.comment),
                      ),
                    )),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Text('👇なんていう場所ですか?'),
                ),
                Row(children: [
                  Icon(Icons.travel_explore),
                  SizedBox(
                      width: screenSize.width * 0.5,
                      child: const TextField(
                        maxLength: 20,
                        obscureText: false,
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          labelText: '場所の名前',
                        ),
                      )),
                  SizedBox(
                    width: screenSize.width * 0.1,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getLocation();
                      },
                      child: Text('現在地'))
                ]),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      const Text('👇登録する地域を教えてください。'),
                    ])),
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.3,
                      child: DropdownButton(
                          hint: const Text('都道府県'),
                          items: [
                            for (int i = 0; i < 3; i++)
                              DropdownMenuItem(
                                value: 'aaa',
                                child: Text('aaa'),
                                onTap: () {
                                  print(Text('data'));
                                },
                              ),
                          ],
                          onChanged: (String? value) {}),
                    ),
                    SizedBox(
                      child: DropdownButton(
                          hint: const Text('市区町村'),
                          items: [
                            for (int i = 0; i < 3; i++)
                              const DropdownMenuItem(
                                value: 'aaa',
                                child: Text('aaa'),
                              ),
                          ],
                          onChanged: (String? value) {}),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        width: screenSize.width * 0.3,
                        child: const TextField(
                          maxLength: 20,
                          obscureText: false,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            labelText: '以下の住所',
                          ),
                        )),
                  ],
                ),
                Text(_location),
                Row(children: [
                  const SizedBox(
                    child: Text('👇営業時間を教えてください。　わからない:'),
                  ),
                  Checkbox(
                      activeColor: Colors.lightBlueAccent[100],
                      value: dontKnow,
                      onChanged: (value) {
                        setState(() {
                          dontKnow = value!;
                        });
                      }),
                ]),
                Column(children: [
                  (dontKnow == false)
                      ? Row(
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.2,
                              child: ElevatedButton(
                                onPressed: _selectTime1,
                                child: Text("$_timeStart"
                                    .replaceFirst('TimeOfDay(', "")
                                    .replaceFirst(')', "")),
                              ),
                            ),
                            Text('から'),
                            SizedBox(
                              width: screenSize.width * 0.2,
                              child: ElevatedButton(
                                onPressed: _selectTime2,
                                child: Text("$_timeClose"
                                    .replaceFirst('TimeOfDay(', "")
                                    .replaceFirst(')', "")),
                              ),
                            ),
                            Checkbox(
                                activeColor: Colors.lightBlueAccent[100],
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                }),
                            Text("行を追加"),
                          ],
                        )
                      : Text(''),
/////////////////////////////////////////////行を追加した場合/////////////////////////////////////////////
                  (isChecked == true)
                      ? Row(children: [
                          SizedBox(
                            width: screenSize.width * 0.2,
                            child: ElevatedButton(
                              onPressed: _selectTime3,
                              child: Text("$_timeStart2"
                                  .replaceFirst('TimeOfDay(', "")
                                  .replaceFirst(')', "")),
                            ),
                          ),
                          const Text('から'),
                          SizedBox(
                            width: screenSize.width * 0.2,
                            child: ElevatedButton(
                              onPressed: _selectTime4,
                              child: Text("$_timeClose2"
                                  .replaceFirst('TimeOfDay(', "")
                                  .replaceFirst(')', "")),
                            ),
                          ),
                        ])
/////////////////////////////////////////////行を追加した場合/////////////////////////////////////////////
                      : Text(''),
                ]),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Text('👇休みはありますか？'),
                ),
                Row(children: [
                  Checkbox(
                      value: holiday,
                      onChanged: (value) {
                        setState(() {
                          holiday = value!;
                        });
                      }),
                  const Text('休みがある場合はチェックて下さい')
                ]),
                (holiday == false)
                    ? Text('')
                    : Wrap(
                        children: [
                          for (int i = 0; i < 7; i++)
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              width: screenSize.width * 0.2,
                              child: Column(children: [
                                Text(dayOfTheWeeks[i]),
                                Checkbox(
                                    value: dayOfTheWeeksBools[dayOfTheWeeks[i]],
                                    onChanged: (value) {
                                      setState(() {
                                        dayOfTheWeeksBools[dayOfTheWeeks[i]] =
                                            value!;
                                      });
                                    }),
                              ]),
                            )
                        ],
                      ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text('👇URLを入力してください。'),
                    ),
                    SizedBox(
                        width: screenSize.width * 1,
                        child: const TextField(
                          obscureText: false,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: 'リンク先を入力',
                            icon: Icon(Icons.link),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Text('👇電話番号を入力してください'),
                    ),
                    SizedBox(
                        width: screenSize.width * 1,
                        child: const TextField(
                          obscureText: false,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            hintText: '電話番号を入力',
                            icon: Icon(Icons.call),
                          ),
                        )),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _image == null
                            ? const Text('No image selected.')
                            : Image.file(_image!),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: getImageFromCamera,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.brown,
                              ),
                              child: Row(children: const [
                                Icon(Icons.add_a_photo),
                                Text("写真を撮る")
                              ]),
                            ),
                            ElevatedButton(
                                onPressed: _getImage,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.brown,
                                ),
                                child: Row(children: const [
                                  Icon(Icons.image),
                                  Text("写真を保存する")
                                ])),
                          ],
                        )
                      ],
                    )),
                  ],
                ),
                ElevatedButton(onPressed: () {}, child: Text('submit'))
              ],
            ),
          ],
        ),
      ),
    ]));
  }
}

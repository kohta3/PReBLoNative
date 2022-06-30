import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> tsets = [
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
    'メバチマグロ噴火山',
    '本マグロ噴火山',
  ];
  List<String> images = [
    'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large',
    'https://pbs.twimg.com/media/FUYeYK0VEAA2_UE?format=jpg&name=large',
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          child: const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(32.8479276, 130.7257457),
              zoom: 7,
            ),
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.345,
              minHeight: MediaQuery.of(context).size.height * 0.1,
              maxWidth: double.infinity,
              minWidth: double.infinity,
            ),
            child: ListView(
              children: [
                for (var test in tsets)
                  Row(
                    children: [
                      Image(
                        image: const NetworkImage(
                            'https://pbs.twimg.com/media/FUtHmHBXoAADWF7?format=jpg&name=large'),
                        width: screenSize.width * 0.4,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      Text(test)
                    ],
                  ),
              ],
            ))
      ],
    ));
  }
}

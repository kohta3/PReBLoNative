import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';

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
  double Lat = 35.170915;
  double Long = 136.881537;
  String _location = "no data";

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
        Lat = double.parse(_location.split(',')[0].replaceFirst('Latitude: ',''));
        Long = double.parse(_location.split(',')[1].replaceFirst('Longitude: ',''));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                width: double.infinity,
                height: screenSize.height * 0.5,
                child: FlutterMap(
                    options: MapOptions(
                      interactiveFlags: InteractiveFlag.drag |
                      InteractiveFlag.flingAnimation |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom,
                      enableScrollWheel: true,
                      center: latLng.LatLng(Lat, Long),
                      zoom: 13.0,
                      maxZoom: 17.0,
                      minZoom: 1.0,
                      
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        retinaMode: true,
                      ),
                    ]),
              ),
              FloatingActionButton(
                child: Icon(Icons.my_location),
                onPressed: () {
                  getLocation();
                },
              ),
            ],
          ),
          Expanded(
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
          )),
        ],
      ),
    );
  }
}

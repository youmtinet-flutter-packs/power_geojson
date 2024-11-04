import 'dart:math';

import 'package:console_tools/console_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

class CustomCrsPage extends StatefulWidget {
  static const String route = 'custom_crs';

  const CustomCrsPage({Key? key}) : super(key: key);

  @override
  State<CustomCrsPage> createState() => _CustomCrsPageState();
}

class _CustomCrsPageState extends State<CustomCrsPage> {
  late final proj4.Projection epsg4326;
  late final proj4.Projection epsg26191;
  late final proj4.Projection epsg4269;
  late final proj4.Projection epsg3857;
  late final proj4.Projection epsg3785;
  late final proj4.Projection epsg900913;
  late final proj4.Projection epsg102113;
  late final proj4.Projection google;
  late final Proj4Crs epsg26191CRS;

  final resolutions = <double>[
    32768,
    16384,
    8192,
    4096,
    2048,
    1024,
    512,
    256,
    128
  ];
  proj4.Point point = proj4.Point(x: -2.328758, y: 34.928685);
  String initText = 'Map centered to';
  double? maxZoom;

  final epsg26191Bounds = Bounds<double>(
    const Point<double>(-276362.47, -296555.37),
    const Point<double>(895990.96, 604816.69),
  );

  @override
  void initState() {
    super.initState();
    maxZoom = (resolutions.length - 1).toDouble();
    epsg4326 = proj4.Projection.get('EPSG:4326')!;
    epsg4269 = proj4.Projection.get('EPSG:4269')!;
    epsg3857 = proj4.Projection.get('EPSG:3857')!;
    epsg3785 = proj4.Projection.get('EPSG:3785')!;
    epsg900913 = proj4.Projection.get('EPSG:900913')!;
    epsg102113 = proj4.Projection.get('EPSG:102113')!;
    google = proj4.Projection.get('GOOGLE')!;
    epsg26191 = proj4.Projection.get('EPSG:26191') ??
        proj4.Projection.add(
          'EPSG:26191',
          'PROJCS["Nord_Maroc",GEOGCS["GCS_Merchich",DATUM["D_Merchich",SPHEROID["Clarke_1880_IGN",6378249.2,293.466021293627]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Lambert_Conformal_Conic"],PARAMETER["False_Easting",500000.0],PARAMETER["False_Northing",300000.0],PARAMETER["Central_Meridian",-5.4],PARAMETER["Standard_Parallel_1",33.3],PARAMETER["Scale_Factor",0.999625769],PARAMETER["Latitude_Of_Origin",33.3],UNIT["Meter",1.0]]',
        );
    epsg26191CRS = Proj4Crs.fromFactory(
      code: 'EPSG:26191',
      proj4Projection: epsg26191,
      resolutions: resolutions,
      bounds: epsg26191Bounds,
      origins: const [Point<double>(0, 0)],
      scales: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    var epsg4326X = point.x.toStringAsFixed(5);
    var epsg4326Y = point.y.toStringAsFixed(5);
    return Scaffold(
      appBar: AppBar(title: const Text('Custom CRS')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 2),
              child: Text(
                'This map is in EPSG:26191',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 2),
              child: Text('$initText ($epsg4326X, $epsg4326Y) in EPSG:4326.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text('${transforma(google, 'GOOGLE')}.'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: Text('${transforma(epsg26191, 'EPSG:26191')}.'),
            ),
            Flexible(
              child: fMap(),
            ),
          ],
        ),
      ),
    );
  }

  FlutterMap fMap() {
    return FlutterMap(
      options: MapOptions(
        crs: epsg26191CRS,
        initialCenter: LatLng(point.x, point.y),
        initialZoom: 3,
        //   maxZoom: maxZoom,
        onTap: (tapPosition, p) => setState(() {
          initText = 'You clicked at';
          point = proj4.Point(x: p.latitude, y: p.longitude);
        }),
      ),
      children: [
        WMSTileLayer(epsg26191CRS: epsg26191CRS),
        TileLayer(
          tileDisplay: const TileDisplay.fadeIn(),
          errorImage: const AssetImage('assets/images/flutter_logo.png'),
          errorTileCallback: (tile, error, trace) {
            Console.log(tile.imageInfo);
          },
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(point.y, point.x),
              child: const Icon(
                Icons.location_history_sharp,
                color: Colors.black,
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        )
      ],
    );
  }

  String transforma(proj4.Projection projection, String ePSG) {
    var ptTransformed = epsg4326.transform(projection, point);
    var x = ptTransformed.x.toStringAsFixed(ptTransformed.x < 180 ? 5 : 2);
    var y = ptTransformed.y.toStringAsFixed(ptTransformed.x < 180 ? 5 : 2);
    return 'Point($x, $y) in $ePSG';
  }
}

class WMSTileLayer extends StatelessWidget {
  const WMSTileLayer({
    Key? key,
    required this.epsg26191CRS,
  }) : super(key: key);

  final Proj4Crs epsg26191CRS;

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      wmsOptions: WMSTileLayerOptions(
        crs: epsg26191CRS,
        transparent: true,
        format: 'image/jpeg',
        baseUrl:
            'https://www.gebco.net/data_and_products/gebco_web_services/north_polar_view_wms/mapserv?',
        layers: const ['gebco_north_polar_view'],
      ),
    );
  }
}

/* Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 2),
    child: Text('${transforma(epsg4269, 'EPSG:4269')}.'),
),
Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 2),
    child: Text('${transforma(epsg3857, 'EPSG:3857')}.'),
),
Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 2),
    child: Text('${transforma(epsg3785, 'EPSG:3785')}.'),
),
Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 2),
    child: Text('${transforma(epsg900913, 'EPSG:900913')}.'),
),
Padding(
    padding: const EdgeInsets.only(top: 2, bottom: 2),
    child: Text('${transforma(epsg102113, 'EPSG:102113')}.'),
), */
/* const Padding(
    padding: EdgeInsets.only(top: 2, bottom: 8),
    child: Text('Tap on map to get more coordinates!'),
), */

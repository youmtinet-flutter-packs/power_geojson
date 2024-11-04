import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

class StringGeoJSONPolygon extends StatelessWidget {
  const StringGeoJSONPolygon({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONPolygons.string(
      stringPolygons,
      polygonProperties: const PolygonProperties(
        fillColor: Color(0xFFA2210A),
        rotateLabel: true,
        label: 'String',
        labelStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.black,
          shadows: [
            Shadow(blurRadius: 10, color: Colors.white),
          ],
          decoration: TextDecoration.underline,
        ),
        labeled: true,
      ),
      mapController: _mapController,
    );
  }
}

const stringPolygons = '''{
  "type" : "FeatureCollection",
  "features" : [{"type":"Feature","id":1,"geometry":{"type":"Polygon","coordinates":[[[-4.2462153638288234,31.29611174898427],[-4.2451313443175991,31.296392442559789],[-4.2447305861064226,31.296532788650225],[-4.2453350085621731,31.298351655445305],[-4.2469446134815438,31.297818349175273],[-4.2462153638288234,31.29611174898427]]]},"properties":{"OBJECTID":1,"Shape_Length":849.49530405116059,"Shape_Area":44454.148317470004,"Name":"Ksar Ouled Youssef"}},{"type":"Feature","id":2,"geometry":{"type":"Polygon","coordinates":[[[-4.2478972364161569,31.299850510373091],[-4.2472928130620771,31.29863795569544],[-4.2457948956819989,31.29953614581526],[-4.2463861793784341,31.300473623106587],[-4.2478972364161569,31.299850510373091]]]},"properties":{"OBJECTID":2,"Shape_Length":700.92952747582626,"Shape_Area":30051.159323913478,"Name":"Ksar Sidi elmehdi"}},{"type":"Feature","id":3,"geometry":{"type":"Polygon","coordinates":[[[-4.2485523040910014,31.301141191347419],[-4.248183638193364,31.300455992031903],[-4.2480652339507063,31.300203065191067],[-4.2480652339507063,31.300207663713447],[-4.2469888357463237,31.300695122699462],[-4.2472660082323186,31.301506781433954],[-4.2485523040910014,31.301141191347419]]]},"properties":{"OBJECTID":3,"Shape_Length":531.01095556682412,"Shape_Area":17242.255126954416,"Name":"Groupe scolaire Ouled Youssef"}},{"type":"Feature","id":4,"geometry":{"type":"Polygon","coordinates":[[[-4.250925920769606,31.303061460654128],[-4.2505317319381035,31.302354162834305],[-4.2495922477628048,31.302606769972503],[-4.2501112637912781,31.303330905863305],[-4.250925920769606,31.303061460654128]]]},"properties":{"OBJECTID":4,"Shape_Length":419.5774917771837,"Shape_Area":10832.734624923891,"Name":"Kasbat moulay tahar"}},{"type":"Feature","id":5,"geometry":{"type":"Polygon","coordinates":[[[-4.2701426265302613,31.282244477241449],[-4.2697944260513996,31.280936244426798],[-4.2678366215515293,31.281581941177329],[-4.2686381388722126,31.282811559660118],[-4.2701426265302613,31.282244477241449]]]},"properties":{"OBJECTID":5,"Shape_Length":774.74998270155277,"Shape_Area":36906.60245830744,"Name":"Ksar Abouam"}},{"type":"Feature","id":6,"geometry":{"type":"Polygon","coordinates":[[[-4.2672716180687456,31.281761612083034],[-4.266949696905205,31.280324232949216],[-4.2651627079549135,31.280621816789456],[-4.2654452092471562,31.282328697405447],[-4.2672716180687456,31.281761612083034]]]},"properties":{"OBJECTID":6,"Shape_Length":834.15204983485569,"Shape_Area":43079.523482294971,"Name":"Souq Centrale Rissani"}},{"type":"Feature","id":7,"geometry":{"type":"Polygon","coordinates":[[[-4.2681125543623963,31.28531566471813],[-4.268105984084392,31.283906411643848],[-4.2675738292966043,31.283822192889012],[-4.2670219645731677,31.283889568205975],[-4.2654386398674822,31.283895182429742],[-4.2653466622638385,31.285051782159741],[-4.2652284053449048,31.285383038200333],[-4.266029922665588,31.285512171660809],[-4.2665686477313471,31.285523400682404],[-4.2681125543623963,31.28531566471813]]]},"properties":{"OBJECTID":7,"Shape_Length":1003.0168158890031,"Shape_Area":62354.653986741381,"Name":"Cité militaire"}},{"type":"Feature","id":8,"geometry":{"type":"Polygon","coordinates":[[[-4.2828001943106848,31.27807442254592],[-4.280777924011077,31.278188475869552],[-4.281014026420574,31.280574793240252],[-4.2844221178275204,31.280329145676685],[-4.2828001943106848,31.27807442254592]]]},"properties":{"OBJECTID":8,"Shape_Length":1263.0174399695265,"Shape_Area":93779.271591856188,"Name":"Lycée HassanII"}},{"type":"Feature","id":9,"geometry":{"type":"Polygon","coordinates":[[[-4.2754510365471212,31.278123202421945],[-4.274649519226438,31.276893522809939],[-4.2737888729971383,31.277247268291738],[-4.2739859678620382,31.27867907978754],[-4.2742290510796126,31.278942980179057],[-4.275339349906158,31.278409564107612],[-4.2754510365471212,31.278123202421945]]]},"properties":{"OBJECTID":9,"Shape_Length":702.28143338068219,"Shape_Area":31385.676741982381,"Name":"Lycéé Lalla Salma"}}]
}''';

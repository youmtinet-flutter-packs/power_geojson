import 'dart:convert';

class PowerEsriJsonTransform {
  String _stripJSON(String str) {
    return str.replaceAll('\\n', "\n").replaceAll('\\t', "\t");
  }

  Map<String, dynamic> _jsonToObject(String stringIn) {
    Map<String, dynamic> data = <String, Object?>{};
    try {
      data = json.decode(_stripJSON(stringIn));
    } catch (err) {
      // data = null;
    }
    return data;
  }

// still not sure on how to translate some of these types
  String _parseGeometryType(String type) {
    if (type == "esriGeometryPoint") {
      return "Point";
    } else if (type == "esriGeometryMultipoint") {
      return "MultiPoint";
    } else if (type == "esriGeometryPolyline") {
      return "LineString";
    } else if (type == "esriGeometryPolygon") {
      return "Polygon";
    } else {
      return "Empty";
    }
  }

  Map<String, Object?> _featureToGeo(Map<String, dynamic> featureIn, String geomType) {
    Map<String, dynamic> geometry = <String, Object?>{};
    geometry['type'] = geomType;

    // grab the rings to coordinates
    Map<String, Object?> geom = featureIn['geometry'];

    dynamic coordinates;
    if (geomType == "Polygon") {
      coordinates = geom['rings'];
    } else if (geomType == "LineString") {
      coordinates = geom['paths'];
    } else if (geomType == "Point") {
      coordinates = <Map<String, Object?>>[
        geom['x'] as Map<String, Object?>,
        geom['y'] as Map<String, Object?>,
      ];
    }
    geometry['coordinates'] = coordinates;

    // convert attributes to properties
    Map<String, Object?> properties = <String, Object?>{};
    Map<String, dynamic> attr = featureIn['attributes'] as Map<String, dynamic>;
    for (String field in attr.keys) {
      properties[field] = attr[field];
    }

    Map<String, Object?> featureOut = <String, Object?>{};
    featureOut['type'] = "Feature";
    featureOut['geometry'] = geometry;
    featureOut['properties'] = properties;

    return featureOut;
  }

  Map<String, Object?> deserialize(String js) {
    Map<String, dynamic> o = _jsonToObject(js);
    String geomType = _parseGeometryType(o['geometryType']);

    List<Map<String, Object?>> features = <Map<String, Object?>>[];
    List<Map<String, Object?>> o2 = o['features'] as List<Map<String, Object?>>;
    for (dynamic i = 0,
            feature = <String, Object?>{
      'string': '',
      'int': 0,
      'object': <String, Object?>{},
      'null': null,
    };
        i < o2.length;
        i++) {
      // prepare the main parts of the GeoJSON
      feature = o2[i];
      Map<String, Object?> feat = _featureToGeo(feature, geomType);
      features.add(feat);
    }

    Map<String, Object?> featColl = <String, Object?>{};
    featColl['type'] = "FeatureCollection";
    featColl['features'] = features;

    return featColl;
  }
}

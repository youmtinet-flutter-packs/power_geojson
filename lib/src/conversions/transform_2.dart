class PowerEsriJsonTransformer {
  ///This script will convert an EsriJSON
  ///dictionary to a GeoJSON dictionary
  ///
  ///send a GeoJSON feature:
  ///feature = json.loads(esri_input)
  ///result = esri_to_geo(feature)
  ///optional: response = json.dumps(result)
  ///
  ///Still in the works:
  ///- parse all geometry types

  Map<String, Object?> esriToGeo(Map<String, Object?> esrijson) {
    Map<String, Object?> geojson = <String, Object?>{};
    List<Map<String, Object?>> features = esrijson["features"] as List<Map<String, Object?>>;
    String esriGeomType = '${esrijson["geometryType"]}';
    geojson["type"] = "FeatureCollection";

    List<Map<String, Object?>> feats = <Map<String, Object?>>[];
    for (Map<String, Object?> feat in features) {
      feats.add(_extract(feat, esriGeomType));
    }

    geojson["features"] = feats;

    return geojson;
  }

  Map<String, Object?> _extract(Map<String, Object?> feature, String esriGeomType) {
    String geomType = _getGeomType(esriGeomType);

    return <String, Object?>{
      "type": "Feature",
      "geometry": <String, Object?>{
        "type": geomType,
        "coordinates": _getCoordinates(feature["geometry"] as Map<String, Object?>, geomType),
      },
      "properties": feature["attributes"],
    };
  }

  String _getGeomType(String esriType) {
    if (esriType == "esriGeometryPoint") {
      return "Point";
    } else if (esriType == "esriGeometryMultipoint") {
      return "MultiPoint";
    } else if (esriType == "esriGeometryPolyline") {
      return "LineString";
    } else if (esriType == "esriGeometryPolygon") {
      return "Polygon";
    } else {
      return "unknown";
    }
  }

  Object? _getCoordinates(Map<String, Object?> geom, String geomType) {
    if (geomType == "Polygon") {
      return geom["rings"];
    } else if (geomType == "LineString") {
      return geom["paths"];
    } else if (geomType == "Point") {
      return <Map<String, Object?>>[
        geom["x"] as Map<String, Object?>,
        geom["y"] as Map<String, Object?>,
      ];
    } else if (geomType == "MultiPoint") {
      return geom["points"];
    } else {
      return <Map<String, Object?>>[];
    }
  }
}

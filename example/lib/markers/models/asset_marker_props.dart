import "package:power_geojson/power_geojson.dart";

class AssetMarkerProperties {
  final int oid;

  final String name;
  AssetMarkerProperties({
    required this.oid,
    required this.name,
  });

  Map<String, Object?> toJson() {
    return {
      AssetMarkerPropertiesEnum.OBJECTID.name: oid,
      AssetMarkerPropertiesEnum.Name.name: name,
    };
  }

  factory AssetMarkerProperties.fromJson(Map<String, Object?> json) {
    return AssetMarkerProperties(
      oid: int.parse('${json[AssetMarkerPropertiesEnum.OBJECTID.name]}'),
      name: json[AssetMarkerPropertiesEnum.Name.name] as String,
    );
  }

  factory AssetMarkerProperties.fromMap(Map<String, Object?> json,
      {String? id}) {
    return AssetMarkerProperties(
      oid: json[AssetMarkerPropertiesEnum.OBJECTID.name] as int,
      name: json[AssetMarkerPropertiesEnum.Name.name] as String,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'AssetMarkerProperties(OBJECTID:$oid, Name:$name)';
  }

  @override
  bool operator ==(Object other) {
    return other is AssetMarkerProperties &&
        other.runtimeType == runtimeType &&
        other.oid == oid && //
        other.name == name;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      oid,
      name,
    );
  }
}

enum AssetMarkerPropertiesEnum {
  OBJECTID,
  Name,
  none,
}

extension AssetMarkerPropertiesSort on List<AssetMarkerProperties> {
  List<AssetMarkerProperties> sorty(String caseField, {bool desc = false}) {
    return this
      ..sort((a, b) {
        int fact = (desc ? -1 : 1);

        if (caseField == AssetMarkerPropertiesEnum.OBJECTID.name) {
          // unsortable

          int akey = a.oid;
          int bkey = b.oid;

          return fact * (bkey - akey);
        }

        if (caseField == AssetMarkerPropertiesEnum.Name.name) {
          // unsortable

          String akey = a.name;
          String bkey = b.name;

          return fact * (bkey.compareTo(akey));
        }

        return 0;
      });
  }
}

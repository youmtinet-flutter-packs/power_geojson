import "package:power_geojson/power_geojson.dart";

/*    
{
    "attachmentInfos": [
        {
            "id": 3,
            "globalId": "50e8467f-402b-4cfa-82f3-44e0a1abc03d",
            "parentGlobalId": "399d8903-1f88-4b5e-a3cb-f13d4bad4f6a",
            "name": "berkane-logo.jpg",
            "contentType": "image/jpeg",
            "size": 57022,
            "keywords": "",
            "exifInfo": null
        },
        {
            "id": 4,
            "globalId": "846693a9-8998-45f3-bc1a-5cc9cf6c39b1",
            "parentGlobalId": "399d8903-1f88-4b5e-a3cb-f13d4bad4f6a",
            "name": "آجي نطلقوها تسرح على الأفلام المغربية _ غسيل الدماغ 8-39 screenshot.png",
            "contentType": "image/png",
            "size": 733564,
            "keywords": "",
            "exifInfo": null
        }
    ]
}
*/

class AttachmentsInfos {
  final List<AttachmentInfos> attachmentInfos;
  AttachmentsInfos({
    required this.attachmentInfos,
  });

  AttachmentsInfos copyWith({
    List<AttachmentInfos>? attachmentInfos,
  }) {
    return AttachmentsInfos(
      attachmentInfos: attachmentInfos ?? this.attachmentInfos,
    );
  }

  Map<String, Object?> toJson() {
    return {
      AttachmentsInfosEnum.attachmentInfos.name: attachmentInfos
          .map<Map<String, dynamic>>((data) => data.toJson())
          .toList(),
    };
  }

  factory AttachmentsInfos.fromJson(Map<String, Object?> json) {
    return AttachmentsInfos(
      attachmentInfos: (json[AttachmentsInfosEnum.attachmentInfos.name] as List)
          .map<AttachmentInfos>(
              (data) => AttachmentInfos.fromJson(data as Map<String, Object?>))
          .toList(),
    );
  }

  factory AttachmentsInfos.fromMap(Map<String, Object?> json, {String? id}) {
    return AttachmentsInfos(
      attachmentInfos: json[AttachmentsInfosEnum.attachmentInfos.name]
          as List<AttachmentInfos>,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'AttachmentsInfos(attachmentInfos:${attachmentInfos.toString()})';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentsInfos &&
        other.runtimeType == runtimeType &&
        other.attachmentInfos == attachmentInfos;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      attachmentInfos,
    );
  }
}

enum AttachmentsInfosEnum {
  attachmentInfos,
  none,
}

class AttachmentInfos {
  final int id;

  final String globalId;

  final String parentGlobalId;

  final String name;

  final String contentType;

  final int size;

  final String keywords;

  final dynamic exifInfo;
  AttachmentInfos({
    required this.id,
    required this.globalId,
    required this.parentGlobalId,
    required this.name,
    required this.contentType,
    required this.size,
    required this.keywords,
    required this.exifInfo,
  });

  AttachmentInfos copyWith({
    int? id,
    String? globalId,
    String? parentGlobalId,
    String? name,
    String? contentType,
    int? size,
    String? keywords,
    dynamic exifInfo,
  }) {
    return AttachmentInfos(
      id: id ?? this.id,
      globalId: globalId ?? this.globalId,
      parentGlobalId: parentGlobalId ?? this.parentGlobalId,
      name: name ?? this.name,
      contentType: contentType ?? this.contentType,
      size: size ?? this.size,
      keywords: keywords ?? this.keywords,
      exifInfo: exifInfo ?? this.exifInfo,
    );
  }

  Map<String, Object?> toJson() {
    return {
      AttachmentInfosEnum.id.name: id,
      AttachmentInfosEnum.globalId.name: globalId,
      AttachmentInfosEnum.parentGlobalId.name: parentGlobalId,
      AttachmentInfosEnum.name.name: name,
      AttachmentInfosEnum.contentType.name: contentType,
      AttachmentInfosEnum.size.name: size,
      AttachmentInfosEnum.keywords.name: keywords,
      AttachmentInfosEnum.exifInfo.name: exifInfo,
    };
  }

  factory AttachmentInfos.fromJson(Map<String, Object?> json) {
    return AttachmentInfos(
      id: int.parse('${json[AttachmentInfosEnum.id.name]}'),
      globalId: json[AttachmentInfosEnum.globalId.name] as String,
      parentGlobalId: json[AttachmentInfosEnum.parentGlobalId.name] as String,
      name: json[AttachmentInfosEnum.name.name] as String,
      contentType: json[AttachmentInfosEnum.contentType.name] as String,
      size: int.parse('${json[AttachmentInfosEnum.size.name]}'),
      keywords: json[AttachmentInfosEnum.keywords.name] as String,
      exifInfo: json[AttachmentInfosEnum.exifInfo.name],
    );
  }

  factory AttachmentInfos.fromMap(Map<String, Object?> json, {String? id}) {
    return AttachmentInfos(
      id: json[AttachmentInfosEnum.id.name] as int,
      globalId: json[AttachmentInfosEnum.globalId.name] as String,
      parentGlobalId: json[AttachmentInfosEnum.parentGlobalId.name] as String,
      name: json[AttachmentInfosEnum.name.name] as String,
      contentType: json[AttachmentInfosEnum.contentType.name] as String,
      size: json[AttachmentInfosEnum.size.name] as int,
      keywords: json[AttachmentInfosEnum.keywords.name] as String,
      exifInfo: json[AttachmentInfosEnum.exifInfo.name] as dynamic,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  String stringify() {
    return 'AttachmentInfos(id:$id, globalId:$globalId, parentGlobalId:$parentGlobalId, name:$name, contentType:$contentType, size:$size, keywords:$keywords, exifInfo:$exifInfo)';
  }

  @override
  bool operator ==(Object other) {
    return other is AttachmentInfos &&
        other.runtimeType == runtimeType &&
        other.id == id && //
        other.globalId == globalId && //
        other.parentGlobalId == parentGlobalId && //
        other.name == name && //
        other.contentType == contentType && //
        other.size == size && //
        other.keywords == keywords && //
        other.exifInfo == exifInfo;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      globalId,
      parentGlobalId,
      name,
      contentType,
      size,
      keywords,
      exifInfo,
    );
  }
}

enum AttachmentInfosEnum {
  id,
  globalId,
  parentGlobalId,
  name,
  contentType,
  size,
  keywords,
  exifInfo,
  none,
}

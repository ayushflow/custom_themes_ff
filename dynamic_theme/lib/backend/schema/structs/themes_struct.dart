// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ThemesStruct extends BaseStruct {
  ThemesStruct({
    String? id,
    String? name,
    String? description,
    String? previewImage,
  })  : _id = id,
        _name = name,
        _description = description,
        _previewImage = previewImage;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "previewImage" field.
  String? _previewImage;
  String get previewImage => _previewImage ?? '';
  set previewImage(String? val) => _previewImage = val;

  bool hasPreviewImage() => _previewImage != null;

  static ThemesStruct fromMap(Map<String, dynamic> data) => ThemesStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        previewImage: data['previewImage'] as String?,
      );

  static ThemesStruct? maybeFromMap(dynamic data) =>
      data is Map ? ThemesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'description': _description,
        'previewImage': _previewImage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'previewImage': serializeParam(
          _previewImage,
          ParamType.String,
        ),
      }.withoutNulls;

  static ThemesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ThemesStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        previewImage: deserializeParam(
          data['previewImage'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ThemesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ThemesStruct &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        previewImage == other.previewImage;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, name, description, previewImage]);
}

ThemesStruct createThemesStruct({
  String? id,
  String? name,
  String? description,
  String? previewImage,
}) =>
    ThemesStruct(
      id: id,
      name: name,
      description: description,
      previewImage: previewImage,
    );

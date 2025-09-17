// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ThemeResStruct extends BaseStruct {
  ThemeResStruct({
    bool? success,
    List<ThemesStruct>? themes,
  })  : _success = success,
        _themes = themes;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "themes" field.
  List<ThemesStruct>? _themes;
  List<ThemesStruct> get themes => _themes ?? const [];
  set themes(List<ThemesStruct>? val) => _themes = val;

  void updateThemes(Function(List<ThemesStruct>) updateFn) {
    updateFn(_themes ??= []);
  }

  bool hasThemes() => _themes != null;

  static ThemeResStruct fromMap(Map<String, dynamic> data) => ThemeResStruct(
        success: data['success'] as bool?,
        themes: getStructList(
          data['themes'],
          ThemesStruct.fromMap,
        ),
      );

  static ThemeResStruct? maybeFromMap(dynamic data) =>
      data is Map ? ThemeResStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'themes': _themes?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'themes': serializeParam(
          _themes,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ThemeResStruct fromSerializableMap(Map<String, dynamic> data) =>
      ThemeResStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        themes: deserializeStructParam<ThemesStruct>(
          data['themes'],
          ParamType.DataStruct,
          true,
          structBuilder: ThemesStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ThemeResStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ThemeResStruct &&
        success == other.success &&
        listEquality.equals(themes, other.themes);
  }

  @override
  int get hashCode => const ListEquality().hash([success, themes]);
}

ThemeResStruct createThemeResStruct({
  bool? success,
}) =>
    ThemeResStruct(
      success: success,
    );

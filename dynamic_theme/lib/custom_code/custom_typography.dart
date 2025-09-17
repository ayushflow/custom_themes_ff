import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart' as ff_theme;
import 'typography_font_manager.dart';

class CustomTypography extends ff_theme.Typography {
  final Map<String, dynamic> _typographyData;
  final ff_theme.FlutterFlowTheme _theme;
  final TypographyFontManager _fontManager = TypographyFontManager();

  CustomTypography(this._typographyData, this._theme) {
    // Preload fonts when typography is created
    _preloadFonts();
  }

  /// Preload fonts for this typography configuration
  void _preloadFonts() {
    if (_typographyData['typography'] != null) {
      final typographyList = _typographyData['typography'] as List<dynamic>;
      _fontManager.preloadTypographyFonts(typographyList);
    }
  }

  // Helper function to parse font weight
  FontWeight _parseFontWeight(String? fontWeight) {
    switch (fontWeight?.toLowerCase()) {
      case 'regular':
        return FontWeight.w400;
      case 'medium':
        return FontWeight.w500;
      case 'semibold':
        return FontWeight.w600;
      case 'bold':
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }

  // Helper function to parse letter spacing
  double? _parseLetterSpacing(
      Map<String, dynamic>? letterSpacing, double fontSize) {
    if (letterSpacing == null) return null;

    final unit = letterSpacing['unit'] as String?;
    final value = (letterSpacing['value'] as num?)?.toDouble() ?? 0.0;

    if (unit == 'PERCENT') {
      return fontSize * (value / 100.0);
    } else if (unit == 'PIXELS') {
      return value;
    }
    return null;
  }

  // Helper function to get typography style by name
  Map<String, dynamic>? _getTypographyByName(String name) {
    if (_typographyData['typography'] == null) {
      return null;
    }

    final typographyList = _typographyData['typography'] as List<dynamic>;
    try {
      final result = typographyList.firstWhere(
        (item) => item['name'] == name,
        orElse: () => null,
      ) as Map<String, dynamic>?;

      return result;
    } catch (e) {
      debugPrint('Error finding typography $name: $e');
      return null;
    }
  }

  // Helper function to create TextStyle from typography data
  TextStyle _createTextStyle(Map<String, dynamic> typographyData) {
    final fontFamily = typographyData['fontFamily'] as String? ?? 'Inter';
    final fontWeight =
        _parseFontWeight(typographyData['fontWeight'] as String?);
    final fontSize = (typographyData['fontSize'] as num?)?.toDouble() ?? 14.0;
    final letterSpacing = _parseLetterSpacing(
      typographyData['letterSpacing'] as Map<String, dynamic>?,
      fontSize,
    );

    // Always create fresh text style without caching
    return _createTextStyleWithFontPriority(
      fontFamily,
      fontWeight,
      fontSize,
      letterSpacing,
    );
  }

  // Helper function to create TextStyle with font loading priority
  TextStyle _createTextStyleWithFontPriority(
    String fontFamily,
    FontWeight fontWeight,
    double fontSize,
    double? letterSpacing,
  ) {
    return _fontManager.createTextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      color: _theme.primaryText,
    );
  }

  // Map typography names to Flutter text styles
  @override
  String get displayLargeFamily {
    final data = _getTypographyByName('Display XL');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get displayLargeIsCustom => true;
  @override
  TextStyle get displayLarge {
    final data = _getTypographyByName('Display XL');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.displayLarge;
  }

  @override
  String get displayMediumFamily {
    final data = _getTypographyByName('Display L');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get displayMediumIsCustom => true;
  @override
  TextStyle get displayMedium {
    final data = _getTypographyByName('Display L');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.displayMedium;
  }

  @override
  String get displaySmallFamily {
    final data = _getTypographyByName('Display M');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get displaySmallIsCustom => true;
  @override
  TextStyle get displaySmall {
    final data = _getTypographyByName('Display M');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.displaySmall;
  }

  @override
  String get headlineLargeFamily {
    final data = _getTypographyByName('Heading XXXL');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get headlineLargeIsCustom => true;
  @override
  TextStyle get headlineLarge {
    final data = _getTypographyByName('Heading XXXL');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.headlineLarge;
  }

  @override
  String get headlineMediumFamily {
    final data = _getTypographyByName('Heading XXL');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get headlineMediumIsCustom => true;
  @override
  TextStyle get headlineMedium {
    final data = _getTypographyByName('Heading XXL');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.headlineMedium;
  }

  @override
  String get headlineSmallFamily {
    final data = _getTypographyByName('Heading XL');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get headlineSmallIsCustom => true;
  @override
  TextStyle get headlineSmall {
    final data = _getTypographyByName('Heading XL');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.headlineSmall;
  }

  @override
  String get titleLargeFamily {
    final data = _getTypographyByName('Heading L');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get titleLargeIsCustom => true;
  @override
  TextStyle get titleLarge {
    final data = _getTypographyByName('Heading L');
    return data != null ? _createTextStyle(data) : _theme.typography.titleLarge;
  }

  @override
  String get titleMediumFamily {
    final data = _getTypographyByName('Heading M');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get titleMediumIsCustom => true;
  @override
  TextStyle get titleMedium {
    final data = _getTypographyByName('Heading M');
    return data != null
        ? _createTextStyle(data)
        : _theme.typography.titleMedium;
  }

  @override
  String get titleSmallFamily {
    final data = _getTypographyByName('Heading S-Semi Bold');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get titleSmallIsCustom => true;
  @override
  TextStyle get titleSmall {
    final data = _getTypographyByName('Heading S-Semi Bold');
    return data != null ? _createTextStyle(data) : _theme.typography.titleSmall;
  }

  @override
  String get bodyLargeFamily {
    final data = _getTypographyByName('Body L-Regular');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get bodyLargeIsCustom => true;
  @override
  TextStyle get bodyLarge {
    final data = _getTypographyByName('Body L-Regular');
    return data != null ? _createTextStyle(data) : _theme.typography.bodyLarge;
  }

  @override
  String get bodyMediumFamily {
    final data = _getTypographyByName('Body M-Regular');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get bodyMediumIsCustom => true;
  @override
  TextStyle get bodyMedium {
    final data = _getTypographyByName('Body M-Regular');
    return data != null ? _createTextStyle(data) : _theme.typography.bodyMedium;
  }

  @override
  String get bodySmallFamily {
    final data = _getTypographyByName('Body S-Regular');
    return data?['fontFamily'] as String? ?? 'Inter';
  }

  @override
  bool get bodySmallIsCustom => true;
  @override
  TextStyle get bodySmall {
    final data = _getTypographyByName('Body S-Regular');
    return data != null ? _createTextStyle(data) : _theme.typography.bodySmall;
  }

  // Label styles - using body styles as fallback
  @override
  String get labelLargeFamily => bodyLargeFamily;
  @override
  bool get labelLargeIsCustom => bodyLargeIsCustom;
  @override
  TextStyle get labelLarge => bodyLarge.copyWith(color: _theme.secondaryText);

  @override
  String get labelMediumFamily => bodyMediumFamily;
  @override
  bool get labelMediumIsCustom => bodyMediumIsCustom;
  @override
  TextStyle get labelMedium => bodyMedium.copyWith(color: _theme.secondaryText);

  @override
  String get labelSmallFamily => bodySmallFamily;
  @override
  bool get labelSmallIsCustom => bodySmallIsCustom;
  @override
  TextStyle get labelSmall => bodySmall.copyWith(color: _theme.secondaryText);
}

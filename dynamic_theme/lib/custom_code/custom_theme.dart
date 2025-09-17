import 'dart:convert';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart'
    as ff_theme; // Import with alias to avoid conflicts
import 'custom_typography.dart';

class CustomTheme extends ff_theme.FlutterFlowTheme {
  late final ff_theme.FlutterFlowTheme _baseTheme;
  late final Map<String, dynamic> _themeData;
  ff_theme.Typography? _cachedTypography;

  CustomTheme({
    required Map<String, dynamic> themeData,
    ff_theme.FlutterFlowTheme? baseTheme,
  }) {
    // Use provided base theme or default to light theme
    _baseTheme = baseTheme ?? ff_theme.LightModeTheme();
    _themeData = themeData;
    _populateFromJson(themeData);
    // Clear any cached typography to ensure fresh font loading
    _cachedTypography = null;
  }

  /// Clear cached typography when theme changes
  void clearTypographyCache() {
    _cachedTypography = null;
  }

  // Factory constructor to create from JSON string
  factory CustomTheme.fromJson(String jsonString,
      {ff_theme.FlutterFlowTheme? baseTheme}) {
    final Map<String, dynamic> themeData = json.decode(jsonString);
    return CustomTheme(themeData: themeData, baseTheme: baseTheme);
  }

  void _populateFromJson(Map<String, dynamic> data) {
    // Helper function to parse color from hex string or int
    Color parseColor(dynamic colorValue, Color fallback) {
      if (colorValue == null) return fallback;

      try {
        if (colorValue is String) {
          // Handle hex colors like "#ff1e88e5" (ARGB format)
          String hexColor = colorValue.replaceAll('#', '');

          // If it's already 8 characters (ARGB), use as is
          if (hexColor.length == 8) {
            return Color(int.parse(hexColor, radix: 16));
          }
          // If it's 6 characters (RGB), add full alpha (FF)
          else if (hexColor.length == 6) {
            hexColor = 'FF$hexColor';
            return Color(int.parse(hexColor, radix: 16));
          }
          // If it's 3 characters, expand and add alpha
          else if (hexColor.length == 3) {
            hexColor = hexColor.split('').map((char) => char + char).join('');
            hexColor = 'FF$hexColor';
            return Color(int.parse(hexColor, radix: 16));
          }
        } else if (colorValue is int) {
          return Color(colorValue);
        }
      } catch (e) {
        // Silently fall back to default color on parsing error
        // You can add proper logging here if needed
      }
      return fallback;
    }

    // Copy base theme colors first, then override with JSON values
    primary = parseColor(data['primary'], _baseTheme.primary);
    secondary = parseColor(data['secondary'], _baseTheme.secondary);
    tertiary = parseColor(data['tertiary'], _baseTheme.tertiary);
    alternate = parseColor(data['alternate'], _baseTheme.alternate);
    primaryText = parseColor(data['primaryText'], _baseTheme.primaryText);
    secondaryText = parseColor(data['secondaryText'], _baseTheme.secondaryText);
    primaryBackground =
        parseColor(data['primaryBackground'], _baseTheme.primaryBackground);
    secondaryBackground =
        parseColor(data['secondaryBackground'], _baseTheme.secondaryBackground);
    accent1 = parseColor(data['accent1'], _baseTheme.accent1);
    accent2 = parseColor(data['accent2'], _baseTheme.accent2);
    accent3 = parseColor(data['accent3'], _baseTheme.accent3);
    accent4 = parseColor(data['accent4'], _baseTheme.accent4);
    success = parseColor(data['success'], _baseTheme.success);
    warning = parseColor(data['warning'], _baseTheme.warning);
    error = parseColor(data['error'], _baseTheme.error);
    info = parseColor(data['info'], _baseTheme.info);

    // Custom brand colors
    richBlackFOGRA39 =
        parseColor(data['richBlackFOGRA39'], _baseTheme.richBlackFOGRA39);
    blue = parseColor(data['blue'], _baseTheme.blue);
    turquoise = parseColor(data['turquoise'], _baseTheme.turquoise);
    cultured = parseColor(data['cultured'], _baseTheme.cultured);
  }

  // Use custom typography if available, otherwise fall back to base theme
  @override
  ff_theme.Typography get typography {
    if (_themeData.containsKey('typography') &&
        _themeData['typography'] != null) {
      // Always create fresh typography instance to ensure font changes are applied
      _cachedTypography = CustomTypography(_themeData, this);
      return _cachedTypography!;
    }
    return _baseTheme.typography;
  }

  // Method to convert current custom colors to JSON
  Map<String, String> toJson() {
    return {
      'primary':
          '#${primary.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'secondary':
          '#${secondary.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'tertiary':
          '#${tertiary.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'alternate':
          '#${alternate.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'primaryText':
          '#${primaryText.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'secondaryText':
          '#${secondaryText.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'primaryBackground':
          '#${primaryBackground.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'secondaryBackground':
          '#${secondaryBackground.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'accent1':
          '#${accent1.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'accent2':
          '#${accent2.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'accent3':
          '#${accent3.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'accent4':
          '#${accent4.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'success':
          '#${success.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'warning':
          '#${warning.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'error':
          '#${error.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'info':
          '#${info.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'richBlackFOGRA39':
          '#${richBlackFOGRA39.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'blue':
          '#${blue.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'turquoise':
          '#${turquoise.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'cultured':
          '#${cultured.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    };
  }

  // Helper method to create from base theme (light/dark)
  static CustomTheme fromBaseTheme({
    required ff_theme.FlutterFlowTheme baseTheme,
    Map<String, dynamic>? colorOverrides,
  }) {
    final themeData = colorOverrides ?? <String, dynamic>{};
    return CustomTheme(themeData: themeData, baseTheme: baseTheme);
  }
}

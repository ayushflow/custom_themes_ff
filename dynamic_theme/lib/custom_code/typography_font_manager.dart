import 'package:flutter/material.dart';
import 'font_loader_service.dart';

class TypographyFontManager {
  static final TypographyFontManager _instance =
      TypographyFontManager._internal();
  factory TypographyFontManager() => _instance;
  TypographyFontManager._internal();

  final FontLoaderService _fontLoader = FontLoaderService();
  final Map<String, bool> _loadedFonts = {};

  /// Preload fonts for a typography configuration
  Future<void> preloadTypographyFonts(List<dynamic> typographyData) async {
    final Set<String> fontKeys = {};

    // Extract unique font combinations
    for (final typography in typographyData) {
      final fontFamily = typography['fontFamily'] as String? ?? 'Inter';
      final fontWeight = typography['fontWeight'] as String? ?? 'Regular';
      final fontKey = '${fontFamily}_$fontWeight';
      fontKeys.add(fontKey);
    }

    // Load and register fonts in parallel
    final List<Future<void>> loadTasks = fontKeys.map((fontKey) async {
      if (!_loadedFonts.containsKey(fontKey)) {
        final parts = fontKey.split('_');
        final fontFamily = parts[0];
        final fontWeight = parts[1];

        try {
          // Register the font with Flutter's font system
          final success =
              await _fontLoader.registerFont(fontFamily, fontWeight);
          _loadedFonts[fontKey] = success;
          if (!success) {
            debugPrint('Failed to register font: $fontKey');
          }
        } catch (e) {
          debugPrint('Error registering font $fontKey: $e');
          _loadedFonts[fontKey] = false;
        }
      }
    }).toList();

    await Future.wait(loadTasks);
  }

  /// Create TextStyle with font loading priority
  TextStyle createTextStyle({
    required String fontFamily,
    required FontWeight fontWeight,
    required double fontSize,
    double? letterSpacing,
    required Color color,
  }) {
    // Always use the requested font family - let Flutter handle the fallback
    // The font loading system should ensure fonts are available
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  /// Check if a font is loaded
  bool isFontLoaded(String fontFamily, String fontWeight) {
    final fontKey = '${fontFamily}_$fontWeight';
    return _loadedFonts[fontKey] == true;
  }

  /// Clear loaded fonts cache
  void clearCache() {
    _loadedFonts.clear();
    _fontLoader.clearCache();
  }

  /// Helper function to convert FontWeight to string
  String _getFontWeightString(FontWeight fontWeight) {
    switch (fontWeight) {
      case FontWeight.w400:
        return 'Regular';
      case FontWeight.w500:
        return 'Medium';
      case FontWeight.w600:
        return 'SemiBold';
      case FontWeight.w700:
        return 'Bold';
      default:
        return 'Regular';
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'custom_theme.dart';
import 'typography_font_manager.dart';

class ThemeService {
  // Configuration for different environments
  static const String _devBaseUrl = 'http://localhost:3000';
  // static const String _prodBaseUrl =
  //     'https://your-production-domain.com'; // Change for production

  // Theme persistence keys
  static const String kUseCustomThemeKey = '__use_custom_theme__';
  static const String kCustomThemeDataKey = '__custom_theme_data__';

  static SharedPreferences? _prefs;
  static CustomTheme? _currentCustomTheme;

  // ValueNotifier to trigger app rebuilds when theme changes
  static final ValueNotifier<int> themeChangeNotifier = ValueNotifier<int>(0);
  static String? _currentThemeId;

  static String get baseUrl {
    // You can add logic here to determine environment
    // For now, using dev URL - change this for production
    return _devBaseUrl;
  }

  // Initialize the theme service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedCustomTheme();
  }

  // Custom theme management
  static Future<void> setCustomTheme(Map<String, dynamic> themeData,
      {bool isDark = false}) async {
    try {
      final baseTheme = isDark ? DarkModeTheme() : LightModeTheme();
      _currentCustomTheme =
          CustomTheme(themeData: themeData, baseTheme: baseTheme);
      // Clear typography cache to ensure fresh font loading
      _currentCustomTheme?.clearTypographyCache();
      await _prefs?.setBool(kUseCustomThemeKey, true);
      await _prefs?.setString(kCustomThemeDataKey, json.encode(themeData));
      // Trigger app rebuild
      themeChangeNotifier.value = themeChangeNotifier.value + 1;
    } catch (e) {
      debugPrint('Error setting custom theme: $e');
    }
  }

  static Future<void> clearCustomTheme() async {
    _currentCustomTheme = null;
    await _prefs?.setBool(kUseCustomThemeKey, false);
    await _prefs?.remove(kCustomThemeDataKey);
    // Trigger app rebuild
    themeChangeNotifier.value = themeChangeNotifier.value + 1;
  }

  // Method to notify theme changes (for external use)
  static void notifyThemeChange({String? themeId}) {
    _currentThemeId = themeId;
    themeChangeNotifier.value = themeChangeNotifier.value + 1;
  }

  // Get current theme ID
  static String? get currentThemeId => _currentThemeId;

  // Check if a specific theme is active
  static bool isThemeActive(String themeId) {
    return _currentThemeId == themeId;
  }

  static Future<void> _loadSavedCustomTheme() async {
    final useCustomTheme = _prefs?.getBool(kUseCustomThemeKey) ?? false;
    if (useCustomTheme) {
      final savedThemeData = _prefs?.getString(kCustomThemeDataKey);
      if (savedThemeData != null) {
        try {
          final themeData = json.decode(savedThemeData) as Map<String, dynamic>;
          _currentCustomTheme =
              CustomTheme(themeData: themeData, baseTheme: LightModeTheme());
        } catch (e) {
          debugPrint('Error loading saved custom theme: $e');
          await clearCustomTheme();
        }
      }
    }
  }

  // Get the current theme (custom or system)
  static FlutterFlowTheme getCurrentTheme(BuildContext context) {
    final useCustomTheme = _prefs?.getBool(kUseCustomThemeKey) ?? false;
    if (useCustomTheme && _currentCustomTheme != null) {
      return _currentCustomTheme!;
    }

    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  // Check if custom theme is active
  static bool get isCustomThemeActive {
    return _prefs?.getBool(kUseCustomThemeKey) ?? false;
  }

  // Get current custom theme
  static CustomTheme? get currentCustomTheme => _currentCustomTheme;

  // Fetch available themes from the server
  static Future<List<ThemePreset>> getAvailableThemes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/themes'));

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          return [];
        }

        final decodedData = json.decode(response.body);

        // Check if decoded data is null or not a map
        if (decodedData == null || decodedData is! Map<String, dynamic>) {
          return [];
        }

        final data = decodedData;

        // Check if the response has the expected structure
        if (data['success'] != true) {
          return [];
        }

        final themes = data['themes'];

        // Check if themes key exists and is a list
        if (themes == null || themes is! List) {
          return [];
        }

        return themes
            .map((theme) {
              try {
                if (theme is Map<String, dynamic>) {
                  return ThemePreset.fromJson(theme);
                } else {
                  return null;
                }
              } catch (e) {
                return null;
              }
            })
            .where((theme) => theme != null)
            .cast<ThemePreset>()
            .toList();
      } else {
        throw Exception('Failed to load themes: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching themes: $e');
      return [];
    }
  }

  // Apply a theme by ID
  static Future<bool> applyTheme(String themeId, {bool isDark = false}) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/themes/$themeId'));

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          return false;
        }

        final decodedData = json.decode(response.body);

        // Check if decoded data is null or not a map
        if (decodedData == null || decodedData is! Map<String, dynamic>) {
          return false;
        }

        final themeData = decodedData;

        // Check if the response has the expected structure
        if (themeData['success'] != true) {
          return false;
        }

        final colors = themeData['colors'];
        final typography = themeData['typography'];

        // Check if colors key exists and is a map
        if (colors == null || colors is! Map<String, dynamic>) {
          return false;
        }

        // Create full theme data including typography
        final fullThemeData = <String, dynamic>{
          ...colors,
          if (typography != null) 'typography': typography,
        };

        // Clear font cache and preload fonts if typography data is available
        if (typography != null && typography is List) {
          try {
            final fontManager = TypographyFontManager();
            // Clear existing font cache to ensure fresh loading
            fontManager.clearCache();
            await fontManager.preloadTypographyFonts(typography);
          } catch (e) {
            debugPrint('Failed to preload fonts: $e');
            // Continue with theme application even if font loading fails
          }
        }

        await setCustomTheme(fullThemeData, isDark: isDark);
        return true;
      } else {
        throw Exception('Failed to load theme: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error applying theme: $e');
      return false;
    }
  }

  // Reset to system theme
  static Future<void> resetToSystemTheme() async {
    await clearCustomTheme();
  }

  // Save custom theme to server (optional)
  static Future<String?> saveCustomTheme({
    required String name,
    required Map<String, dynamic> colors,
    String? description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/themes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description ?? '',
          'colors': colors,
        }),
      );

      if (response.statusCode == 201) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          print('Warning: Empty response body from save theme API');
          return null;
        }

        final decodedData = json.decode(response.body);

        // Check if decoded data is null or not a map
        if (decodedData == null) {
          print('Warning: Null response from save theme API');
          return null;
        }

        if (decodedData is! Map<String, dynamic>) {
          print(
              'Warning: Invalid response format from save theme API. Expected Map, got ${decodedData.runtimeType}');
          return null;
        }

        final data = decodedData;
        final id = data['id'];

        // Check if id key exists and is a string
        if (id == null || id is! String) {
          return null;
        }

        return id;
      } else {
        throw Exception('Failed to save theme: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error saving theme: $e');
      return null;
    }
  }
}

// Theme preset model
class ThemePreset {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> colors;
  final String previewImage;

  ThemePreset({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    required this.previewImage,
  });

  factory ThemePreset.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json['id'] == null || json['name'] == null) {
        throw FormatException('Missing required fields: id or name');
      }

      // For the /api/themes endpoint, colors might not be included
      // We'll create a default colors map if it's missing
      Map<String, dynamic> colors;
      if (json['colors'] != null && json['colors'] is Map<String, dynamic>) {
        colors = json['colors'] as Map<String, dynamic>;
      } else {
        // Create a default colors map for theme previews
        colors = {
          'primary': '#4B39EF',
          'secondary': '#39D2C0',
          'tertiary': '#EE8B60',
        };
      }

      return ThemePreset(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        colors: colors,
        previewImage: json['previewImage'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('Error parsing ThemePreset from JSON: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colors': colors,
      'previewImage': previewImage,
    };
  }
}

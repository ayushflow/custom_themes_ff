import 'dart:convert';
import 'package:http/http.dart' as http;
import 'flutter_flow_theme.dart';

class ThemeService {
  // Configuration for different environments
  static const String _devBaseUrl = 'http://localhost:3000';
  static const String _prodBaseUrl =
      'https://your-production-domain.com'; // Change for production

  static String get baseUrl {
    // You can add logic here to determine environment
    // For now, using dev URL - change this for production
    return _devBaseUrl;
  }

  // Fetch available themes from the server
  static Future<List<ThemePreset>> getAvailableThemes() async {
    try {
      print('Fetching themes from: $baseUrl/api/themes');
      final response = await http.get(Uri.parse('$baseUrl/api/themes'));
      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');
      print(
          'Response body preview: ${response.body.isNotEmpty ? response.body.substring(0, response.body.length > 100 ? 100 : response.body.length) : "EMPTY"}');

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          print('Warning: Empty response body from themes API');
          return [];
        }

        final decodedData = json.decode(response.body);

        // Check if decoded data is null or not a map
        if (decodedData == null) {
          print('Warning: Null response from themes API');
          return [];
        }

        if (decodedData is! Map<String, dynamic>) {
          print(
              'Warning: Invalid response format from themes API. Expected Map, got ${decodedData.runtimeType}');
          return [];
        }

        final data = decodedData;

        // Check if the response has the expected structure
        if (data['success'] != true) {
          print('Warning: API response indicates failure: ${data['success']}');
          return [];
        }

        final themes = data['themes'];

        // Check if themes key exists and is a list
        if (themes == null || themes is! List) {
          print('Warning: No themes found or invalid themes format');
          print('Available keys in response: ${data.keys.toList()}');
          return [];
        }

        return themes
            .map((theme) {
              try {
                if (theme is Map<String, dynamic>) {
                  return ThemePreset.fromJson(theme);
                } else {
                  print('Warning: Invalid theme format: ${theme.runtimeType}');
                  return null;
                }
              } catch (e) {
                print('Warning: Error parsing theme: $e');
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
      print('Error fetching themes: $e');
      return [];
    }
  }

  // Apply a theme by ID
  static Future<bool> applyTheme(String themeId, {bool isDark = false}) async {
    try {
      print('Applying theme with ID: $themeId');
      final response =
          await http.get(Uri.parse('$baseUrl/api/themes/$themeId'));
      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');
      print(
          'Response body preview: ${response.body.isNotEmpty ? response.body.substring(0, response.body.length > 100 ? 100 : response.body.length) : "EMPTY"}');

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isEmpty) {
          print('Warning: Empty response body from theme API');
          return false;
        }

        final decodedData = json.decode(response.body);

        // Check if decoded data is null or not a map
        if (decodedData == null) {
          print('Warning: Null response from theme API');
          return false;
        }

        if (decodedData is! Map<String, dynamic>) {
          print(
              'Warning: Invalid response format from theme API. Expected Map, got ${decodedData.runtimeType}');
          return false;
        }

        final themeData = decodedData;

        // Check if the response has the expected structure
        if (themeData['success'] != true) {
          print(
              'Warning: API response indicates failure: ${themeData['success']}');
          return false;
        }

        final colors = themeData['colors'];

        // Check if colors key exists and is a map
        if (colors == null || colors is! Map<String, dynamic>) {
          print('Warning: No colors found or invalid colors format');
          print('Available keys in response: ${themeData.keys.toList()}');
          return false;
        }

        await FlutterFlowTheme.setCustomTheme(colors, isDark: isDark);
        return true;
      } else {
        throw Exception('Failed to load theme: ${response.statusCode}');
      }
    } catch (e) {
      print('Error applying theme: $e');
      return false;
    }
  }

  // Reset to system theme
  static Future<void> resetToSystemTheme() async {
    await FlutterFlowTheme.clearCustomTheme();
  }

  // Debug method to test API endpoint
  static Future<void> debugApiEndpoint() async {
    try {
      print('=== DEBUG: Testing API Endpoint ===');
      print('Base URL: $baseUrl');

      final response = await http.get(Uri.parse('$baseUrl/api/themes'));
      print('Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body Length: ${response.body.length}');

      if (response.body.isNotEmpty) {
        print(
            'Response Body Preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');

        try {
          final decoded = json.decode(response.body);
          print('Decoded Type: ${decoded.runtimeType}');
          if (decoded is Map<String, dynamic>) {
            print('Decoded Keys: ${decoded.keys.toList()}');
            if (decoded['themes'] != null) {
              print(
                  'Themes array length: ${(decoded['themes'] as List).length}');
              if ((decoded['themes'] as List).isNotEmpty) {
                final firstTheme = (decoded['themes'] as List).first;
                print(
                    'First theme keys: ${firstTheme is Map ? (firstTheme as Map).keys.toList() : 'Not a map'}');
              }
            }
          }
        } catch (e) {
          print('JSON Decode Error: $e');
        }
      } else {
        print('Response Body: EMPTY');
      }

      // Also test a specific theme endpoint
      print('\n=== Testing Specific Theme Endpoint ===');
      final themeResponse =
          await http.get(Uri.parse('$baseUrl/api/themes/ocean-breeze'));
      print('Theme Response Status: ${themeResponse.statusCode}');
      if (themeResponse.body.isNotEmpty) {
        try {
          final themeDecoded = json.decode(themeResponse.body);
          print('Theme Decoded Type: ${themeDecoded.runtimeType}');
          if (themeDecoded is Map<String, dynamic>) {
            print('Theme Decoded Keys: ${themeDecoded.keys.toList()}');
          }
        } catch (e) {
          print('Theme JSON Decode Error: $e');
        }
      }

      print('=== END DEBUG ===');
    } catch (e) {
      print('Debug API Error: $e');
    }
  }

  // Simple test method to check if API is working
  static Future<bool> testApiConnection() async {
    try {
      print('Testing API connection...');
      final response = await http.get(Uri.parse('$baseUrl/health'));
      if (response.statusCode == 200) {
        print('✅ API is accessible and responding');
        return true;
      } else {
        print('❌ API responded with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ API connection failed: $e');
      return false;
    }
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
          print('Warning: No id found or invalid id format');
          return null;
        }

        return id;
      } else {
        throw Exception('Failed to save theme: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving theme: $e');
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
      print('Error parsing ThemePreset from JSON: $e');
      print('JSON data: $json');
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

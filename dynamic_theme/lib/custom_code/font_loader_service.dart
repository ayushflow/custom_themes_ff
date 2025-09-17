import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FontLoaderService {
  static final FontLoaderService _instance = FontLoaderService._internal();
  factory FontLoaderService() => _instance;
  FontLoaderService._internal();

  // Cache for loaded fonts
  final Map<String, ByteData> _fontCache = {};
  final Map<String, String> _fontFileCache = {};

  // Base URL for font API
  static const String _fontApiBaseUrl = 'http://localhost:3000/api/fonts';

  /// Load a font with the given family and weight
  /// First tries to load from assets, then from API
  Future<ByteData?> loadFont(String fontFamily, String fontWeight) async {
    final cacheKey = '${fontFamily}_$fontWeight';

    // Check cache first
    if (_fontCache.containsKey(cacheKey)) {
      return _fontCache[cacheKey];
    }

    ByteData? fontData;

    // Try to load from assets first
    fontData = await _loadFromAssets(fontFamily, fontWeight);

    // If not found in assets, try to load from API
    fontData ??= await _loadFromApi(fontFamily, fontWeight);

    // Cache the result
    if (fontData != null) {
      _fontCache[cacheKey] = fontData;
    }

    return fontData;
  }

  /// Register a font with Flutter's font system
  Future<bool> registerFont(String fontFamily, String fontWeight) async {
    try {
      final fontData = await loadFont(fontFamily, fontWeight);
      if (fontData != null) {
        final fontLoader = FontLoader(fontFamily);
        fontLoader.addFont(Future.value(fontData));
        await fontLoader.load();
        return true;
      } else {
        debugPrint('Failed to load font data for: $fontFamily $fontWeight');
        return false;
      }
    } catch (e) {
      debugPrint('Error registering font $fontFamily $fontWeight: $e');
      return false;
    }
  }

  /// Load font from assets
  Future<ByteData?> _loadFromAssets(
      String fontFamily, String fontWeight) async {
    try {
      final assetPath = _getAssetPath(fontFamily, fontWeight);
      return await rootBundle.load(assetPath);
    } catch (e) {
      return null;
    }
  }

  /// Load font from API
  Future<ByteData?> _loadFromApi(String fontFamily, String fontWeight) async {
    try {
      final url = '$_fontApiBaseUrl/$fontFamily/$fontWeight';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ByteData.view(response.bodyBytes.buffer);
      } else {
        debugPrint('Font API returned status: ${response.statusCode} for $url');
        return null;
      }
    } catch (e) {
      debugPrint('Error loading font from API: $e');
      return null;
    }
  }

  /// Get the asset path for a font
  String _getAssetPath(String fontFamily, String fontWeight) {
    final fileName = _getFontFileName(fontFamily, fontWeight);
    return 'assets/fonts/$fileName';
  }

  /// Get the font file name based on family and weight
  String _getFontFileName(String fontFamily, String fontWeight) {
    // Convert font family to proper case (e.g., "OpenSans" stays "OpenSans")
    final formattedFamily = fontFamily;

    switch (fontWeight.toLowerCase()) {
      case 'regular':
        return '${formattedFamily}-Regular.ttf';
      case 'medium':
        return '${formattedFamily}-Medium.ttf';
      case 'semibold':
        return '${formattedFamily}-SemiBold.ttf';
      case 'bold':
        return '${formattedFamily}-Bold.ttf';
      default:
        return '${formattedFamily}-Regular.ttf';
    }
  }

  /// Download and cache font file for web
  Future<String?> downloadFontForWeb(
      String fontFamily, String fontWeight) async {
    if (!kIsWeb) return null;

    final cacheKey = '${fontFamily}_$fontWeight';

    // Check if already cached
    if (_fontFileCache.containsKey(cacheKey)) {
      return _fontFileCache[cacheKey];
    }

    try {
      final url = '$_fontApiBaseUrl/$fontFamily/$fontWeight';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // For web, we'll return the URL directly
        // In a real implementation, you might want to store the font data
        // and create a blob URL or use a different approach
        _fontFileCache[cacheKey] = url;
        return url;
      }
    } catch (e) {
      debugPrint('Error downloading font for web: $e');
    }

    return null;
  }

  /// Download and save font file for mobile
  Future<String?> downloadFontForMobile(
      String fontFamily, String fontWeight) async {
    if (kIsWeb) return null;

    final cacheKey = '${fontFamily}_$fontWeight';

    // Check if already cached
    if (_fontFileCache.containsKey(cacheKey)) {
      return _fontFileCache[cacheKey];
    }

    try {
      final url = '$_fontApiBaseUrl/$fontFamily/$fontWeight';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get the documents directory
        final directory = await getApplicationDocumentsDirectory();
        final fileName = _getFontFileName(fontFamily, fontWeight);
        final filePath = path.join(directory.path, 'fonts', fileName);

        // Create fonts directory if it doesn't exist
        final fontsDir = Directory(path.dirname(filePath));
        if (!await fontsDir.exists()) {
          await fontsDir.create(recursive: true);
        }

        // Save the font file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        _fontFileCache[cacheKey] = filePath;
        return filePath;
      }
    } catch (e) {
      debugPrint('Error downloading font for mobile: $e');
    }

    return null;
  }

  /// Clear font cache
  void clearCache() {
    _fontCache.clear();
    _fontFileCache.clear();
  }

  /// Preload commonly used fonts
  Future<void> preloadCommonFonts() async {
    final commonFonts = [
      {'family': 'Inter', 'weight': 'Regular'},
      {'family': 'Inter', 'weight': 'Medium'},
      {'family': 'Inter', 'weight': 'Semi Bold'},
      {'family': 'Inter', 'weight': 'Bold'},
    ];

    for (final font in commonFonts) {
      await loadFont(font['family']!, font['weight']!);
    }
  }
}

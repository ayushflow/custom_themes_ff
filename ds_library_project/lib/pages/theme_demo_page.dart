import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:ff_theme/flutter_flow/theme_service.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';

class ThemeDemoPage extends StatefulWidget {
  const ThemeDemoPage({super.key});

  static String routeName = 'ThemeDemoPage';
  static String routePath = '/themeDemoPage';

  @override
  State<ThemeDemoPage> createState() => _ThemeDemoPageState();
}

class _ThemeDemoPageState extends State<ThemeDemoPage>
    with TickerProviderStateMixin {
  List<ThemePreset> availableThemes = [];
  bool isLoading = true;
  bool isRefreshing = false;
  String? selectedThemeId;
  String? errorMessage;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _loadThemes();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _loadThemes() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      // Test API connection first
      final isConnected = await ThemeService.testApiConnection();
      if (!isConnected) {
        throw Exception(
            'Cannot connect to theme server. Please check if it\'s running.');
      }

      final themes = await ThemeService.getAvailableThemes();
      if (mounted) {
        setState(() {
          availableThemes = themes;
          isLoading = false;
        });
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshThemes() async {
    if (mounted) {
      setState(() => isRefreshing = true);
    }

    try {
      final themes = await ThemeService.getAvailableThemes();
      if (mounted) {
        setState(() {
          availableThemes = themes;
          isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isRefreshing = false;
        });
      }
    }
  }

  Future<void> _applyTheme(String themeId) async {
    setState(() => selectedThemeId = themeId);
    _scaleController.forward().then((_) => _scaleController.reverse());

    try {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final success =
          await ThemeService.applyTheme(themeId, isDark: isDarkMode);

      if (success) {
        setState(() {}); // Trigger rebuild to show new theme
        _showSnackBar('🎨 Theme applied successfully!', isError: false);
      } else {
        setState(() => selectedThemeId = null);
        _showSnackBar('❌ Failed to apply theme', isError: true);
      }
    } catch (e) {
      setState(() => selectedThemeId = null);
      _showSnackBar('❌ Error applying theme: $e', isError: true);
    }
  }

  Future<void> _resetTheme() async {
    try {
      await ThemeService.resetToSystemTheme();
      setState(() {
        selectedThemeId = null;
      });
      _showSnackBar('🔄 Reset to system theme', isError: false);
    } catch (e) {
      _showSnackBar('❌ Error resetting theme: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primary,
        elevation: 0,
        title: Text(
          'Theme Gallery',
          style: theme.headlineMedium.override(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(context, theme),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshThemes,
        color: theme.primary,
        backgroundColor: theme.secondaryBackground,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeaderSection(theme),

                    SizedBox(height: 32.0),

                    // Current Theme Preview
                    _buildCurrentThemePreview(theme),

                    SizedBox(height: 32.0),

                    // Action Buttons
                    _buildActionButtons(theme),

                    SizedBox(height: 32.0),

                    // Available Themes Section
                    _buildThemesSection(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(FlutterFlowTheme theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Your App',
            style: theme.headlineLarge.override(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Choose from our curated collection of beautiful themes or create your own',
            style: theme.bodyLarge.override(
              color: theme.secondaryText,
              lineHeight: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentThemePreview(FlutterFlowTheme theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primary.withOpacity(0.1),
              theme.secondary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: theme.primary.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: theme.primary,
                  size: 24.0,
                ),
                SizedBox(width: 12.0),
                Text(
                  'Current Theme',
                  style: theme.headlineSmall.override(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Color palette
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                _buildColorChip('Primary', theme.primary, theme),
                _buildColorChip('Secondary', theme.secondary, theme),
                _buildColorChip('Tertiary', theme.tertiary, theme),
                _buildColorChip('Success', theme.success, theme),
                _buildColorChip('Warning', theme.warning, theme),
                _buildColorChip('Error', theme.error, theme),
              ],
            ),

            SizedBox(height: 20.0),

            // Sample content preview
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: theme.titleMedium.override(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'This is how your app will look with the current theme. All colors automatically adapt for proper contrast and readability.',
                    style: theme.bodyMedium.override(lineHeight: 1.5),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      _buildPreviewButton('Primary', theme.primary, theme),
                      SizedBox(width: 12.0),
                      _buildPreviewButton('Secondary', theme.secondary, theme),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorChip(String label, Color color, FlutterFlowTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        label,
        style: theme.labelMedium.override(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPreviewButton(String text, Color color, FlutterFlowTheme theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: theme.labelMedium.override(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(FlutterFlowTheme theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56.0,
              child: FFButtonWidget(
                onPressed: _resetTheme,
                text: 'Reset to Default',
                icon: Icon(Icons.refresh, size: 20.0),
                options: FFButtonOptions(
                  color: theme.secondary,
                  textStyle: theme.titleMedium.override(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  elevation: 2.0,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: SizedBox(
              height: 56.0,
              child: FFButtonWidget(
                onPressed: _refreshThemes,
                text: 'Refresh',
                icon: Icon(
                  isRefreshing ? Icons.hourglass_empty : Icons.sync,
                  size: 20.0,
                ),
                options: FFButtonOptions(
                  color: theme.tertiary,
                  textStyle: theme.titleMedium.override(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  elevation: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemesSection(FlutterFlowTheme theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view, color: theme.primary, size: 24.0),
              SizedBox(width: 12.0),
              Text(
                'Available Themes',
                style: theme.headlineSmall.override(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  '${availableThemes.length} themes',
                  style: theme.labelMedium.override(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          if (isLoading)
            _buildLoadingState(theme)
          else if (errorMessage != null)
            _buildErrorState(theme)
          else if (availableThemes.isEmpty)
            _buildEmptyState(theme)
          else
            _buildThemesGrid(theme),
        ],
      ),
    );
  }

  Widget _buildLoadingState(FlutterFlowTheme theme) {
    return Container(
      height: 200.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
              strokeWidth: 3.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Loading themes...',
              style: theme.bodyMedium.override(
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.error.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48.0,
            color: theme.error,
          ),
          SizedBox(height: 16.0),
          Text(
            'Failed to Load Themes',
            style: theme.titleMedium.override(
              color: theme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            errorMessage ?? 'Unknown error occurred',
            style: theme.bodyMedium.override(
              color: theme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          FFButtonWidget(
            onPressed: _loadThemes,
            text: 'Try Again',
            icon: Icon(Icons.refresh, size: 18.0),
            options: FFButtonOptions(
              color: theme.error,
              textStyle: theme.labelMedium.override(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate),
      ),
      child: Column(
        children: [
          Icon(
            Icons.palette_outlined,
            size: 48.0,
            color: theme.secondaryText,
          ),
          SizedBox(height: 16.0),
          Text(
            'No Themes Available',
            style: theme.titleMedium.override(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Make sure the theme server is running and accessible',
            style: theme.bodyMedium.override(
              color: theme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          FFButtonWidget(
            onPressed: _loadThemes,
            text: 'Check Connection',
            icon: Icon(Icons.wifi, size: 18.0),
            options: FFButtonOptions(
              color: theme.primary,
              textStyle: theme.labelMedium.override(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemesGrid(FlutterFlowTheme theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85,
      ),
      itemCount: availableThemes.length,
      itemBuilder: (context, index) {
        final themePreset = availableThemes[index];
        final isSelected = selectedThemeId == themePreset.id;

        return ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: () => _applyTheme(themePreset.id),
            child: Container(
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: isSelected ? theme.primary : theme.alternate,
                  width: isSelected ? 3.0 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12.0,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme preview header
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            _parseColor(
                                themePreset.colors['primary'] ?? '#4B39EF'),
                            _parseColor(
                                themePreset.colors['secondary'] ?? '#39D2C0'),
                            _parseColor(
                                themePreset.colors['tertiary'] ?? '#EE8B60'),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (isSelected)
                            Positioned(
                              top: 12.0,
                              right: 12.0,
                              child: Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: theme.primary,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          Center(
                            child: Icon(
                              Icons.palette,
                              color: Colors.white,
                              size: 32.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Theme info
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            themePreset.name,
                            style: theme.titleMedium.override(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.0),
                          Expanded(
                            child: Text(
                              themePreset.description,
                              style: theme.bodySmall.override(
                                color: theme.secondaryText,
                                lineHeight: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                Icons.color_lens,
                                size: 16.0,
                                color: theme.primary,
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                'Tap to apply',
                                style: theme.labelSmall.override(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _parseColor(String colorString) {
    try {
      String hexColor = colorString.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  void _showInfoDialog(BuildContext context, FlutterFlowTheme theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Theme Gallery',
          style: theme.headlineSmall.override(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This page allows you to:',
              style: theme.titleMedium.override(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.0),
            _buildInfoItem('🎨', 'Preview and apply custom themes', theme),
            _buildInfoItem('🔄', 'Reset to system default theme', theme),
            _buildInfoItem('📱', 'See real-time theme changes', theme),
            _buildInfoItem('💾', 'Themes are automatically saved', theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it!',
              style: theme.labelLarge.override(
                color: theme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String icon, String text, FlutterFlowTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 20.0)),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: theme.bodyMedium.override(
                color: theme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

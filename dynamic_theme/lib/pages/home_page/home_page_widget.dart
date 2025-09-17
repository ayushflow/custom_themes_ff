import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/color_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:dynamic_theme/custom_code/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.showLoader = true;
      safeSetState(() {});
      _model.allThemesRes = await AppThemeGroup.getThemesCall.call();

      if ((_model.allThemesRes?.succeeded ?? true)) {
        _model.showLoader = false;
        safeSetState(() {});
        return;
      } else {
        return;
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Dynamic Theme',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Builder(
              builder: (context) {
                if (_model.showLoader) {
                  return Text(
                    'Loading...',
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                        ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (context) {
                              final allThemes = ThemeResStruct.maybeFromMap(
                                          (_model.allThemesRes?.jsonBody ?? ''))
                                      ?.themes
                                      ?.toList() ??
                                  [];

                              return Wrap(
                                spacing: 12.0,
                                runSpacing: 12.0,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children: List.generate(allThemes.length,
                                    (allThemesIndex) {
                                  final allThemesItem =
                                      allThemes[allThemesIndex];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await ThemeService.applyTheme(
                                          allThemesItem.id);
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 140.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Text(
                                            allThemesItem.name,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                          Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [
                              wrapWithModel(
                                model: _model.colorCardModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).primary,
                                  colorName: 'Primary',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).secondary,
                                  colorName: 'Secondary',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  colorName: 'Tertiary',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  colorName: 'Alternate',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  colorName: 'Primary Background',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel6,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  colorName: 'Secondary Background',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel7,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  colorName: 'Primary Text',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel8,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  colorName: 'Secondary Text',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel9,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  colorName: 'Accent 1',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel10,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).accent2,
                                  colorName: 'Accent 2',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel11,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).accent3,
                                  colorName: 'Accent 3',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel12,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).accent4,
                                  colorName: 'Accent 4',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel13,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).success,
                                  colorName: 'Success',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel14,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).warning,
                                  colorName: 'Warning',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel15,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).error,
                                  colorName: 'Error',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel16,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).info,
                                  colorName: 'Info',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel17,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context)
                                      .richBlackFOGRA39,
                                  colorName: 'richBlackFOGRA39',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel18,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).blue,
                                  colorName: 'blue',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel19,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).turquoise,
                                  colorName: 'turquoise',
                                ),
                              ),
                              wrapWithModel(
                                model: _model.colorCardModel20,
                                updateCallback: () => safeSetState(() {}),
                                child: ColorCardWidget(
                                  color: FlutterFlowTheme.of(context).cultured,
                                  colorName: 'cultured',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              Text(
                                'Display Large',
                                style: FlutterFlowTheme.of(context)
                                    .displayLarge
                                    .override(
                                    ),
                              ),
                              Text(
                                'Display Medium',
                                style: FlutterFlowTheme.of(context)
                                    .displayMedium
                                    .override(
                                    ),
                              ),
                              Text(
                                'Display Small',
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                    ),
                              ),
                              Text(
                                'Headline Large',
                                style: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .override(
                                    ),
                              ),
                              Text(
                                'Headline Medium',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                    ),
                              ),
                              Text(
                                'Headline Small',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                    ),
                              ),
                              Text(
                                'Title Large',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                    ),
                              ),
                              Text(
                                'Title Medium',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                    ),
                              ),
                              Text(
                                'Title Small',
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                    ),
                              ),
                              Text(
                                'Label Large',
                                style: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                    ),
                              ),
                              Text(
                                'Label Medium',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                    ),
                              ),
                              Text(
                                'Label Small',
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                    ),
                              ),
                              Text(
                                'Body Large',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                    ),
                              ),
                              Text(
                                'Body Medium',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    ),
                              ),
                              Text(
                                'Body Small',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                    ),
                              ),
                            ].divide(SizedBox(height: 8.0)),
                          ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/color_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:dynamic_theme/custom_code/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  bool showLoader = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Get Themes)] action in HomePage widget.
  ApiCallResponse? allThemesRes;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel1;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel2;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel3;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel4;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel5;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel6;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel7;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel8;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel9;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel10;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel11;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel12;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel13;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel14;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel15;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel16;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel17;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel18;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel19;
  // Model for ColorCard component.
  late ColorCardModel colorCardModel20;

  @override
  void initState(BuildContext context) {
    colorCardModel1 = createModel(context, () => ColorCardModel());
    colorCardModel2 = createModel(context, () => ColorCardModel());
    colorCardModel3 = createModel(context, () => ColorCardModel());
    colorCardModel4 = createModel(context, () => ColorCardModel());
    colorCardModel5 = createModel(context, () => ColorCardModel());
    colorCardModel6 = createModel(context, () => ColorCardModel());
    colorCardModel7 = createModel(context, () => ColorCardModel());
    colorCardModel8 = createModel(context, () => ColorCardModel());
    colorCardModel9 = createModel(context, () => ColorCardModel());
    colorCardModel10 = createModel(context, () => ColorCardModel());
    colorCardModel11 = createModel(context, () => ColorCardModel());
    colorCardModel12 = createModel(context, () => ColorCardModel());
    colorCardModel13 = createModel(context, () => ColorCardModel());
    colorCardModel14 = createModel(context, () => ColorCardModel());
    colorCardModel15 = createModel(context, () => ColorCardModel());
    colorCardModel16 = createModel(context, () => ColorCardModel());
    colorCardModel17 = createModel(context, () => ColorCardModel());
    colorCardModel18 = createModel(context, () => ColorCardModel());
    colorCardModel19 = createModel(context, () => ColorCardModel());
    colorCardModel20 = createModel(context, () => ColorCardModel());
  }

  @override
  void dispose() {
    colorCardModel1.dispose();
    colorCardModel2.dispose();
    colorCardModel3.dispose();
    colorCardModel4.dispose();
    colorCardModel5.dispose();
    colorCardModel6.dispose();
    colorCardModel7.dispose();
    colorCardModel8.dispose();
    colorCardModel9.dispose();
    colorCardModel10.dispose();
    colorCardModel11.dispose();
    colorCardModel12.dispose();
    colorCardModel13.dispose();
    colorCardModel14.dispose();
    colorCardModel15.dispose();
    colorCardModel16.dispose();
    colorCardModel17.dispose();
    colorCardModel18.dispose();
    colorCardModel19.dispose();
    colorCardModel20.dispose();
  }
}

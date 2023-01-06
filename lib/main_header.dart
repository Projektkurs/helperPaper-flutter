/* main_header.dart - manages imports and constants
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

// dart and flutter packages
export 'package:flutter/material.dart';
export 'package:flutter/scheduler.dart' hide Flow;
export 'dart:async';
export 'dart:io';
export 'dart:math';
export 'dart:convert';
export 'package:http/http.dart';
export 'package:flutter_colorpicker/flutter_colorpicker.dart';

export 'misc.dart';
export 'translation.dart';
// main
export 'main.dart';
export 'config.dart';
// popups
export 'component/menuoptions.dart';
// popups::configmenus
export 'component/empty/popup.dart';
export 'component/clock/popup.dart';
export 'component/menu.dart';

// component
export 'component/component.dart';
export 'component/typedec.dart';
export 'component/generalconfig.dart';
// component::components
export 'component/clock/component.dart';
export 'component/example/example.dart';
export 'component/empty/component.dart';
export 'component/vertretungsplan/component.dart';
// component::configs
export 'component/clock/config.dart';
export 'component/empty/config.dart';
export 'component/vertretungsplan/config.dart';
// component::scaffolding
export 'component/scaffholding/scaffolding.dart';

// =true if it runs on epaper
const bool isepaper = bool.fromEnvironment("isepaper");

// default config that is applied on first start, on reset or on corrupted json
const String emptyjsonconfig =
    "{\"direction\":true,\"subcontainers\":1,\"length\":1,\"gconfig\":{\"flex\":2199023255552,\"type\":\"ScaffoldingConfig\",\"cconfig\":{},\"borderWidth\":null,\"borderRadius\":null},\"Child0\":{\"gconfig\":{\"flex\":2199023255552,\"type\":\"EmptyComponentConfig\",\"cconfig\":{\"width\":0,\"height\":0},\"borderWidth\":null,\"borderRadius\":null}}}";

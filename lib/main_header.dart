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
export 'component/menu.dart';
export 'component/popup.dart';

// component
export 'component/component.dart';
export 'component/typedec.dart';
export 'component/generalconfig.dart';
// component::clock
export 'components/clock/component.dart';
export 'components/clock/config.dart';
export 'components/clock/popup.dart';
// component::empty
export 'components/empty/component.dart';
export 'components/empty/config.dart';
export 'components/empty/popup.dart';
// component::example
export 'components/example/component.dart';
export 'components/example/config.dart';
export 'components/example/popup.dart';
// component::note
export 'components/note/component.dart';
export 'components/note/config.dart';
export 'components/note/popup.dart';
// component::vertretungsplan
export 'components/vertretungsplan/component.dart';
export 'components/vertretungsplan/config.dart';
export 'components/vertretungsplan/popup.dart';
// component::scaffolding
export 'components/scaffholding/scaffolding.dart';

// =true if it runs on epaper
const bool isepaper = bool.fromEnvironment("isepaper");

// default config that is applied on first start, on reset or on corrupted json
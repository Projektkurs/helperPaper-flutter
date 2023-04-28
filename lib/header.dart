/* main_header.dart - manages imports and constants
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

// dart and flutter packages
export 'dart:async';
export 'dart:io';
export 'dart:math';
export 'dart:convert';
export 'package:flutter/material.dart';
export 'package:flutter/scheduler.dart' hide Flow;
export 'package:http/http.dart';
export 'package:flutter_colorpicker/flutter_colorpicker.dart';
export 'package:path_provider/path_provider.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'fontweight.dart';
export 'translation.dart';

// main
export 'main.dart';
export 'config.dart';
export 'global_variables.dart';

// popups
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
// component::countdown
export 'components/countdown/component.dart';
export 'components/countdown/config.dart';
export 'components/countdown/popup.dart';
// component::empty
export 'components/empty/component.dart';
export 'components/empty/config.dart';
export 'components/empty/popup.dart';
// component::example
export 'components/example/component.dart';
export 'components/example/config.dart';
export 'components/example/popup.dart';
// component::image
export 'components/image/component.dart';
export 'components/image/config.dart';
export 'components/image/popup.dart';
// component::note
export 'components/note/component.dart';
export 'components/note/config.dart';
export 'components/note/popup.dart';
// component::roomResevation
export 'components/roomReservation/component.dart';
export 'components/roomReservation/config.dart';
export 'components/roomReservation/popup.dart';
// component::scaffolding
export 'components/scaffolding/component.dart';
export 'components/scaffolding/config.dart';
// component::substitutionPlan
export 'components/substitutionPlan/component.dart';
export 'components/substitutionPlan/config.dart';
export 'components/substitutionPlan/popup.dart';
// component::userInformation
export 'components/userInformation/component.dart';
export 'components/userInformation/config.dart';
export 'components/userInformation/popup.dart';

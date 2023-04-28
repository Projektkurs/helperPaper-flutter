// ignore_for_file: constant_identifier_names

import 'package:helperpaper/header.dart';

/// =true if it runs on epaper
const bool isepaper = bool.fromEnvironment("isepaper");

const int MAX_CONTAINERS = 6;

/// this variable will be set on startup and will contain the directory
/// where the configs are in
late String supportdir;

/// this contains the current main configuration and is set on startup
late JsonConfig configJson;

late SharedPreferences sharedPreferences;

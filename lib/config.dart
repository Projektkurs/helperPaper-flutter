/* config.dart - class which saves options convertable to json file
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:path/path.dart' as p;
import 'package:helperpaper/header.dart';

class JsonConfig {
  //configs
  String defaultconfig = '';
  List<String> configs = [];

  //epaper
  bool enableepaper = true;
  String epaper = 'localhost';
  int epaperRefreshtime = 60; //in seconds

  //vpmobil
  // TODO: put request on server
  String vpuser = '';
  String vppasswd = '';

  String server = 'http://localhost:2005';
  String user = '';
  String password = '';

  JsonConfig();
  void upload() async {
    try {
      post(Uri.parse("${configJson.epaper}/generalconfig"),
          body: jsonEncode(this));
    } catch (_) {}
  }

  Future<int> addconfig(String name, String json) async {
    if (await File(p.join(supportdir, 'configs', name)).exists()) {
      debugPrint('${p.join(supportdir, 'configs', name)} already exists');
      return 1;
    }
    //ensure that it is not a path
    configs.add(name);
    debugPrint(
        'creating config in file ${p.join(supportdir, 'configs', name)}');
    await File(p.join(supportdir, 'configs', name)).writeAsString(json);
    return 0;
  }

  Future<int> removeconfig(String name) async {
    return configs.remove(name) ? 0 : 1;
  }

  Future<int> renameconfig(String oldname, String newname) async {
    if (configs.contains(oldname)) {
      debugPrint('ERROR: $oldname is not a name of a config');
      return 1;
    }
    configs[configs.indexOf(oldname)] = newname;
    return 0;
  }

  Future<int> updateconfig(String name, json) async {
    await File(p.join(supportdir, 'configs', name)).writeAsString(json);
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'defaultconfig': defaultconfig,
        'configs': configs,
        'enableepaper': enableepaper,
        'epaper': epaper,
        'epaperRefreshtime': epaperRefreshtime,
        'vpuser': vpuser,
        'vppasswd': vppasswd,
        'server': server,
        'user': user,
        'password': password
      };

  JsonConfig.fromJson(Map<String, dynamic> json)
      : defaultconfig = json['defaultconfig'],
        configs = List<String>.from(json['configs']),
        enableepaper = json['enableepaper'] ?? true,
        epaper = json['epaper'] ?? 'localhost',
        epaperRefreshtime = json['epaperRefreshtime'] ?? 10,
        vpuser = json['vpuser'] ?? '',
        vppasswd = json['vppasswd'] ?? '',
        server = json['server'] ?? 'http://localhost:2005',
        user = json['user'] ?? '',
        password = json['password'] ?? '';
}

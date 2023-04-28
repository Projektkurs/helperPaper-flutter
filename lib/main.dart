/* main.dart - entry point
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:path/path.dart' as p;
import 'package:helperpaper/screens/settings.dart';
import 'screens/layout.dart';
import 'package:helperpaper/vpmobil.dart' as vp;

void main() {
  runApp(const EntryPoint());
}

final GeneralConfig globalgconf = GeneralConfig.createGeneral();

//Entry class, used to set default theme
class EntryPoint extends StatelessWidget {
  const EntryPoint({
    Key? key,
  }) : super(key: key);
  static const title = 'helper:Paper';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(title: title),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  /// this function is just used on the epaper.
  /// it creates a function that listends on the updatefifo
  /// and updates the current layout if the command is given
  epaperUpdateInterrupt() async {
    Future<String> fifocontent = File('../updatefifo').readAsString();
    fifocontent.then((message) {
      setState(() {
        layoutJson = File('./configs/defaultconfig').readAsStringSync();
        maincontainers = jsonDecode(layoutJson)['subcontainers'];
        mainscreenkey = GlobalKey();
        scafffromjson = true;
        File('config').writeAsString(jsonEncode(configJson));
      });
      epaperUpdateInterrupt();
    });
  }

  /// number of Widgets by the first scaffholding
  int maincontainers = 1;
  addContainer() {
    setState(() {
      maincontainers < MAX_CONTAINERS ? maincontainers++ : null;
    });
  }

  removeContainer() {
    setState(() {
      maincontainers > 1 ? maincontainers-- : null;
    });
  }

  late Future<void> configisload;
  @override
  void initState() {
    super.initState();
    if (isepaper) {
      epaperUpdateInterrupt();
    }
    vp.startupdatehandler();
    configisload = () async {
      sharedPreferences = await SharedPreferences.getInstance();
      supportdir =
          isepaper ? "./" : (await getApplicationSupportDirectory()).path;
      debugPrint("support directory:$supportdir");
      // load jsonconfig
      try {
        configJson = JsonConfig.fromJson(jsonDecode(
            await File(p.join(supportdir, 'config')).readAsString()));
      } catch (error) {
        configJson = JsonConfig();
        await File(p.join(supportdir, 'config'))
            .writeAsString(jsonEncode(configJson));
      }
      // load jsonsave
      try {
        await Directory(p.join(supportdir, "configs")).create();
        layoutJson =
            await File(p.join(supportdir, 'configs', configJson.defaultconfig))
                .readAsString();
        maincontainers = jsonDecode(layoutJson)['subcontainers'];
        scafffromjson = true;
      } catch (error) {
        debugPrint(
            "no Widget tree config found, will use the default init as config");
        SchedulerBinding.instance.scheduleFrameCallback((Duration duration) {
          layoutJson = jsonEncode(mainscaffolding);
          configJson.addconfig("defaultconfig", layoutJson);
          configJson.defaultconfig = "defaultconfig";
          File(p.join(supportdir, 'config'))
              .writeAsString(jsonEncode(configJson));
          debugPrint("new jsonsave:$layoutJson");
        });
      }
    }();
  }

  String layoutJson = "";

  ///Key is used for callbacks(scaffholding/callbacks.dart)
  ///it mustn't change, as they are saved at various places in the Widget tree
  ///exception to this is if the whole widget tree is droped
  GlobalKey<ScaffoldingState> scaffoldingkey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  GlobalKey mainscreenkey = GlobalKey();
  GlobalKey settingsscreenkey = GlobalKey();
  Scaffolding? mainscaffolding;

  ///controlls wether the next setState of MainScreen will be built from the Json config or a new Screen is used
  bool scafffromjson = false;
  bool firstbuild = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MainScreen(key: mainscreenkey, appState: this),
        routes: <String, WidgetBuilder>{
          '/mainScreen': (BuildContext context) =>
              MainScreen(key: mainscreenkey, appState: this),
          '/settingsScreen': (BuildContext context) =>
              SettingsScreen(key: settingsscreenkey, appState: this),
        });
  }
}

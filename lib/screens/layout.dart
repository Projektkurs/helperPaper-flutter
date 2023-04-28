/* layout.dart - base screen for AppState
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:path/path.dart' as p;

class MainScreen extends StatefulWidget {
  //Key is used for callbacks(scaffholding/callbacks.dart)
  //it mustn't change, as they are saved at various places in the Widget tree
  //exception to this is if the whole widget tree is droped
  const MainScreen({required super.key, required this.appState});
  final AppState appState;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showlines = false;
  bool firstbuild = true;
  _updatelines() {
    setState(() {
      showlines = !showlines;
    });
  }

  Scaffolding? mainscaffolding;
  @override
  Widget build(BuildContext context) {
    //cannot be in initstate as setState cannot be called there
    if (firstbuild) {
      () async {
        await widget.appState.configisload;
        // reread because the config might have changed
        if (isepaper) {
          widget.appState.layoutJson =
              File(p.join(supportdir, 'configs', configJson.defaultconfig))
                  .readAsStringSync();
          widget.appState.scafffromjson = true;
        }
        firstbuild = false;
        setState(() {});
      }();
    } else {
      if (widget.appState.scafffromjson) {
        widget.appState.scaffoldingkey = GlobalKey();
        mainscaffolding = Scaffolding.fromJson(
            jsonDecode(widget.appState.layoutJson),
            key: widget.appState.scaffoldingkey);
        widget.appState.scafffromjson = false;
      } else {
        mainscaffolding = Scaffolding(
            key: widget.appState.scaffoldingkey,
            gconfig: GeneralConfig(
              2 << 40, //arbitrary value for flex
              // high to have many to have smooth transition
            ),
            cconfig: ScaffoldingConfig(),
            direction: true,
            subcontainers: widget.appState.maincontainers,
            showlines: showlines);
      }
    }
    if (isepaper) {
      return Scaffold(
          key: widget.appState.scaffoldkey,
          body: Center(
              child: Stack(children: [
            // menu laying on top of the main Scaffholding
            Flex(
                direction: Axis.horizontal,
                children: [mainscaffolding ?? Container()]),
          ])));
    } else {
      return Scaffold(
          key: widget.appState.scaffoldkey,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Container hinzufügen'),
                  onTap: widget.appState.addContainer,
                ),
                ListTile(
                  leading: const Icon(Icons.remove),
                  title: const Text('Container entfernen'),
                  onTap: widget.appState.removeContainer,
                ),
                ListTile(
                  leading: const Icon(Icons.view_array_outlined),
                  title: const Text('Größe verändern'),
                  onTap: () {
                    _updatelines();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Einstellungen'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/settingsScreen');
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.file_upload),
                    title: const Text('Speichern'),
                    onTap: () {
                      widget.appState.layoutJson = jsonEncode(mainscaffolding);
                      debugPrint('New Jsonsave: ${widget.appState.layoutJson}');
                      configJson.updateconfig(
                          configJson.defaultconfig, widget.appState.layoutJson);
                      () async {
                        try {
                          var _ = await post(
                              Uri.parse("${configJson.epaper}/config"),
                              body: widget.appState.layoutJson);
                        } catch (_) {
                          debugPrint('WARNING: no epaper connected');
                        }
                      }();
                    }),
                ListTile(
                    leading: const Icon(Icons.file_download),
                    title: const Text('Laden'),
                    onTap: () {
                      setState(() {
                        debugPrint('apply Config');
                        widget.appState.maincontainers = jsonDecode(
                            widget.appState.layoutJson)['subcontainers'];
                        widget.appState.scafffromjson = true;
                      });
                    }),
                ListTile(
                    leading: const Icon(Icons.reset_tv),
                    title: Text(tr['generic']!['reset']!),
                    onTap: () {
                      setState(() {
                        widget.appState.mainscaffolding = null;
                        widget.appState.scaffoldingkey = GlobalKey();
                        configJson.updateconfig(configJson.defaultconfig,
                            widget.appState.layoutJson);
                      });
                      widget.appState.maincontainers = jsonDecode(
                          widget.appState.layoutJson)['subcontainers'];
                      widget.appState.scafffromjson = false;
                    }),
              ],
            ),
          ),
          body: Center(
            child: Column(children: [mainscaffolding ?? Container()]),
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                    child: FloatingActionButton(
                  // random tag, not refferenced. Otherwise, flutter could have a situtation where
                  // it changes screens and tries to do a hero animation
                  heroTag: 'dkjfhdlkfjdhflkjhflhslakfhuoewqzrq2d',
                  onPressed: () =>
                      widget.appState.scaffoldkey.currentState!.openDrawer(),
                  tooltip: 'menu',
                  child: const Icon(Icons.menu),
                )),
              ]));
    }
  }
}

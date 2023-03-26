/* main_screen.dart - base screen for AppState
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'dart:io' show Platform;

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
    if (Platform.isAndroid) {
      //perm.Permission.phone.request();
    }
    //cannot be in initstate as setState should cannot be called there
    if (firstbuild) {
      () async {
        await widget.appState.configisload;
        if (isepaper) {
          widget.appState.jsonsave =
              File(p.join(supportdir, 'configs', jsonconfig.defaultconfig))
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
            jsonDecode(widget.appState.jsonsave),
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
                      widget.appState.jsonsave = jsonEncode(mainscaffolding);
                      debugPrint('New Jsonsave: ${widget.appState.jsonsave}');
                      jsonconfig.updateconfig(
                          jsonconfig.defaultconfig, widget.appState.jsonsave);
                      () async {
                        try {
                          var _ = await post(
                              Uri.parse("${jsonconfig.epaper}/config"),
                              body: widget.appState.jsonsave);
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
                            widget.appState.jsonsave)['subcontainers'];
                        widget.appState.scafffromjson = true;
                      });
                    }),
                ListTile(
                    leading: const Icon(Icons.reset_tv),
                    title: const Text('Zurücksetzen'),
                    onTap: () {
                      setState(() {
                        widget.appState.mainscaffolding = null;
                        widget.appState.scaffoldingkey = GlobalKey();
                        jsonconfig.updateconfig(
                            jsonconfig.defaultconfig, widget.appState.jsonsave);
                      });
                      widget.appState.maincontainers =
                          jsonDecode(widget.appState.jsonsave)['subcontainers'];
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

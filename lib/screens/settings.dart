/* settings.dart - settings Screen for general use
 *
 * Copyright 2022 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */
import 'package:flutter/services.dart';
import 'package:helperpaper/header.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:helperpaper/httpserver.dart' as req;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required super.key, required this.appState});
  final AppState appState;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> userdialog() async {
    var updating = false;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          print("test");

          return Updatecredentials();
        });
  }

  late TextEditingController _vpusertextcontroller;
  late TextEditingController _vppasswdtextcontroller;
  late TextEditingController _servertextcontroller;
  late TextEditingController _epapertextcontroller;
  TextEditingController? _firstNameController;
  TextEditingController? _surnameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _vpusertextcontroller = TextEditingController(text: configJson.vpuser);
    _vppasswdtextcontroller = TextEditingController(text: configJson.vppasswd);
    _servertextcontroller = TextEditingController(text: configJson.server);
    _epapertextcontroller = TextEditingController();
  }

  Future<bool> changecredentials() async {
    if (jsonresponse == null) {
      return false;
    }
    //String xform = "";
    /*var controllers = [
      _firstNameController,
      _surnameController,
      _emailController,
      _phoneNumberController,
    ];*/
    Map<String, dynamic> body = {
      'firstname': _firstNameController!.text,
      'surname': _surnameController!.text,
      'email': _emailController!.text,
      'phone_number': _phoneNumberController!.text
    };
    var response =
        await req.req_resource('/user/change', bodyWithUsername: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
    /*var fieldnames = [
      'firstname',
      'surname',
      'email',
      'phone_number',
    ];
    for (var i in Iterable.generate(controllers.length)) {
      var controller = controllers[i];
      var fieldname = fieldnames[i];
      var field = jsonresponse[fieldname] ?? '';
      if (controller!.text != field) {
        xform += '$fieldname=${controller.text}&';
      }
    }
    print(xform);*/
  }

  final ImagePicker _picker = ImagePicker();

  dynamic jsonresponse;
  Map<String, dynamic>? epapers;
  var editcredentials = false;

  Future<void> createuserwidget() async {
    if (configJson.user == "") {
      try {
        http.get(Uri.parse("${configJson.server}/status/")).then((value) {
          userwidget = ExpansionTile(
              title: Text("Nutzer"),
              initiallyExpanded: true,
              children: [
                ListTile(
                  title: Text("Anmelden"),
                  onTap: () {
                    userdialog().then((value) => setState(() {}));
                  },
                )
              ]);
        });
      } catch (_) {}
      return;
    }
    try {
      //userwidget = const SizedBox();
      var epaperfuture = req.req_resource("/epaper/get");
      if (jsonresponse == null) {
        var url = Uri.parse('${configJson.server}/user/get');
        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
        var body =
            'username=${configJson.user}&password=${configJson.password}';
        var response = await http.post(url, headers: headers, body: body);
        jsonresponse = jsonDecode(response.body);
      }
      _firstNameController ??=
          TextEditingController(text: jsonresponse['firstname'] ?? '');
      _surnameController ??=
          TextEditingController(text: jsonresponse['surname'] ?? '');
      _emailController ??=
          TextEditingController(text: jsonresponse['email'] ?? '');
      _phoneNumberController ??=
          TextEditingController(text: jsonresponse['phone_number'] ?? '');

      print(jsonresponse);
      //var changecredentials = false;
      epapers = jsonDecode((await epaperfuture).body);
      //_epapertextcontroller.text;
      userwidget = ExpansionTile(
          title: Text("Nutzer"),
          trailing: Text("angemeldet als: ${configJson.user}",
              style: TextStyle(
                  color: configJson.user == "admin"
                      ? Colors.blueGrey //? Colors.red
                      : Colors.blueGrey)),
          initiallyExpanded: true,
          children: [
            ListTile(
              title: Text("Nutzer wechseln"),
              onTap: () {
                userdialog().then((value) => setState(() {}));
              },
            ),
            ListTile(
                title: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Flexible(child: Text("Vorname: ")),
                        Flexible(
                          child: TextField(
                            decoration: null,
                            controller: _firstNameController,
                            enabled: editcredentials,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Flexible(child: Text("Name: ")),
                        Flexible(
                          child: TextField(
                            decoration: null,
                            controller: _surnameController,
                            enabled: editcredentials,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Flexible(child: Text("Email: ")),
                        Flexible(
                          child: TextField(
                            decoration: null,
                            controller: _emailController,
                            enabled: editcredentials,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Flexible(child: Text("Telefon: ")),
                        Flexible(
                          child: TextField(
                            decoration: null,
                            controller: _phoneNumberController,
                            enabled: editcredentials,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!editcredentials)
                          TextButton(
                              onPressed: () {
                                editcredentials = true;
                                createuserwidget();
                                return;
                              },
                              child: const Text("Ändern"))
                        else
                          TextButton(
                              onPressed: () {
                                editcredentials = false;
                                createuserwidget();
                                return;
                              },
                              child: const Text("Abbrechen")),
                        if (editcredentials)
                          TextButton(
                              onPressed: () {
                                editcredentials = false;
                                //todo: Await
                                changecredentials();
                                createuserwidget();
                                return;
                              },
                              child: const Text("Annehmen"))
                      ],
                    ),
                    const TextField(
                      decoration: null,
                    )
                  ]),
            )),
            ListTile(
              title: const Text("Bild hochladen"),
              trailing: FloatingActionButton(
                heroTag: "aslkdjgasdfljkdashgfadsjhkfgasdjkhfagsuewzrtuk",
                onPressed: () {
                  _picker.pickImage(source: ImageSource.gallery);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: // just a autocomplete textfield for room/lesson
                  Autocomplete<String>(fieldViewBuilder: (BuildContext context,
                      TextEditingController textcontroller,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                _epapertextcontroller = textcontroller;
                var epapersbackward =
                    Map.fromIterable(epapers!.keys, key: (value) {
                  return epapers![value];
                }, value: (key) {
                  return key;
                });
                textcontroller.text = epapersbackward[configJson.epaper] ?? "";
                //textcontroller.text = ;
                return TextField(
                  controller: textcontroller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Raum',
                  ),
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              }, optionsBuilder: (TextEditingValue textEditingValue) {
                var optionlist = epapers!.keys;
                return optionlist.where((String option) {
                  return (option.toLowerCase())
                      .contains(textEditingValue.text.toLowerCase());
                });
              }, onSelected: (String value) {
                configJson.epaper = epapers![value];
                _epapertextcontroller.text = value;
                setState(() {});
                File(p.join(supportdir, 'config'))
                    .writeAsString(jsonEncode(configJson));
                configJson.upload();
              }),
            ),
            ListTile(
              title: const Text("Abmelden"),
              onTap: () {
                configJson.user = "";
                configJson.password = "";

                debugPrint(jsonEncode(configJson));
                File(p.join(supportdir, 'config'))
                    .writeAsString(jsonEncode(configJson));
                configJson.upload();
                jsonresponse == null;
                fromuserwidget = false;
                userwidget = null;
                createuserwidget().then((value) {
                  setState(() {});
                });
              },
            )
          ]);

      fromuserwidget = true;
      setState(() {});
    } catch (_) {}
  }

  bool fromuserwidget = false;
  Widget? userwidget;
  @override
  Widget build(BuildContext context) {
    if (!fromuserwidget) {
      createuserwidget();
    } else {
      fromuserwidget = false;
    }
    return Scaffold(
        //experimental
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              widget.appState.scafffromjson = true;
              Navigator.pushReplacementNamed(context, '/mainScreen');
            }),
        body: ListView(
          children: [
// E-Paper
            /*ExpansionTile(title: const Text('E-Paper'), children: [
              Container(
                  margin: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _textcontroller,
                    onSubmitted: (String value) {
                      jsonconfig.epaperIP = value;
                      debugPrint(jsonEncode(jsonconfig));
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'epaper IP',
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _porttextcontroller,
                    onSubmitted: (String value) {
                      int? tmpport = int.tryParse(value);
                      if (tmpport == null) {
                        setState(() {
                          _validport = false;
                        });
                      } else {
                        if (tmpport <= 0 || tmpport > 2 << 15) {
                          setState(() {
                            _validport = false;
                          });
                          tmpport = null;
                        } else {
                          setState(() {
                            _validport = true;
                          });
                        }
                      }
                      jsonconfig.epaperPort = tmpport ?? jsonconfig.epaperPort;
                      debugPrint(jsonEncode(jsonconfig));
                      File(p.join(supportdir, 'config'))
                          .writeAsString(jsonEncode(jsonconfig));
                      jsonconfig.upload();
                    },
                    decoration: InputDecoration(
                      errorText: _validport
                          ? null
                          : () {
                              return 'Invalid port';
                            }(),
                      border: const OutlineInputBorder(),
                      labelText: 'epaper Port',
                    ),
                  ))
            ]),*/
            Container(
                margin: const EdgeInsets.all(8),
                child: TextField(
                  controller: _vpusertextcontroller,
                  onSubmitted: (String value) {
                    configJson.vpuser = value;
                    debugPrint(jsonEncode(configJson));
                    File(p.join(supportdir, 'config'))
                        .writeAsString(jsonEncode(configJson));
                    configJson.upload();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'vpmobil Nutzer',
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(8),
                child: TextField(
                  obscureText: true,
                  controller: _vppasswdtextcontroller,
                  onSubmitted: (String value) {
                    configJson.vppasswd = value;
                    debugPrint(jsonEncode(configJson));
                    File(p.join(supportdir, 'config'))
                        .writeAsString(jsonEncode(configJson));
                    configJson.upload();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'vpmobil Passwort',
                  ),
                )),
            if (userwidget != null)
              userwidget!
            else
              Container(
                  margin: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _servertextcontroller,
                    onSubmitted: (String value) {
                      configJson.server = value;
                      debugPrint(jsonEncode(configJson));
                      File(p.join(supportdir, 'config'))
                          .writeAsString(jsonEncode(configJson));
                      configJson.upload();
                      fromuserwidget = true;
                      createuserwidget().then((value) => setState(() {}));
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Server ip',
                    ),
                  )),
          ],
        ));
  }
}

class Updatecredentials extends StatefulWidget {
  const Updatecredentials({Key? key}) : super(key: key);

  @override
  _UpdateCredentialsState createState() => _UpdateCredentialsState();
}

class _UpdateCredentialsState extends State<Updatecredentials> {
  late TextEditingController _usertextcontroller;
  late TextEditingController _passwordtextcontroller;
  bool updating = false;
  bool success = false;
  bool wrongcredentials = false;
  @override
  void initState() {
    super.initState();
    _usertextcontroller = TextEditingController(text: configJson.user);
    _passwordtextcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    void submitt() {
      () async {
        var url = Uri.parse('${configJson.server}/user/isvalid');
        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
        var body =
            'username=${_usertextcontroller.text}&password=${_passwordtextcontroller.text}';
        var response = await http.post(url, headers: headers, body: body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          setState(() {
            success = true;
          });
          configJson.user = _usertextcontroller.text;
          configJson.password = _passwordtextcontroller.text;
          var file = File(p.join(supportdir, 'config'))
              .writeAsString(jsonEncode(configJson));
          await Future.delayed(const Duration(milliseconds: 500));
          file.then((value) => Navigator.pop(context));
        } else {
          setState(() {
            wrongcredentials = true;
            updating = false;
          });
        }
      }();
      updating = true;
      setState(() {});
    }

    if (success) {
      return const AlertDialog(
        content: Text(
          "Erfolgreich Eingeloggt",
          style: TextStyle(color: Colors.greenAccent),
          textScaleFactor: 3,
        ),
      );
    }
    return AlertDialog(
      key: UniqueKey(),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      scrollable: false,
      title: const Text('Einloggen'),
      content: IntrinsicHeight(
          child: Focus(
              autofocus: true,
              child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (key) {
                    if (key.logicalKey == LogicalKeyboardKey.enter) {
                      submitt();
                    }
                  },
                  child: Column(children: [
                    Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _usertextcontroller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nutzername',
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _passwordtextcontroller,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Passwort',
                          ),
                        )),
                    if (wrongcredentials)
                      const Text(
                        "Nutzername oder Passwort falsch",
                        style: TextStyle(color: Colors.red),
                      ),
                    if (updating) const CircularProgressIndicator()
                  ])))),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("abbrechen")),
        TextButton(
            onPressed: () {
              submitt();
            },
            child: const Text("Anmelden"))
      ],
    );
  }
}

/* UserInformation/component.dart - UserInformation to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:helperpaper/httpserver.dart' as req;

class UserInformation extends Component {
  UserInformation(
      {required Key key,
      required GeneralConfig gconfig,
      required UserInformationConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  @override
  State<UserInformation> createState() => UserInformationState();
}

class UserInformationState extends ComponentState<UserInformation> {
  late Future<String> _future;
  @override
  popup() async {
    await popupdialog(
        UserInformationPopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updatefuture();
  }

  updatefuture() async {
    _future = Future.microtask(() async {
      return (await req.req_resource("/user/get")).body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return componentbuild(Container(
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data == null) {
                print("wtf");
              }
              dynamic json = jsonDecode(snapshot.data);

              var firstname = json['firstname']!;
              var surname = json['surname'];
              var email = json['email'];
              var phone_number = json['phone_number'];
              return FittedBox(
                  fit: BoxFit.contain,
                  child: Center(
                      child: Text(
                    "Vorname: $firstname\nName: $surname\nEmail: $email\nTelefonnummer: $phone_number",
                  )));
            default:
              return const SizedBox();
          }
        },
      ),
    ));
  }
}

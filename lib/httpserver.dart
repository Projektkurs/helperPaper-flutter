import 'package:helperpaper/header.dart';
import 'package:http/http.dart' as http;

Future<http.Response> req_resource(String path,
    {Map<String, dynamic>? bodyWithUsername}) async {
  if (!path.startsWith('/')) {
    path = '/$path';
  }
  var url = Uri.parse('${jsonconfig.server}$path');
  Map<String, dynamic> body = bodyWithUsername ?? {};
  if (bodyWithUsername != null) {
    body = bodyWithUsername;
    body['userdata[username]'] = jsonconfig.user;
    body['userdata[password]'] = jsonconfig.password;
    //body['userdata'] = {
    //  'username': jsonconfig.user,
    //  'password': jsonconfig.password
    //};
  } else {
    body = {'username': jsonconfig.user, 'password': jsonconfig.password};
  }
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  //var body = 'username=${jsonconfig.user}&password=${jsonconfig.password}';
  late Response response;
  getresponse() async {
    try {
      response = await http.post(url, headers: headers, body: body);
    } catch (_) {
      debugPrint(" getresponse failed, retry in 5 seconds");
      await Future.delayed(Duration(seconds: 5)).then((value) => getresponse());
    }
  }

  await getresponse();
  return response;
}

Future<http.Response> reqGetEventRangeCurrentdayOffset(String room,
    {int offset = 0}) async {
  return await req_resource("/room/get_event_range", bodyWithUsername: {
    'room_name': room,
    'get_current_day': true.toString(),
    'get_current_day_offset_in_days': offset.toString()
  });
}

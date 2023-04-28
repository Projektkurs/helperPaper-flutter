import 'package:helperpaper/header.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<Widget> get(String path, {bool aspreview = false}) async {
  final url = Uri.parse(
      '${configJson.server}/image/${aspreview ? 'preview' : 'get'}/$path');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final body = 'username=${configJson.user}&password=${configJson.password}';
  late Response response;
  getresponse() async {
    try {
      response = await http.post(url, headers: headers, body: body);
    } catch (_) {
      debugPrint("getting image failed, retry in 5 seconds");
      await Future.delayed(Duration(seconds: 5)).then((value) => getresponse());
    }
  }

  await getresponse();

  //var response = await http.post(url, headers: headers, body: body);
  return Image.memory(
    response.bodyBytes,
    fit: BoxFit.contain,
  );
}

Future<List<String>> list() async {
  final url = Uri.parse('${configJson.server}/image/list');
  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final body = 'username=${configJson.user}&password=${configJson.password}';
  var response = await http.post(url, headers: headers, body: body);
  return response.body.split('\n');
  //return Image.memory(response.bodyBytes);
}

upload(String path) async {
  final url = Uri.parse('${configJson.server}/image/upload');

  final request = http.MultipartRequest('POST', url);

  request.files.add(await http.MultipartFile.fromPath(
    'image',
    path,
    contentType: MediaType('image', 'jpeg'),
  ));
  request.fields['username'] = configJson.user;
  request.fields['password'] = configJson.password;

  final response = await request.send();

  if (response.statusCode == 200) {
    print('Upload successful');
  } else {
    print('Upload failed with status ${response.statusCode}');
  }
}

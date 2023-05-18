/* Image/component.dart - Image to build a barebones component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:helperpaper/image.dart' as image;

class ImageComponent extends Component<ImageConfig> {
  ImageComponent(
      {required Key key,
      required GeneralConfig gconfig,
      required ImageConfig cconfig,
      bool inpopup = false})
      : super(key: key, gconfig: gconfig, cconfig: cconfig, inpopup: inpopup);

  ImageComponent.fromJson(Map<String, dynamic> json)
      : super(
            key: GlobalKey(),
            gconfig: GeneralConfig.fromJson(json['gconfig']),
            cconfig: ImageConfig.fromJson(json['cconfig']));
  @override
  State<ImageComponent> createState() => ImageState();
}

class ImageState extends ComponentState<ImageComponent> {
  @override
  popup() async {
    await popupdialog(
        ImagePopup(gconfig: widget.gconfig, cconfig: widget.cconfig));
    setState(() {
      _image = null;
    });
  }

  Widget? _image;
  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      image.get(widget.cconfig.name).then((value) {
        setState(() {
          _image = value;
        });
      });
    }
    return componentbuild(
        _image ?? const SizedBox()); //Image.asset("assets/images/logo.jpg"));
  }
}

/* Image/popup.dart - popup menu of Image component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:helperpaper/image.dart' as image;

class ImagePopup extends Popup<ImageConfig> {
  const ImagePopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<ImagePopup> createState() => _ImagePopupState();
}

List<Widget> images = [];
List<String> names = [];

class _ImagePopupState extends PopupState<ImagePopup> {
  Widget firstpage(BuildContext context) {
    //for adding images
    /*() async {
      await image.upload('assets/images/logo.jpg');
      await image
          .upload('assets/images/Screenshot from 2021-10-07 16-18-08.png');
      await image
          .upload('assets/images/Screenshot from 2021-03-06 18-55-04.png');
      await image
          .upload('assets/images/Screenshot from 2021-02-22 11-36-05.png');
      await image
          .upload('assets/images/Screenshot from 2021-02-05 09-32-27.png');
      await image.upload('assets/images/Passfotos.jpg');
    }();*/
    if (images.isEmpty) {
      () async {
        images = [];

        names = await image.list();
        List<Future<Widget>> imageFutures = [];
        for (var name in names) {
          imageFutures.add(image.get(name, aspreview: true));
        }
        for (var image_future in imageFutures) {
          var imageWidget = await image_future;
          if (mounted) {
            setState(() {
              images.add(imageWidget);
            });
          }
        }
      }();
    }
    List<Widget> wrappedImages = [];
    for (var i = 0; i < images.length; i++) {
      var imageWidget = images[i];
      var name = names[i];

      wrappedImages.add(GestureDetector(
          onTap: () {
            setState(() {
              widget.cconfig.name = name;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget.cconfig.name == name
                    ? Colors.blueAccent
                    : Color.fromARGB(255, 230, 230, 230),
                border: Border.all(color: Colors.grey, width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: GridTile(
              footer: Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              child: imageWidget,
            ),
          )));
    }
    return GridView.extent(
      key: UniqueKey(),
      maxCrossAxisExtent: 600,
      children: wrappedImages,
    );
  }

  @override
  void initState() {
    oldcconfig = ImageConfig();
    tabs = [firstpage];
    super.initState();
  }
}

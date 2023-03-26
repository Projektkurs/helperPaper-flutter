/* UserInformation/popup.dart - popup menu of UserInformation component
 *
 * Copyright 2023 by Ben Mattes Krusekamp <ben.krause05@gmail.com>
 */

import 'package:helperpaper/header.dart';

class UserInformationPopup extends Popup<UserInformationConfig> {
  const UserInformationPopup(
      {super.key,
      required super.gconfig,
      required super.cconfig,
      super.byempty});

  @override
  State<UserInformationPopup> createState() => _UserInformationPopupState();
}

class _UserInformationPopupState extends PopupState<UserInformationPopup> {
  Widget firstpage(BuildContext context) {
    return const SizedBox.expand();
  }

  @override
  void initState() {
    oldcconfig = UserInformationConfig();
    tabs = [firstpage];
    super.initState();
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioanaunia/pages/contattaci_tab.dart';
import 'package:radioanaunia/pages/radio_tab.dart';
import 'package:radioanaunia/pages/webcam_tab.dart';
import 'package:radioanaunia/utils_functions.dart';

import 'archivio_tab.dart';

enum AppTab {
  radio,
  archivio,
  webcam,
  diretta,
  website,
  contattaci,
}

extension AppTabProps on AppTab {
  String get displayName {
    switch (this) {
      case AppTab.radio:
        return "Radio";
      case AppTab.archivio:
        return "Archivio";
      case AppTab.webcam:
        return "Webcam";
      case AppTab.diretta:
        return "Diretta";
      case AppTab.website:
        return "Sito Web";
      case AppTab.contattaci:
        return "Contattaci";
    }
  }

  IconData get icon {
    switch (this) {
      case AppTab.radio:
        return Icons.audiotrack;
      case AppTab.archivio:
        return Icons.storage;
      case AppTab.webcam:
        return Icons.camera;
      case AppTab.diretta:
        return FontAwesomeIcons.youtube;
      case AppTab.website:
        return Icons.link;
      case AppTab.contattaci:
        return Icons.contact_mail;
    }
  }

  _TabAction get action {
    switch (this) {
      case AppTab.radio:
        return _TabAction.widget(
          widget: const RadioTab(),
          title: Image.asset("assets/logoTitle.png", height: 45),
        );
      case AppTab.archivio:
        return _TabAction.widget(
          widget: const ArchivioTab(),
          title: Text(this.displayName),
        );
      case AppTab.webcam:
        return _TabAction.widget(
          widget: const WebcamTab(),
          title: Text(this.displayName),
        );
      case AppTab.diretta:
        return _TabAction.onTap(() => openUrl("https://www.youtube.com/channel/UCkJssIWpAzIgeZfDeLf3etw"));
      case AppTab.website:
        return _TabAction.onTap(() => openUrl("https://radioanaunia.it"));
      case AppTab.contattaci:
        return _TabAction.widget(
          widget: const ContattaciTab(),
          title: Text(this.displayName),
        );
    }
  }
}

class _TabAction {
  final Widget? widget;
  final Widget? title;
  final void Function()? onTap;
  final bool isWidget;

  _TabAction.widget({required Widget this.widget, required Widget this.title})
      : onTap = null,
        isWidget = true;

  _TabAction.onTap(void Function() this.onTap)
      : widget = null,
        title = null,
        isWidget = false;
}

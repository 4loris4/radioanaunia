import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/pages/contact_us_tab.dart';
import 'package:radioanaunia/pages/radio_tab.dart';
import 'package:radioanaunia/pages/webcam_tab.dart';
import 'package:radioanaunia/utils_functions.dart';

import 'archive_tab.dart';

enum AppTab {
  radio,
  archive,
  webcam,
  live,
  website,
  contactUs,
}

class TabAction {
  final Widget? widget;
  final Widget? title;
  final void Function()? onTap;
  final bool isWidget;

  TabAction.widget({required Widget this.widget, required Widget this.title})
      : onTap = null,
        isWidget = true;

  TabAction.onTap(void Function() this.onTap)
      : widget = null,
        title = null,
        isWidget = false;
}

extension AppTabData on AppTab {
  String displayName(BuildContext context) {
    switch (this) {
      case AppTab.radio:
        return lang(context).tabRadio;
      case AppTab.archive:
        return lang(context).tabArchive;
      case AppTab.webcam:
        return lang(context).tabWebcam;
      case AppTab.live:
        return lang(context).tabLive;
      case AppTab.website:
        return lang(context).tabWebsite;
      case AppTab.contactUs:
        return lang(context).tabContactUs;
    }
  }

  IconData get icon {
    switch (this) {
      case AppTab.radio:
        return Icons.audiotrack;
      case AppTab.archive:
        return Icons.storage;
      case AppTab.webcam:
        return Icons.camera;
      case AppTab.live:
        return FontAwesomeIcons.youtube;
      case AppTab.website:
        return Icons.link;
      case AppTab.contactUs:
        return Icons.contact_mail;
    }
  }

  TabAction action(BuildContext context) {
    switch (this) {
      case AppTab.radio:
        return TabAction.widget(
          widget: const RadioTab(),
          title: Image.asset("assets/logoTitle.png", height: 45),
        );
      case AppTab.archive:
        return TabAction.widget(
          widget: const ArchiveTab(),
          title: Text(displayName(context)),
        );
      case AppTab.webcam:
        return TabAction.widget(
          widget: const WebcamTab(),
          title: Text(displayName(context)),
        );
      case AppTab.live:
        return TabAction.onTap(() => openUrl("https://www.youtube.com/channel/UCkJssIWpAzIgeZfDeLf3etw"));
      case AppTab.website:
        return TabAction.onTap(() => openUrl("https://radioanaunia.it"));
      case AppTab.contactUs:
        return TabAction.widget(
          widget: const ContactUsTab(),
          title: Text(displayName(context)),
        );
    }
  }
}

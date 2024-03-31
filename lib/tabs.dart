import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/pages/archive_tab.dart';
import 'package:radioanaunia/pages/contact_us_tab.dart';
import 'package:radioanaunia/pages/radio_tab.dart';
import 'package:radioanaunia/pages/webcam_tab.dart';

abstract class TabAction {
  final String Function(BuildContext context) title;
  final IconData icon;

  const TabAction({
    required this.title,
    required this.icon,
  });
}

class TabActionWidget extends TabAction {
  final int index;
  final Widget widget;
  final Widget Function(BuildContext context)? _appBarTitle;

  static int _nextIndex = 0;

  TabActionWidget({
    required super.title,
    required super.icon,
    required this.widget,
    Widget Function(BuildContext context)? appBarTitle,
  })  : _appBarTitle = appBarTitle,
        index = _nextIndex++;

  Widget appBarTitle(BuildContext context) => _appBarTitle?.call(context) ?? Text(title(context));
}

class TabActionLink extends TabAction {
  final String url;

  const TabActionLink({
    required super.title,
    required super.icon,
    required this.url,
  });
}

final tabs = List<TabAction>.unmodifiable(<TabAction>[
  RadioTab.widget,
  ArchiveTab.widget,
  WebcamTab.widget,
  TabActionLink(
    title: (context) => lang(context).tabLive,
    icon: FontAwesomeIcons.youtube,
    url: "https://www.youtube.com/channel/UCkJssIWpAzIgeZfDeLf3etw",
  ),
  TabActionLink(
    title: (context) => lang(context).tabWebsite,
    icon: Icons.link,
    url: "https://radioanaunia.it",
  ),
  ContactUsTab.widget,
]);

final widgetTabs = List<TabActionWidget>.unmodifiable(tabs.whereType<TabActionWidget>());

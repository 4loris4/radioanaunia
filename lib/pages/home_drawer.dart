import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/tabs.dart';
import 'package:radioanaunia/themes.dart';
import 'package:radioanaunia/utils_functions.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Drawer(
            backgroundColor: const Color.fromARGB(96, 64, 64, 64),
            child: SafeArea(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(16), child: Image(image: AssetImage("assets/logo.png"))),
                  Expanded(
                    child: ListView(
                      children: tabs.map((tab) {
                        return ListTile(
                          title: Text(tab.title(context)),
                          leading: Icon(tab.icon),
                          onTap: () {
                            if (tab is TabActionWidget) {
                              Provider.of<TabProvider>(context, listen: false).value = tab.index;
                              Navigator.of(context).pop();
                            } else if (tab is TabActionLink) {
                              openUrl(tab.url);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        lang(context).credits,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

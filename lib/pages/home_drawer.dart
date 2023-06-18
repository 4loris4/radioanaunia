import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/pages/app_tab_type.dart';
import 'package:radioanaunia/themes.dart';

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
                  Expanded(
                    child: ListView(
                      children: [
                        const Padding(padding: EdgeInsets.all(16), child: Image(image: AssetImage("assets/logo.png"))),
                        ...AppTab.values.map((tab) {
                          final action = tab.action(context);
                          return ListTile(
                            title: Text(tab.displayName(context)),
                            leading: Icon(tab.icon),
                            onTap: () {
                              if (action.isWidget) {
                                Provider.of<TabProvider>(context, listen: false).value = tab;
                                Navigator.of(context).pop();
                              } else {
                                action.onTap!();
                              }
                            },
                          );
                        })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Opacity(
                      opacity: .5,
                      child: Center(child: Text(lang(context).credits, style: const TextStyle(fontSize: 10))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

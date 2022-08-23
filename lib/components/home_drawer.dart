import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:provider/provider.dart';
import 'package:radioanaunia/pages/app_tab_type.dart';
import 'package:radioanaunia/providers/tab_provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TabProvider>(
      builder: (context, tabProvider, _) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: Drawer(
              backgroundColor: Colors.grey.shade800.withOpacity(.3),
              child: PadColumn(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                children: [
                  Padding(padding: const EdgeInsets.all(16), child: Image(image: AssetImage("assets/logo.png"))),
                  Expanded(
                    child: ListView(
                      children: [
                        ...AppTab.values.map((tab) {
                          return ListTile(
                            title: Text(tab.displayName, style: TextStyle(color: Colors.white)),
                            leading: Icon(tab.icon, color: Colors.white),
                            onTap: tab.action.isWidget
                                ? () {
                                    tabProvider.value = tab;
                                    Navigator.of(context).pop();
                                  }
                                : tab.action.onTap!,
                          );
                        })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        "App sviluppata da Loris Giuliani (4loris4@gmail.com)",
                        style: TextStyle(color: Colors.grey.withOpacity(.5), fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

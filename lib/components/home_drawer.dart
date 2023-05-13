import 'dart:ui';

import 'package:flutter/material.dart';
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
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Drawer(
              backgroundColor: Color.fromARGB(96, 64, 64, 64),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(padding: const EdgeInsets.all(16), child: Image(image: AssetImage("assets/logo.png"))),
                          ...AppTab.values.map(
                            (tab) => ListTile(
                              title: Text(tab.displayName, style: TextStyle(color: Colors.white)),
                              leading: Icon(tab.icon, color: Colors.white),
                              onTap: tab.action.isWidget
                                  ? () {
                                      tabProvider.value = tab;
                                      Navigator.of(context).pop();
                                    }
                                  : tab.action.onTap!,
                            ),
                          )
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
          ),
        );
      },
    );
  }
}

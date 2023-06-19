import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:radioanaunia/pages/home_drawer.dart';
import 'package:radioanaunia/tabs.dart';
import 'package:radioanaunia/themes.dart';

typedef TabProvider = ValueNotifier<int>;

AppLocalizations lang(BuildContext context) => AppLocalizations.of(context)!;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));

  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TabProvider(0),
      child: MaterialApp(
        title: "Radio Anaunia",
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Consumer<TabProvider>(builder: (context, tabProvider, _) {
          final tab = widgetTabs[tabProvider.value];
          return Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: Scaffold.of(context).openDrawer,
                  icon: const DrawerButtonIcon(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  splashRadius: 24,
                ),
              ),
              title: tab.appBarTitle(context),
            ),
            body: IndexedStack(
              index: tab.index,
              children: widgetTabs.map((tab) => tab.widget).toList(),
            ),
            drawer: const HomeDrawer(),
          );
        }),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("it"),
          Locale("en"),
        ],
      ),
    );
  }
}

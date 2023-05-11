import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:radioanaunia/components/home_drawer.dart';
import 'package:radioanaunia/pages/app_tab_type.dart';
import 'package:radioanaunia/providers/tab_provider.dart';

//TODO check fixed iOS
//? sezione webcam con scroll to reload, si sposta tutto?
//? landscape
//? la musica si interrompe quando chiudi l'applicazione
//? archivio, testo durata si continua a spostare

//TODO safe space (slider volume)

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TabProvider(),
      child: MaterialApp(
        title: "Radio Anaunia",
        theme: ThemeData(primarySwatch: Colors.grey),
        home: Consumer<TabProvider>(
          builder: (context, tab, _) {
            return Scaffold(
              appBar: AppBar(
                leading: Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: Icon(Icons.menu),
                    tooltip: "Apri il menu di navigazione",
                    splashRadius: 24,
                  ),
                ),
                title: tab.value.action.title,
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey.shade900,
              ),
              body: tab.value.action.widget,
              backgroundColor: Colors.black,
              drawer: const HomeDrawer(),
            );
          },
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale("it")
        ],
      ),
    );
  }
}

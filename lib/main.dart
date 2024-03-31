import 'package:audio_service/audio_service.dart' hide AudioHandler;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radioanaunia/audio_handler.dart';
import 'package:radioanaunia/components/app_bar_fix.dart';
import 'package:radioanaunia/pages/home_drawer.dart';
import 'package:radioanaunia/pages/radio_tab.dart';
import 'package:radioanaunia/tabs.dart';
import 'package:radioanaunia/themes.dart';

final tabProvider = StateProvider<TabActionWidget>((ref) => RadioTab.widget);

late final AudioHandler audioHandler;

AppLocalizations lang(BuildContext context) => AppLocalizations.of(context)!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));

  audioHandler = await AudioService.init(
    builder: () => AudioHandler(),
    config: const AudioServiceConfig(androidNotificationIcon: "mipmap/notification_icon"),
  );

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    AudioService.notificationClicked.where((e) => e).listen((_) {
      ref.read(tabProvider.notifier).state = RadioTab.widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(tabProvider);
    return MaterialApp(
      title: "Radio Anaunia",
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBarFix(title: tab.appBarTitle(context)),
          body: IndexedStack(index: tab.index, children: widgetTabs.map((tab) => tab.widget).toList()),
          drawer: const HomeDrawer(),
        );
      }),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

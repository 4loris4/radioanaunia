import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:radioanaunia/Tabs/RadioTab.dart';
import 'package:radioanaunia/Tabs/ArchivioTab.dart';
import 'package:radioanaunia/Tabs/WebcamTab.dart';
import 'package:radioanaunia/Tabs/ContattaciTab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'dart:ui';

void main() => runApp(new MaterialApp(home: new App()));

enum ScreenType { Radio, Archivio, Webcam, Youtube, SitoWeb, Contattaci }

const Color mainColor = Color(0xFF00a9ed);
const Color backgroundColor = Colors.black;
const Color secondaryColror = Colors.blueAccent;

AudioPlayer audioPlayer = new AudioPlayer();
String currentlyPlaying = "";
String previouslyPlaying = " ";
bool paused = false;
bool buffering = false;

void updateRadio({double progress}) {
  if(paused) {
    audioPlayer.pause();
  }
  else if(currentlyPlaying == "") {
    audioPlayer.stop();
  }
  else {
    if(currentlyPlaying != previouslyPlaying) {
      audioPlayer.stop();
    }
    audioPlayer.play(currentlyPlaying);

    StreamSubscription<AudioPlayerState> bufferingSeek;
    bufferingSeek = audioPlayer.onPlayerStateChanged.listen((playerState) {
      if(playerState == AudioPlayerState.PLAYING) {
        audioPlayer.seek(progress == null ? 0 : progress);
        bufferingSeek.cancel();
      }
    });
  }
  previouslyPlaying = currentlyPlaying;
}

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  static Container backgroundImage(String imageURL) {
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage(imageURL),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Widget currentScreen = new RadioTab();
  ScreenType currentScreenType = ScreenType.Radio;
  Widget appBarTitle = new Image.asset("assets/logoTitle.png", height: 45);

  ClipRect navigationDrawer() {
    return new ClipRect(
      child: new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: new Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.black.withOpacity(0.25)),
          child: new Drawer(
            child: new Stack(
              children: <Widget>[
                new ListView(
                  children: <Widget>[
                    new DrawerHeader(
                      child: App.backgroundImage("assets/logo.png"),
                      padding: EdgeInsets.all(0.0),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.radio, color: Colors.white),
                      title: new Text("Radio", style: new TextStyle(color: Colors.white)),
                      onTap: () => drawerTilePressed(ScreenType.Radio),
                    ),
                    new Divider(),
                    new ListTile(
                      leading: new Icon(FontAwesomeIcons.database, color: Colors.white),
                      title: new Text("Archivio", style: new TextStyle(color: Colors.white)),
                      onTap: () => drawerTilePressed(ScreenType.Archivio),
                    ),
                    new ListTile(
                      leading: new Icon(FontAwesomeIcons.images, color: Colors.white),
                      title: new Text("Webcam", style: new TextStyle(color: Colors.white)),
                      onTap: () => drawerTilePressed(ScreenType.Webcam),
                    ),
                    new ListTile(
                      leading: new Icon(FontAwesomeIcons.youtube, color: Colors.white),
                      title: new Text("Diretta", style: new TextStyle(color: Colors.white)),
                      onTap: () => drawerTilePressed(ScreenType.Youtube),
                    ),
                    new ListTile(
                      leading: new Icon(FontAwesomeIcons.globeAmericas, color: Colors.white),
                      title: new Text("Sito Web", style: new TextStyle(color: Colors.white)),
                      onTap: () => drawerTilePressed(ScreenType.SitoWeb),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.contact_mail, color: Colors.white),
                      title: new Text("Contattaci", style: new TextStyle(color: Colors.white)),
                      onTap: () => drawerTilePressed(ScreenType.Contattaci),
                    ),
                    new Divider(),
                  ],
                ),
                new Align(child: new Text("App creata da 4loris4@gmail.com", style: new TextStyle(color: Colors.grey)), alignment: Alignment.bottomLeft)
              ],
            )
          ),
        )
      )
    );
  }

  void setScreen(ScreenType screenType) {
    Widget screen;
    Widget appBarTitle = new Image.asset("assets/logoTitle.png", height: 45);

    switch (screenType) {
      case ScreenType.Radio:
        screen = new RadioTab();
        appBarTitle = new Image.asset("assets/logoTitle.png", height: 45);
        break;
      case ScreenType.Archivio:
        screen = new ArchivioTab();
        appBarTitle = new Text("Archivio", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white));
        break;
      case ScreenType.Webcam:
        screen = new WebcamTab();
    appBarTitle = new Text("Webcam", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white));
        break;
      case ScreenType.Contattaci:
        screen = new ContattaciTab();
    appBarTitle = new Text("Contattaci", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white));
        break;
      default:
        print("Invalid ScreenType passed to setScreen() function!");
        break;
    }
    setState(() {
      this.currentScreen = screen;
      currentScreenType = screenType;
      this.appBarTitle = appBarTitle;
    });
  }

  void drawerTilePressed(ScreenType btnType) {
    Navigator.of(context).pop();

    switch (btnType) {
      case ScreenType.Youtube:
        openWebsite("https://www.youtube.com/channel/UCkJssIWpAzIgeZfDeLf3etw");
        return;
      case ScreenType.SitoWeb:
        openWebsite("https://radioanaunia.it/");
        return;
      case ScreenType.Radio:
      case ScreenType.Archivio:
      case ScreenType.Webcam:
      case ScreenType.Contattaci:
        setScreen(btnType);
        break;
      default:
        print("Invalid ScreenType passed to drawerTilePressed() function!");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() => setScreen(currentScreenType));

    audioPlayer.onPlayerStateChanged.listen((playerState) {
      setState(() => buffering = (playerState != AudioPlayerState.PLAYING));
      if(playerState == AudioPlayerState.PLAYING && paused) {
        audioPlayer.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: secondaryColror
      ),
      body: currentScreen,
      drawer: navigationDrawer(),
    );
  }
}

void openWebsite(String url) async {
  if (url.startsWith("http") || url.startsWith("https")) {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
            toolbarColor: backgroundColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
            animation: CustomTabsAnimation.fade()
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  else {
    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    }
  }
}
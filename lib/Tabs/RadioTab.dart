import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:radioanaunia/main.dart';
import 'package:http/http.dart' as http;
import 'ArchivioTab.dart';

class RadioTab extends StatefulWidget {
  @override
  RadioTabState createState() => new RadioTabState();
}

String coverURL = "https://s6.mediastreaming.it/9134/html5/skin/default.png";
String trackName = "";
String authorName = "";
Color coverColor = Colors.black26;

class RadioTabState extends State<RadioTab> {

  Audio radio = new Audio("https://s6.mediastreaming.it/m/9134?ext=.mp3");
  int screenWidthLetters = 0;
  ScrollController controller = ScrollController();

  List<double> coverSize = [225, 275];
  List<Duration> coverAnimationDuration = [new Duration(milliseconds: 500), new Duration(milliseconds: 1500)];
  List<Curve> coverAnimation = [Curves.ease, Curves.elasticOut];
  Timer coverUpdateTimer;
  Timer titleScroller;

  @override
  void initState() {
    super.initState();
    initTitleScroller();
    loadCover();
    coverUpdateTimer = Timer.periodic(new Duration(seconds: 20), (_) => loadCover());
  }

  @override
  void dispose() {
    super.dispose();
    coverUpdateTimer?.cancel();
    titleScroller?.cancel();
  }

  void initTitleScroller() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool scrollToEnd = true;
      titleScroller?.cancel();

      titleScroller = new Timer.periodic((new Duration(milliseconds: 2000+50*trackName.length)), (_) {
        if(controller.hasClients) {
          controller.animateTo(scrollToEnd ? controller.position.maxScrollExtent : 0, duration: new Duration(milliseconds: 50*trackName.length), curve: Curves.linear);
        }
        scrollToEnd = !scrollToEnd;
      });
    });
    setState(() {});
  }

  void setTrackName(String name) {
    setState(() {
      trackName = name;
    });
    titleScroller?.cancel();
    controller.animateTo(0, duration: new Duration(milliseconds: 250), curve: Curves.easeOut).then((_) => initTitleScroller());
  }

  void loadCover() async {
    http.Response response;
    try { response = await http.get("https://s6.mediastreaming.it/9134/html5/onairtxt.php", headers: {"Accept": "application/json"}); } on Exception { return; }
    if (response != null) {
      String title = toTitleCase(response.body.substring(response.body.indexOf("=")+1));
      setState(() {
        authorName = title.split(" - ").length > 1 ? title.split(" - ")[0] : "";
        setTrackName(title.split(" - ").length > 1 ? title.split(" - ")[1] : title);
      });
      try { response = await http.get("https://itunes.apple.com/search?media=music&country=us&term=${title.toUpperCase().replaceAll(" ", "+")}", headers: {"Accept": "application/json"}); } on Exception { return; }
      if(title.toUpperCase() == "IN CONDOTTA" || title.toUpperCase() == "ORA ESATTA") {
        coverURL = "https://s6.mediastreaming.it/9134/html5/skin/default.png";
      }
      else {
        try {
          coverURL = jsonDecode(response.body)["results"][0]["artworkUrl100"];
        }
        catch(Exception) {
          coverURL = "https://s6.mediastreaming.it/9134/html5/skin/default.png";
        }
      }
      updateCover();
    }
  }

  String toTitleCase(String string) {
    String tmpString = string.toLowerCase();
    String match = " -.0123456789";
    List<String> substrings;

    for(int i = 0; i < match.length; i++) {
      substrings = tmpString.split(match[i]);
      for(int i = 0; i < substrings.length && substrings.length > 0; i++) {
        try {
          substrings[i] = substrings[i][0].toUpperCase() + substrings[i].substring(1);
        }
        catch(Exception) {}
      }
      tmpString = substrings.join(match[i]);
    }

    return tmpString;
  }

  void updateCover() {
    if(coverURL == "https://s6.mediastreaming.it/9134/html5/skin/default.png" || coverURL == "") {
      setState(() {
        coverColor = Colors.black26;
      });
    }
    else {
      try {
        PaletteGenerator.fromImageProvider(NetworkImage(coverURL)).then((paletteGenerator) {
          if(paletteGenerator.dominantColor?.color != null && paletteGenerator.dominantColor?.color != coverColor) {
            if(mounted) {
              setState(() => coverColor = paletteGenerator.dominantColor?.color);
            }
          }
        });
      }
      catch(Exception) {
        setState(() {
          coverColor = Colors.black26;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidthLetters = (MediaQuery.of(context).size.width - 40) ~/ 13;

    return new Scaffold(
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: new AnimatedContainer(color: coverColor, duration: new Duration(milliseconds: 500), child: new Center(
                child: new ClipRRect(
                  borderRadius: new BorderRadius.circular(15.0),
                  child: new AnimatedContainer(
                      width: coverSize[currentlyPlaying != radio.url ? 0 : 1],
                      height: coverSize[currentlyPlaying != radio.url ? 0 : 1],
                      color: Colors.white,
                      duration: coverAnimationDuration[currentlyPlaying != radio.url ? 0 : 1],
                      curve: coverAnimation[currentlyPlaying != radio.url ? 0 : 1],
                      child: new FadeInImage.assetNetwork(placeholder: "assets/coverDefault.png", image: coverURL, fadeInDuration: new Duration(milliseconds: 250), fit: BoxFit.fill)
                  ),
                ),
              )),
            ),
            new Container(
              padding: new EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              color: backgroundColor,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: new ListView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        new Text(trackName, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
                      ],
                    ),
                    height: 30,
                  ),
                  new Text(authorName, style: new TextStyle(fontSize: 20, color: Colors.grey)),
                  new Center(child: new IconButton(padding: new EdgeInsets.all(0), icon: new Icon(currentlyPlaying != radio.url ? Icons.play_arrow : Icons.stop , color: Colors.white), iconSize: 60, onPressed: (){
                    setState(() {
                      paused = false;
                      currentlyPlaying = currentlyPlaying == radio.url ? "" : radio.url;
                    });
                    updateRadio();
                  })),
                ],
              )
            ),
          ],
        )
    );
  }
}
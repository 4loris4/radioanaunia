import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';

class ArchivioTab extends StatefulWidget {
  @override
  ArchivioTabState createState() => new ArchivioTabState();
}

class Audio {
  String url;
  double progress = 0;
  double duration = 0;

  Audio(this.url);
}

final List<Audio> doiCiacoleDreAlNosAudio = [new Audio("https://radioanaunia.it/archivio/doiciacole_1.mp3"), new Audio("https://radioanaunia.it/archivio/doiciacole_2.mp3")];
final List<Audio> tempoRealeAudio = [new Audio("https://radioanaunia.it/archivio/TEMPOREALE01.mp3"), new Audio("https://radioanaunia.it/archivio/TEMPOREALE02.mp3")];
final Audio notizieAppuntamentiAudio = new Audio("https://radioanaunia.it/archivio/notizie_appuntamenti.mp3");

ArchivioTabState archivioState;
bool archivioShouldUpdate = false;
StreamSubscription<Duration> durationListener;

class ArchivioTabState extends State<ArchivioTab> with AutomaticKeepAliveClientMixin<ArchivioTab> {

  void updateArchivioState(Audio audio) {
    durationListener?.cancel();
    Future<Null> stopTimer;
    durationListener = audioPlayer.onAudioPositionChanged.listen((progress) {
      if(audio.duration == 0) {
        audio.duration = audioPlayer.duration.inSeconds.toDouble();
      }

      if(archivioShouldUpdate) {
        archivioState?.setState(() => audio.progress = progress.inSeconds.toDouble());
      }
      else {
        audio.progress = progress.inSeconds.toDouble();
      }

      if(stopTimer == null && audio.duration > 0 && audio.progress >= audio.duration) {
        stopTimer = Future.delayed(new Duration(seconds: 1), () {
          audio.progress = 0;
          if(archivioShouldUpdate) {
            setState(() {
              paused = false;
              currentlyPlaying = "";
            });
          }
          else {
            paused = false;
            currentlyPlaying = "";
          }
          updateRadio();
          stopTimer = null;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    archivioState = this;
    archivioShouldUpdate = true;
  }

  @override
  void dispose() {
    super.dispose();
    archivioShouldUpdate = false;
  }

  Widget audioPlayerWidget(Audio audio) {
    return new ListTile(
      leading: new Stack(
        alignment: new Alignment(0, 0),
        children: <Widget>[
          new IconButton(icon: new Icon(audio.url == currentlyPlaying && !paused ? Icons.pause : Icons.play_arrow, color: Colors.white), iconSize: 30, onPressed: () {
            buffering = true;
            setState(() {
              paused = (currentlyPlaying == audio.url && !paused);
              currentlyPlaying = audio.url;
            });
            updateRadio(progress: audio.progress);
            updateArchivioState(audio);
          }),
          new IgnorePointer(child: new Opacity(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)), opacity: audio.url == currentlyPlaying && !paused && buffering ? 1 : 0))
        ]
      ),
      title: new Slider(
        min: 0,
        max: audio.duration,
        value: max(0, min(audio.progress, audio.duration)),
        onChanged: (value) {
          setState(() => audio.progress = value);
          if(currentlyPlaying == audio.url && !paused) {
            audioPlayer.seek(value);
          }
        },
        activeColor: Colors.white,
        inactiveColor: Colors.black,
      ),
      trailing: new Text(audio.duration == 0 ? "--:--" : "‒${((audio.duration - audio.progress)~/60).abs().toString()}:${((audio.duration - audio.progress).abs()%60).toInt() < 10 ? "0" : ""}${((audio.duration - audio.progress).abs()%60).toInt().toString()}",
          style: new TextStyle(color: Colors.white)
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      backgroundColor: backgroundColor,
      body: new ListView(
        children: <Widget>[
          new ListTile(title: new Text("Doi ciacole dre al Nos", style: new TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))),
          audioPlayerWidget(doiCiacoleDreAlNosAudio[0]),
          audioPlayerWidget(doiCiacoleDreAlNosAudio[1]),
          new ListTile(title: new Text("Tempo reale", style: new TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))),
          audioPlayerWidget(tempoRealeAudio[0]),
          audioPlayerWidget(tempoRealeAudio[1]),
          new ListTile(title: new Text("Notizie ed appuntamenti", style: new TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold))),
          audioPlayerWidget(notizieAppuntamentiAudio),
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radioanaunia/main.dart' as prefix0;
import 'package:transparent_image/transparent_image.dart';

class WebcamTab extends StatefulWidget {
  @override
  WebcamTabState createState() => new WebcamTabState();
}

class WebcamTabState extends State<WebcamTab> {

  final String webcam1URL = "https://radioanaunia.it/webcam/cam_1.jpg";
  final String webcam2URL = "https://radioanaunia.it/webcam/cam_2.jpg";

  @override
  void initState() {
    super.initState();

    Timer.periodic(new Duration(minutes: 5), (_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return new Scaffold(
      backgroundColor: prefix0.backgroundColor,
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: new SizedBox(
                      width: screenWidth * .75,
                      child: new Stack(
                        alignment: new Alignment(0, 0),
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Stack(
                            alignment: new Alignment(0, 1),
                            children: <Widget>[
                              new FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: webcam1URL+"?t="+DateTime.now().toString(), fadeInDuration: new Duration(milliseconds: 100), fit: BoxFit.fill),
                              new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text("Webcam sulla Montagna di Cles", style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, background: Paint()..color = Colors.black54), textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: new SizedBox(
                      width: screenWidth * .75,
                      child: new Stack(
                        alignment: new Alignment(0, 0),
                        children: <Widget>[
                          new CircularProgressIndicator(),
                          new Stack(
                            alignment: new Alignment(0, 1),
                            children: <Widget>[
                              new FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: webcam2URL+"?t="+DateTime.now().toString(), fadeInDuration: new Duration(milliseconds: 100), fit: BoxFit.fill),
                              new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text("Webcam sulla Piazza Granda (Cles)", style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, background: Paint()..color = Colors.black54), textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Align(
            alignment: new Alignment(1, -1),
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new FloatingActionButton(
                backgroundColor: prefix0.secondaryColror,
                child: new Icon(Icons.refresh),
                onPressed: () => setState(() {})
              ),
            ),
          )
        ],
      ),
    );
  }
}

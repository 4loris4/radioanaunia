import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioanaunia/main.dart' as prefix0;

import '../main.dart';

class ContattaciTab extends StatefulWidget {
  @override
  ContattaciTabState createState() => new ContattaciTabState();
}

class ContattaciTabState extends State<ContattaciTab> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: prefix0.backgroundColor,
      body: SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text("Radio Anaunia Società Cooperativa\nVia Martini, 3\n38023 Cles (TN)\nPartita IVA 00376950226", style: new TextStyle(fontSize: 16, color: Colors.white)),
            ),
            new ListTile(
              leading: new Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                new Icon(Icons.phone, size: 30, color: Colors.white)
              ]),
              title: new Text("Info", style: new TextStyle(color: Colors.white)),
              subtitle: new Text("+39 0463422155", style: new TextStyle(color: Colors.white)),
              onTap: () => openWebsite("tel:+390463422155"),
            ),
            new ListTile(
              leading: new Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                new Icon(Icons.phone, size: 30, color: Colors.white)
              ]),
              title: new Text("Diretta", style: new TextStyle(color: Colors.white)),
              subtitle: new Text("+39 0463730002", style: new TextStyle(color: Colors.white)),
              onTap: () => openWebsite("tel:+390463730002"),
            ),
            new ListTile(
              leading: new Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                new Icon(Icons.smartphone, size: 30, color: Colors.white)
              ]),
              title: new Text("SMS", style: new TextStyle(color: Colors.white)),
              subtitle: new Text("+39 3493346823", style: new TextStyle(color: Colors.white)),
              onTap: () {
                Clipboard.setData(new ClipboardData(text: "3493346823"));
                Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Numero copiato negli appunti")));
              }
            ),
            new ListTile(
              leading: new Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                new Icon(Icons.email, size: 30, color: Colors.white)
              ]),
              title: new Text("Email Direzione", style: new TextStyle(color: Colors.white)),
              subtitle: new Text("gabos@radioanaunia.it", style: new TextStyle(color: Colors.white)),
              onTap: () => openWebsite("mailto:gabos@radioanaunia.it"),
            ),
            new ListTile(
              leading: new Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                new Icon(Icons.email, size: 30, color: Colors.white)
              ]),
              title: new Text("Email", style: new TextStyle(color: Colors.white)),
              subtitle: new Text("info@radioanaunia.it", style: new TextStyle(color: Colors.white)),
              onTap: () => openWebsite("mailto:info@radioanaunia.it"),
            ),
            new ListTile(
              leading: new Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                new Icon(FontAwesomeIcons.facebookSquare, size: 30, color: Colors.white)
              ]),
              title: new Text("Facebook", style: new TextStyle(color: Colors.white)),
              subtitle: new Text("radioanaunia", style: new TextStyle(color: Colors.white)),
              onTap: () => openWebsite("https://it-it.facebook.com/radioanaunia/"),
            ),
          ],
        ),
      ),
    );
  }
}

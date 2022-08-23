import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioanaunia/utils_functions.dart';

class ContattaciTab extends StatelessWidget {
  const ContattaciTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PadColumn(
          padding: EdgeInsets.all(16),
          spacing: 10,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: const [
                  TextSpan(text: "Radio Anaunia\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "Via Martini, 3\n"),
                  TextSpan(text: "38023 Cles (TN)"),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: "Proprietà:\n",
                style: TextStyle(color: Colors.white),
                children: const [
                  TextSpan(text: "Azienda per il Turismo Val di Non\n", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "Via Roma, 21\n"),
                  TextSpan(text: "38013 Borgo d'Anaunia (TN)\n"),
                  TextSpan(text: "Partita IVA: 01899140220\n"),
                  TextSpan(text: "Tel: +39 0463830133"),
                ],
              ),
            ),
          ],
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.call, color: Colors.white)),
          title: Text("Info", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("+39 0463422155", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("tel:+390463422155"),
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.call, color: Colors.white)),
          title: Text("Diretta", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("+39 0463730002", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("tel:+390463730002"),
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.sms, color: Colors.white)),
          title: Text("SMS", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("+39 3493346823", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("sms:+393493346823"),
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.mail, color: Colors.white)),
          title: Text("Email Ufficio commerciale/Segreteria", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("gabos@radioanaunia.it", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("mailto:gabos@radioanaunia.it"),
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.mail, color: Colors.white)),
          title: Text("Email Amministrazione", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("amministrazione@radioanaunia.it", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("mailto:amministrazione@radioanaunia.it"),
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.mail, color: Colors.white)),
          title: Text("Email Informazioni", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("info@radioanaunia.it", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("mailto:info@radioanaunia.it"),
        ),
        ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(FontAwesomeIcons.facebook, color: Colors.white)),
          title: Text("Facebook", style: TextStyle(color: Colors.white, fontSize: 15)),
          subtitle: Text("radioanaunia", style: TextStyle(color: Colors.white.withOpacity(.6), fontSize: 12)),
          onTap: () => openUrl("https://www.facebook.com/radioanaunia"),
        ),
      ],
    );
  }
}

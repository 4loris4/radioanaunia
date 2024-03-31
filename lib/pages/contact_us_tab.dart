import 'package:flutter/material.dart';
import 'package:flutter_series/flutter_series.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioanaunia/main.dart';
import 'package:radioanaunia/tabs.dart';
import 'package:radioanaunia/utils_functions.dart';

class ContactUsTab extends StatelessWidget {
  static final widget = TabActionWidget(
    title: (context) => lang(context).tabContactUs,
    icon: Icons.contact_mail,
    widget: const ContactUsTab(),
  );

  const ContactUsTab({super.key});

  static final _values = <({IconData icon, String Function(BuildContext context) title, String subtitle, String url})>[
    (
      icon: Icons.call,
      title: (context) => lang(context).contactInfo,
      subtitle: "+39 0463422155",
      url: "tel:+390463422155",
    ),
    (
      icon: Icons.call,
      title: (context) => lang(context).contactLive,
      subtitle: "+39 0463730002",
      url: "tel:+390463730002",
    ),
    (
      icon: Icons.sms,
      title: (context) => lang(context).contactSMS,
      subtitle: "+39 3493346823",
      url: "sms:+393493346823",
    ),
    (
      icon: Icons.mail,
      title: (context) => lang(context).contactEmailCommercial,
      subtitle: "gabos@radioanaunia.it",
      url: "mailto:gabos@radioanaunia.it",
    ),
    (
      icon: Icons.mail,
      title: (context) => lang(context).contactEmailAdministration,
      subtitle: "amministrazione@radioanaunia.it",
      url: "mailto:amministrazione@radioanaunia.it",
    ),
    (
      icon: Icons.mail,
      title: (context) => lang(context).contactEmailInfo,
      subtitle: "info@radioanaunia.it",
      url: "mailto:info@radioanaunia.it",
    ),
    (
      icon: FontAwesomeIcons.facebook,
      title: (context) => lang(context).contactFacebook,
      subtitle: "radioanaunia",
      url: "https://www.facebook.com/radioanaunia",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const PadColumn(
          padding: EdgeInsets.all(16),
          spacing: 8,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Radio Anaunia", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Via Martini, 3"),
                Text("38023 Cles (TN)"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Proprietà:"),
                Text("Azienda per il Turismo Val di Non", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Via Roma, 21"),
                Text("38013 Borgo d'Anaunia (TN)"),
                Text("Partita IVA: 01899140220"),
                Text("Tel: +39 0463830133"),
              ],
            ),
          ],
        ),
        ..._values.map((value) {
          return ListTile(
            leading: SizedBox(height: double.infinity, child: Icon(value.icon)),
            title: Text(value.title(context), style: const TextStyle(fontSize: 15)),
            subtitle: Text(
              value.subtitle,
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(.66), fontSize: 12),
            ),
            onTap: () => openUrl(value.url),
          );
        }),
      ],
    );
  }
}

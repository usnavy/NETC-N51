import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Urls {
  var _hover = false;
  static Future openLink({
    required String url,
  }) =>
      _launchUrl(url);

  static Future openEmail({
    required String toEmail,
    required String subject,
    required String body,
  }) async {
    final url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    await _launchUrl(url);
  }

  static TextSpan createUrl({String url = '', String txt = 'website', required BuildContext context}) {
    return TextSpan(
        style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.underline,
        ),
        text: txt,
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (await canLaunch(url)) {
              await launch(url);
            } else if (kIsWeb) {
              throw 'Could not launch $url';
            } else {
              await launch(url);
            }
          });
  }

  static Future openPhoneCall({required String phoneNumber}) async {
    final url = 'tel:$phoneNumber';

    await _launchUrl(url);
  }

  static Future openSMS({required String phoneNumber}) async {
    final url = 'sms:$phoneNumber';

    await _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

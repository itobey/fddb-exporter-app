import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncher {
  static Future<void> launchProductUrl(String productLink) async {
    final url = 'https://fddb.info$productLink';
    if (await canLaunchUrlString(url)) {
      try {
        await launchUrlString(url);
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error launching URL: $e',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Could not launch $url',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

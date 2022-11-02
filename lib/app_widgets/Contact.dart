import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../modules/Files.dart';

class Contact extends StatefulWidget {

  @override
  _Contact createState() => _Contact();
}
class _Contact extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.purple,
                    Colors.purpleAccent,
                  ],
                  stops: [0.2,0.6]
              ),
          ),
        ),
        title: Text('contact'.tr),
      ),
body:WebView(initialUrl:language.val=='ar'?"https://spearsupport.zendesk.com/hc/ar/requests/new":
"https://spearsupport.zendesk.com/hc/en-gb/requests/new" ,
  javascriptMode:JavascriptMode.unrestricted ,
));
  }
}
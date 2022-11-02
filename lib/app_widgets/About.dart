import '../modules/Files.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
var l;
class About extends StatefulWidget {
  final String dad;
  const About({@required this.dad, Key key}) : super(key: key);
  @override
  _About createState() => _About();
}
class _About extends State<About> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
          }, icon:const Icon(Icons.arrow_back)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient:const  LinearGradient(
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
        title:Text('Important Information'.tr),
      ),
      body: WebView(initialUrl:widget.dad ,
        javascriptMode:JavascriptMode.unrestricted ,
      ),
    );
  }
}

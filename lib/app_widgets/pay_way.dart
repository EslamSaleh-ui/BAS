import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import '../modules/Files.dart';

class pay_way extends StatefulWidget {
  @override
  State<pay_way> createState() => _pay_way();
}
class _pay_way extends State<pay_way> {
  final data  d=Get.put(data());
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Pay'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.purple,
                    Colors.purpleAccent,
                  ],
                  stops: [0.2, 0.6]
              ),
            ),
          ),
        ),
        body: Center(child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple ,
                onPrimary: Colors.white, shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
                minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
              ), onPressed: ()async {await d.makePayment();},
              child: Row(children: [
                Icon(FontAwesomeIcons.ccMastercard, size: Adaptive.sp(25),
                  color: Colors.white,),
                Text('    Pay using bank card', style: TextStyle(
                    fontSize: Adaptive.sp(18), color: Colors.white),)
              ]    ))
          ]   ))
        )
    );
  }
}
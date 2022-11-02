import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/Email.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import '../modules/Files.dart';

class Resete extends StatefulWidget {
  @override
  State<Resete> createState() => _Resete();
}

class _Resete extends State<Resete> {
  var u=TextEditingController(),t=TextEditingController();
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
              Get.to(()=>Second());
            },),
            title: Text('Reset Password'),
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
          ),
          body: Form(
              key: k,
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center ,

                        children:  [
                          Padding(padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),  child:
                          TextFormField(
                            controller: u,
                            validator: Files().Error,
                            decoration:  InputDecoration(
                              hintText: 'Enter Email'.tr,
                              focusColor: Colors.black,
                              hoverColor: Colors.black,
                            ),
                          )),
    ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.teal ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ),onPressed: () async{
                            Files().load(context);
                            if(k.currentState.validate() )
                            {
                              try {
                                await i.sendPasswordResetEmail(
                                    email: u.text);
                                await  observer.analytics.logEvent(name: 'Email_reset');

                                Toast.show('Verification'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                              }
                              on FirebaseAuthException
                              catch( e) {
                                Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );
                              }
                            }
                          }, child: Text('Reset'.tr,style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal)))
                          ,        ],
                      )) ) )
    );
  }
}

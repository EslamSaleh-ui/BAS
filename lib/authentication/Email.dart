import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:flutter_app/authentication/Registere.dart';
import 'package:flutter_app/authentication/resete.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import '../app_widgets/About.dart';
import '../app_widgets/MyHomePage.dart';
import 'Sign.dart';

class Second extends StatefulWidget {
  @override
  State<Second> createState() => _Second();
}

class _Second extends State<Second> {
  final js=true.obs;
  var u=TextEditingController();
  var t=TextEditingController();
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
           Get.back();
            },),
            title: Text('login'.tr),
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
          body:Center(child: Form(
              key: k,
              child: Center(
                  child:SingleChildScrollView(child: Column(
                        children:  [
                          Padding(padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),  child:
                          TextFormField(
                            controller: u,
                            keyboardType: TextInputType.emailAddress,
                            validator: Files().Error,
                            decoration:  InputDecoration(
                                hintText: 'Enter Email'.tr,
                                focusColor: Colors.black,
                                hoverColor: Colors.black,
                            ),
                          )),
                          Padding(padding:const EdgeInsets.only(left: 20,right: 20,bottom: 20) ,child:
                         Obx(()=>TextFormField(
                           obscureText:js.value==true?true:false,
                           controller: t,
                           validator: Files().ErrorP,
                           decoration:  InputDecoration(
                               hintText: "password".tr,
                               focusColor: Colors.black,
                               hoverColor: Colors.black,
                               suffixIcon: IconButton(onPressed:(){
                                 js.toggle();
                               }, icon:Obx(()=>js.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                               Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) ))
                           ),
                         )) ,),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: EdgeInsets.only(left: 10),child: TextButton(onPressed: (){
                            Get.to(()=> Resete());
                          }, child: Text('f_password'.tr,style: TextStyle(color: Colors.blue.shade500,fontSize: 20),)),),],),
    ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.teal ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ),onPressed: () async{
                            Files().load(context);
                            if(k.currentState.validate())
                            {
                              try {
                                await i.signInWithEmailAndPassword(
                                    email: u.text, password: t.text);
                                Get.offAll(()=> MyHomePage());
                                Files().After_login();
                                await observer.analytics.setUserProperty(name:i.currentUser.displayName.isEmpty?'user':i.currentUser.displayName.replaceAll(RegExp(' '),'_'),value:i.currentUser.uid );
                                setState(() {
                                  gg=1;
                                });
                              }
                              on FirebaseAuthException
                              catch( e) {
                                Toast.show(e.code.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                              }
                            }
                          }, child: Text('login'.tr,style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal)), )
                          ,           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: EdgeInsets.only(left: 10),child:TextButton(child: Text("question".tr,style: TextStyle(color: Colors.black,fontSize: 20),)),), TextButton(onPressed: (){
                            Get.to(()=>Registere());
                          }, child: Text('register'.tr,style: TextStyle(color: Colors.blue.shade500,fontSize: Adaptive.sp(20)),),
                          ),
                          ],),
                          Text('by'.tr,style: TextStyle(fontSize: Adaptive.sp(20),fontWeight: FontWeight.bold),),
                          TextButton(onPressed: () {
                            Get.to(()=>About(dad:language.val=='ar'?"https://spearsupport.zendesk.com/hc/ar/articles/5406629067421"
                                "-%D8%B4%D8%B1%D9%88%D8%B7-%D8%A7%D8%B3%D8%AA%D8%AE%D8%AF%D8%A7%D9%85-%D9%85%D9%88%D9%82%D8%B9-%D8%A8%D8%A7%D8%B3":
                            "https://spearsupport.zendesk.com/hc/en-gb/articles/5409722477981-What-are-Terms-of-Use-" ));
                          } ,child: Text('terms'.tr,style: TextStyle(color: Colors.blue.shade500,fontSize: Adaptive.sp(20)),)),
                          Text('and'.tr,style: TextStyle(fontSize: Adaptive.sp(20),fontWeight: FontWeight.bold),),
                          TextButton(onPressed: () {
                            Get.to(()=>About(dad:language.val=='ar'?"https://spearsupport.zendesk.com/hc/ar/articles/5406702219293"
                                "-%D8%B3%D9%8A%D8%A7%D8%B3%D8%A9-%D8%A7%D9%84%D8%AE%D8%B5%D9%88%D8%B5%D9%8A%D8%A9":
                            "https://spearsupport.zendesk.com/hc/en-gb/articles/5409689164445-What-are-Privacy-Policies-" ));
                          } ,child: Text('Privacy Policy'.tr,style: TextStyle(color: Colors.blue.shade500,fontSize: Adaptive.sp(20)),))],
                      ))  ))
    ));
  }


}

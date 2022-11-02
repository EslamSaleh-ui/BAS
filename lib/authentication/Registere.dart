import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/Email.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class Registere extends StatefulWidget {
  @override
  State<Registere> createState() => _Registere();
}

class _Registere extends State<Registere> {
  final j=true.obs;
  var id,u=TextEditingController(),
   t=TextEditingController();
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
              Get.off(()=>Second());
            },),
            title: Text('Register Email'.tr),
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
                  child: ListView(
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
                          Padding(padding:const EdgeInsets.only(left: 20,right: 20,bottom: 20) ,child:
                       Obx(()=>TextFormField(
                         obscureText:j.value==true?true:false,
                         controller: t,
                         validator: Files().ErrorP,
                         decoration:  InputDecoration(
                             hintText: 'password'.tr,
                             focusColor: Colors.black,
                             hoverColor: Colors.black,
                             suffixIcon: IconButton(onPressed:(){
                               j.toggle();

                             }, icon:Obx(()=>j.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                             Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) ) )
                         ),
                       ))   ),
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
                                await i.createUserWithEmailAndPassword(
                                    email: u.text, password: t.text).then((value) async{
                                await  i.currentUser.sendEmailVerification();
                                      Toast.show('Verification'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                                });
                                await  observer.analytics.logEvent(name: 'signup_email');
                                email();
                                Get.off(()=>Second());
                              }
                              on FirebaseAuthException
                              catch( e) {
                                Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );
                              }
                            }
                          }, child: Text('register'.tr,style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal)))
                          ,        ],
                      ))  )
    );
  }
  void email()async
  {  await ff..collection('/users').doc(i.currentUser.uid).set(
      {
        'email':i.currentUser.email,
        'number':i.currentUser.phoneNumber==null?'00000':i.currentUser.phoneNumber,
        'favourites':[],
        'searches':[],
        'location':'0',
        'member_date':FieldValue.serverTimestamp()
      }
  );}
}

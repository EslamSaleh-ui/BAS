import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:flutter_app/app_widgets/MyHomePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import 'Sign.dart';

class Phonep extends StatefulWidget {
  @override
  State<Phonep> createState() => _Phonep();
}
class _Phonep extends State<Phonep> {
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  var n=TextEditingController(), d=TextEditingController();
  final jk=true.obs;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
                  appBar: AppBar(
                      leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
                       Get.back();
                        setState(() {
                          vn=0;
                        });
                      },),
                    title: Text('Verify Password'),
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
              body:
              Form(
                key: k,
                child:SingleChildScrollView(child:  Column(children: [
                  Padding(padding: EdgeInsets.only(top:Adaptive.h(12),left: Adaptive.w(5),right: Adaptive.w(5) ),
                      child:Obx(()=>TextFormField(
                        obscureText:jk.value==true?true:false,
                        controller: n,
                        validator: Files().ErrorP,
                        decoration:  InputDecoration(
                            hintText: 'Enter Password',
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            suffixIcon: IconButton(onPressed:(){
                              jk.toggle();
                            }, icon:Obx(()=>jk.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                            Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) ))
                        ),
                      ) )),
                  Padding(padding: EdgeInsets.only(top:Adaptive.h(6),left: Adaptive.w(5),right: Adaptive.w(5),bottom: Adaptive.h(6) ),
                      child:Obx(()=>TextFormField(
                        obscureText:jk.value==true?true:false,
                        controller: d,
                        validator: Files().ErrorP,
                        decoration:  InputDecoration(
                            hintText: 'Confirm Password',
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                            suffixIcon: IconButton(onPressed:(){
                              jk.toggle();
                            }, icon:Obx(()=>jk.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                            Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) ) )
                        ),
                      ) )   ),
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
                        if(n.text==d.text)
                          { await i.currentUser.updatePassword(n.text);
                          await  observer.analytics.logEvent(name: 'update_password');
                          if(vn==1)
                            {
                              EmailAuthCredential kn=EmailAuthProvider.credential(email: i.currentUser.phoneNumber +'@gmail.com', password:n.text);
                              await i.currentUser.linkWithCredential(kn);
                              Toast.show('Password Updated',gravity: Toast.bottom,duration:Toast.lengthLong );
                              Get.offAll(()=>MyHomePage());}
                          else{
                            Get.offAll(()=>Fetch());
                            Toast.show('Password Updated',gravity: Toast.bottom,duration:Toast.lengthLong );
                          }
                          setState(() {
                            vn=0;
                          });
                          }
                       else
                         {
                           Toast.show('Fields are not identical',gravity: Toast.bottom,duration:Toast.lengthLong );}

                      }
                      on FirebaseAuthException
                      catch( e) {
                        Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );
                      }
                    }
                  }, child: Text('Ok',style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal)))
                ],) ) ,
              )
          );
  }
}

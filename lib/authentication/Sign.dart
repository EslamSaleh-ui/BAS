// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import '../app_widgets/About.dart';
import '../app_widgets/MyHomePage.dart';
import 'Phone.dart';
var p;
int vn=0,gg=0;
class Fetch extends StatefulWidget {
  @override
  State<Fetch> createState() => _Fetch();
}
class _Fetch extends State<Fetch> {
  final jk=true.obs;
  var u=TextEditingController(),t=TextEditingController();
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  PhoneNumber phoneNumber;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
                Get.off(()=>MyHomePage());
                setState(() {
                  vn=0;
                });
              },),
              title: Text("login".tr,style:TextStyle(fontSize:Adaptive.sp(20))),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient:const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.purple,
                          Colors.purpleAccent,],
                        stops: [0.2,0.6]
                    ),
                ),
              ),
            ),
            body:Center(
             child:Form(
                key: k,
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children:  [
                            Padding(padding:  EdgeInsets.only(top:Adaptive.sp(20), left:Adaptive.sp(20),right:Adaptive.sp(20),bottom: Adaptive.sp(20)),  child:
                            TextFormField(
                              keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                              controller: u,
                              validator: Files().Errorph,
                              decoration:  InputDecoration(
                                labelText: "phone".tr,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      u.text=' ';
                                    });
                                  },
                                ),
                                hintText: "phone".tr,
                                  focusColor: Colors.black,
                                  hoverColor: Colors.black,
                              ),
                            )),
                            Padding(padding: EdgeInsets.only(left:Adaptive.sp(20),right:Adaptive.sp(20),bottom: Adaptive.sp(20)) ,child:
                          Obx(()=> TextFormField(
                            obscureText:jk.value==true?true:false,
                            controller: t,
                            validator: Files().ErrorP,
                            decoration:  InputDecoration(
                                labelText: "password".tr,
                                hintText: "password".tr,
                                focusColor: Colors.black,
                                hoverColor: Colors.black,
                                suffixIcon: IconButton(onPressed:(){
                                  jk.toggle();
                                }, icon:Obx(()=>jk.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                                Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) )) ),
                          )) ),
                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: EdgeInsets.only(left: 10),child: TextButton(onPressed: (){
                              setState(() {
                                vn=2;
                              });
                              Get.to(()=>Phone());
                            }, child: Text('f_password'.tr,style: TextStyle(color: Colors.blue.shade500,fontSize: Adaptive.sp(20)),)),),],),
                            Padding(padding:  EdgeInsets.only(top:Adaptive.sp(20), left:Adaptive.sp(20),right:Adaptive.sp(20),bottom: Adaptive.sp(15)),child:
                            ElevatedButton( style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/2,MediaQuery.of(context).size.width/7 ) //////// HERE
    ),onPressed: ()async{
                                  String springFieldUSASimple = '+'+vs.val+u.text;
                                  try{
                                     phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
                                     if(k.currentState.validate())
                                     {
                                       try
                                       {
                                         Files().load(context);
                                        EmailAuthCredential kn=EmailAuthProvider.credential(email: '+'+vs.val+phoneNumber.nationalNumber+'@gmail.com', password:t.text);
                                         await i.signInWithCredential(kn);
                                         box.write('login','phone' );
                                         Files().After_login();
                                         Get.off(()=>MyHomePage());
                                       }
                                       on FirebaseAuthException
                                       catch( e) {
                                         Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );
                                       }
                                     }
                                  }
                                  on Exception catch(e){
                                    Toast.show('Invalid Phone Number'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                                  }
                            }, child: Text("login".tr,style:TextStyle(color: Colors.white,fontSize: Adaptive.sp(20),fontWeight: FontWeight.normal)) ))
                            ,           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: EdgeInsets.only(left: 10),child:TextButton(child: Text("question".tr,style: TextStyle(color: Colors.black,fontSize:  Adaptive.sp(20)),)),), TextButton(onPressed: (){
                                     setState(() {
                                       vn=1;
                                     });
                                     Get.to(()=>Phone());
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
                            } ,child: Text('Privacy Policy'.tr,style: TextStyle(color: Colors.blue.shade500,fontSize: Adaptive.sp(20)),))
                          ],
                        )) ) ) ));
  }

}







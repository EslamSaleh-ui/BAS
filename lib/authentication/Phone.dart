// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:flutter_app/app_widgets/MyHomePage.dart';
import 'package:flutter_app/authentication/Phonep.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:toast/toast.dart';
import 'Sign.dart';

class Phone extends StatefulWidget {
 @override
  State<Phone> createState() => _Phone();
}
class _Phone extends State<Phone> {
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  final GlobalKey<FormState> ks=GlobalKey<FormState>();
  var u=TextEditingController(),t=TextEditingController();
  OtpTimerButtonController controller = OtpTimerButtonController();
  PhoneNumber phoneNumber;
  String v;
  bool pixel;
  Map<String,dynamic>ps;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
            appBar: AppBar(
                   title: Text('Verify Phone Number'.tr),
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
            body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center ,
                      children:  [
                        Padding(padding: EdgeInsets.only(left:Adaptive.w(10) ,right: Adaptive.w(10),bottom: Adaptive.h(5)),  child:
                      Form(
                          key: k
                          ,child:  TextFormField(
                          keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                          controller: u,
                       validator: Files().Errorph,
                        decoration:  InputDecoration(
                         hintText: 'phone'.tr,
                         focusColor: Colors.green,
                         hoverColor: Colors.green,
                         fillColor: Colors.green
                        ),
                     )),)
                        ,Padding(padding:  EdgeInsets.only(bottom: Adaptive.h(12),left:Adaptive.w(12),right:Adaptive.w(12) ),  child: ElevatedButton(   style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            onPrimary: Colors.white, shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                            minimumSize: Size(MediaQuery.of(context).size.width/2,MediaQuery.of(context).size.width/7 ) //////// HERE
    ),  onPressed: (){ otp('ok');},
                          child: Text('ok'.tr,style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal)),)
                        ),],
                    ))  );
  }
  _requestOtp() {
    controller.loading();
    Future.delayed(Duration(seconds: 2), () {
      controller.startTimer();
    });
  }
  void widgets()
  {Get.bottomSheet(BottomSheet(onClosing:(){}, builder: (context){
    return  ListView(
                children: [
                  Container(alignment:Alignment.topLeft ,child:IconButton(onPressed:(){Get.back();}, icon:Icon(Icons.close))),Container(
                      decoration:BoxDecoration(
                          image:DecorationImage(image:AssetImage('asset/images/-3.png'),fit:BoxFit.fitHeight )  ),
                      height:60, width:double.infinity ),
                  Container(alignment:Alignment.bottomRight,
                      child: OtpTimerButton(
                          controller: controller,
                          height: 50,
                          text: Text('Send OTP'.tr),
                          duration: 30,
                          radius:25,
                          backgroundColor: Colors.deepPurple,
                          textColor: Colors.white,
                          buttonType: ButtonType.outlined_button, // or ButtonType.outlined_button
                          loadingIndicator: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                          loadingIndicatorColor: Colors.red,
                          onPressed: () {_requestOtp();
                          otp('otp'); }) ),
                  Divider(height: 20,color: Colors.transparent),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: Color(0xFF512DA8),
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    }, onSubmit: (String verificationCode)async{
                      Files().load(context);
                      String springFieldUSASimple = '+'+vs.val+u.text;
                      try{
                        phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
                          try{
                            PhoneAuthCredential Pc = PhoneAuthProvider
                                .credential(verificationId: v.toString(),
                                smsCode:verificationCode );
                            if(vn==3){
                              await i.currentUser.updatePhoneNumber(Pc);
                              await  observer.analytics.logEvent(name: 'update_phone_number');
                              await ff.collection('/users').doc(i.currentUser.uid).update(
                                  {
                                    'number':'+'+vs.val+phoneNumber.nationalNumber
                                  }
                              );
                              if(gg!=1)
                              { await i.currentUser.updateEmail('+'+vs.val+phoneNumber.nationalNumber+'@gmail.com');}
                              Get.off(()=>MyHomePage());
                              setState(() {
                                vn=0;
                              });
                            }
                            else {
                              await i.signInWithCredential(Pc);
                              if(vn==1){
                                phone();
                              }
                              Get.to(()=>Phonep());
                            }
                            Files().After_login();
                          }
                          on FirebaseAuthException catch(e){
                            if(e.code=='invalid-phone-number')
                            {
                              Toast.show('Invalid phone number'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                            }
                            else
                            {   Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );}
                          }
                      }
                      on Exception catch(e){
                        Toast.show('Invalid phone number'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                      }
                    }, // end onSubmit
                  )
                ])  ;
 }));
  }
  void otp(String button)async{
    Files().load(context);
    try{
      String springFieldUSASimple = '+'+vs.val+u.text;
      phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
      if(vn==1 || vn==2){
        Stream<QuerySnapshot> s=    await   ff .collection('/users').where('number',isEqualTo:'+'+vs.val+phoneNumber.nationalNumber )
            .snapshots();
        s.listen((event) {
          if( event.size.toString()=='1' && vn==1)
          {
            Toast.show('already'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );}
          else if(event.size.toString()=='0' && vn==2)
          {
            Toast.show('not'.tr,
              gravity: Toast.bottom,
              duration: Toast.lengthLong);}
          else {
            if(k.currentState.validate()){
              Auth('+'+vs.val+phoneNumber.nationalNumber);
              if(button=='ok') widgets();}  }
        });
      }
      else{
        if (k.currentState.validate()) {
          controller.startTimer();
          Auth('+' + vs.val + phoneNumber.nationalNumber);
          if(button=='ok') widgets();
        } }
    }
    on Exception catch(e){
      Toast.show('Invalid phone number'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
    }
  }
  void Auth(String phone)async {
    try{
    await  i.verifyPhoneNumber(phoneNumber:phone,
        verificationCompleted: (PhoneAuthCredential C)async{
          Toast.show('DONE');
        },
        verificationFailed: (FirebaseAuthException e){
          Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );
        },
        codeSent:(String Id,int codeToken){
          setState(() {
            this.v=Id;
          });
        },
        codeAutoRetrievalTimeout: (String Verification){
          Toast.show('You Are Timeout',gravity: Toast.bottom,duration:Toast.lengthLong );
        },
        timeout: Duration(seconds: 60)
    );
  }on FirebaseAuthException catch(e) {
    Toast.show(e.code,gravity: Toast.bottom,duration:Toast.lengthLong );
  }
  }
  void phone()async
  { await ff..collection('/users').doc(i.currentUser.uid).set(
      {
        'email':'',
        'number':'+'+vs.toString()+phoneNumber.nationalNumber,
        'favourites':[],
        'searches':[],
        'location':'0',
        'member_date':FieldValue.serverTimestamp()
      }
  );}
}


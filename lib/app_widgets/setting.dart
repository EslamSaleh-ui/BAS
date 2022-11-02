// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:flutter_app/authentication/Logs.dart';
import 'package:flutter_app/authentication/Phone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import 'City.dart';
import 'MyHomePage.dart';
import 'package:flutter_app/authentication/Sign.dart';
class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _Setting();
}
class _Setting extends State<Setting> {
  final GlobalKey<FormState> k=GlobalKey<FormState>();
 final List<String> ll=['Change profile Details','change Password','Change Email','System Mode Setting','Upgrade Application','Delete Account'];
  var u=TextEditingController(),t=TextEditingController(),
      il=TextEditingController(), m=TextEditingController(),
   n=TextEditingController(),d=TextEditingController(),
  newVersion= NewVersion();
  PhoneNumber phoneNumber,pN;
  int y=0;
  final jk=true.obs;
  Map<String,dynamic>ps;
  Future<void> Phonez()
  async{try {
    String springFieldUSASimple = await i.currentUser.phoneNumber;
    pN = await PhoneNumberUtil().parse(springFieldUSASimple);
    setState(() {
      t.text=pN.national;
    });
  }
  on Exception catch(e)
    {setState(() {
      t.text='0000';
    });
    }
    await   ff .collection('/users').
        snapshots().listen((event) {
      event.docs.forEach((element) {
        if(element.id==i.currentUser.uid )
       { ps=element.data();
         if(ps['location'] != '0')
       loca.value=ps['location'];
         else
           loca.value='no city';
       }
      });
    });
  }
  void upgrade()async{
   final status = await newVersion.getVersionStatus();
  newVersion.showUpdateDialog(context: context, versionStatus: status);
  }
  @override
  void initState() {
    super.initState();
    try{
    setState(() {
      u.text=i.currentUser.displayName;
    });}
    on Exception catch(e)
    {      Toast.show('user name not found',gravity: Toast.bottom,duration:Toast.lengthLong );}
    Phonez();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
                  appBar: AppBar(
                    actions: [
                      PopupMenuButton(itemBuilder:(context){
                        return ll.map((e) {
                          return PopupMenuItem(child:Text(e.tr),
                          value: e,
                            onTap: ()  {
if(e=='Change profile Details')
  {y=1;}
else if(e=='change Password')
    {y=2;}
else if(e=='Change Email')
  {y=3;}
else if(e=='System Mode Setting')
  {y=4;
  }else if(e=='Upgrade Application')
{y=5;
upgrade();
}
else if(e=='Delete Account')
  {     y=6;
  Get.back();
  Get.defaultDialog(
      title:'9'.tr
      ,middleText: ''
      , actions:[TextButton(child:Text('Confirm'.tr),onPressed:()async{
    Files().load(context);
    await ff.collection('/users').doc(i.currentUser.uid).delete();
    await i.signOut();
    await i.currentUser.delete();
    Get.to(()=>Logs());
    Toast.show('Deleted'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );} ,),
    TextButton(child:Text('cancel'.tr,style:TextStyle(color:Colors.red ) ,),onPressed:(){Get.back();} ,)
  ]);
  Get.defaultDialog( );
  }   setState(() {});   });}).toList();
                      })
                    ],
                    leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
                      Get.off(()=>MyHomePage());
                      Var.value=0;
                      setState(() {
                        y=0;
                      });
                    },),title: Text('Setting'.tr),
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
                  body:SingleChildScrollView
                    (child: Center(
                      child:Form(
                          key: k,
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center ,
                        children:  [h(y)
                          ,Padding(padding:  EdgeInsets.only(top: Adaptive.h(8),bottom: Adaptive.h(12),left:Adaptive.w(12),right:Adaptive.w(12) ),  child:y==4 || y==6 || y==5?null: ElevatedButton(
      style: ElevatedButton.styleFrom(
    primary: Colors.teal ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ),onPressed:y==0 || y==4?null: ()async{
                            Files().load(context);
                            if(k.currentState.validate())
                            {
if(y==1)
                            {
                              try{

                            await i.currentUser.updateDisplayName( u.text);
                            await ff.collection('/users').doc(i.currentUser.uid).update(
                              {'location':loca.value}
                            );
                            String springFieldUSASimple = '+'+vs.val+t.text;
                            phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
                            if('+'+vs.val+pN.nationalNumber!= '+'+vs.val+phoneNumber.nationalNumber) {
                              Get.to(()=>Phone());
                            setState(() {vn=3;});
                            }
                            Toast.show('Profile Details Updated'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                            }
                            on Exception catch(e)
                            {
                              if(t.text=='0')
                                Navigator.pop(context);
                              else{
                                Toast.show('Invalid Phone Number'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                            }}
                            }
                            else
                            if(y==2)
                            {
                    if(n.text==d.text)
                      {
                        await i.currentUser.updatePassword(n.text);
                        Toast.show('Password Updated'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                      }
                    else
                      {  Toast.show('identical'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                      }
                            }
                            else if(y==3)
                              {if(il.text==m.text){
                                if(gg==1){
                                    await i.currentUser.updateEmail(m.text);
                                    await i.currentUser.sendEmailVerification();
                   Toast.show('Verification'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                               }
                                else
                                  {
                                    await i.currentUser.sendEmailVerification();
                                    await ff.collection('/users').doc(i.currentUser.uid).update(
                                      {
                                       'email': m.text
                                      });
                                    Toast.show('Verification'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                                  }}
                                else
                                  {
                                    Toast.show('identical'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                                  }
                              }
  }}, child: Text('Save'.tr,style:TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal)))
                          ),
                        ],
                      ))))
            );
  }
Widget h(int e){
    if(e==1)
      return Column(
        children: [
          Padding(padding: EdgeInsets.only(top:Adaptive.h(5) ,
              left:Adaptive.w(10) ,right: Adaptive.w(10),bottom: Adaptive.h(5)),  child:
           TextFormField(
              keyboardType: TextInputType.text,
              controller: u,
              validator: Errorname,
              decoration:  InputDecoration(
                  hintText: 'Enter name'.tr,
                  labelText: 'Enter name'.tr,
                  focusColor: Colors.green,
                  hoverColor: Colors.green,
                  fillColor: Colors.green
              ),
            ),),
          Padding(padding: EdgeInsets.only(left:Adaptive.w(10) ,right: Adaptive.w(10),bottom: Adaptive.h(5)) ,child:
         TextFormField(
           validator:Files().Errorph,
            controller: t,
            keyboardType: TextInputType.phone,
            decoration:  InputDecoration(
              labelText: 'phone'.tr,
              hintText: 'phone'.tr,
              focusColor: Colors.black,
              hoverColor: Colors.black,
            ),
          )
            ,),
        Obx(()=>  TextButton(
            child: RichText(text:TextSpan(
              children: [
                WidgetSpan(
                  child: Icon( Icons.my_location,color: Colors.blue.shade800,),
                ),
                TextSpan(text:' Your Location:'+ loca.value,style: TextStyle(fontSize: Adaptive.sp(20),color: Colors.black)),
              ],
            ))
            ,onPressed: () async {
                Var.value=1;
           Get.to(()=>City());
          },)),
        ],
      );
    else if(e==3)
      return Column(
        children: [
          Padding(padding: EdgeInsets.only(top:Adaptive.h(12),left: Adaptive.w(5),right: Adaptive.w(5) ),
              child: TextFormField(
                controller: il,
                validator: Files().Error,
                decoration:  InputDecoration(
                  labelText: 'Enter Email'.tr,
                  hintText: 'Enter Email'.tr,
                    focusColor: Colors.black,
                    hoverColor: Colors.black,
                ),
              ) ),
          Padding(padding: EdgeInsets.only(top:Adaptive.h(6),left: Adaptive.w(5),right: Adaptive.w(5), ),
              child:TextFormField(
                controller: m,
                validator: Files().Error,
                decoration:  InputDecoration(
                  hintText: 'Retrieve'.tr,
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                ),
              ) ),],
      );
    else if(e==4)
      return Column(children:  [
        TextButton(onPressed:(){Get.changeTheme(ThemeData.dark());
        }, child:Row(children: [Icon(Icons.circle,color:Colors.black,size: 17,),Text('Dark'.tr,style: TextStyle(color: Colors.black,fontSize:17),) ],))
        , Divider()     ,  TextButton(onPressed:(){Get.changeTheme(ThemeData.light());
        }, child:Row(children: [Icon(Icons.circle,color:Colors.white,size: 17,),Text('White'.tr,style: TextStyle(color: Colors.black,fontSize:17),) ],))
        ,  Divider() ,      TextButton(onPressed:(){    Get.changeTheme(ThemeData.fallback());
        }, child:Row(children: [Icon(Icons.circle,color:Colors.blue,size: 17,),Text('System'.tr,style: TextStyle(color: Colors.black,fontSize:17),) ],))
      ]);
    else if(e==2)
      return Column(children: [
        Padding(padding: EdgeInsets.only(top:Adaptive.h(12),left: Adaptive.w(5),right: Adaptive.w(5) ),
            child:Obx(()=>TextFormField(
              obscureText:jk.value==true?true:false,
              controller: n,
              validator: Files().ErrorP,
              decoration:  InputDecoration(
                  hintText: 'password'.tr,
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                  suffixIcon: IconButton(onPressed:(){
                    jk.toggle();
                  }, icon:Obx(()=>jk.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                  Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) ) )
              ),
            ))  ),
        Padding(padding: EdgeInsets.only(top:Adaptive.h(6),left: Adaptive.w(5),right: Adaptive.w(5) ),
            child:Obx(()=> TextFormField(
              obscureText:jk.value==true?true:false,
              controller: d,
              validator: Files().ErrorP,
              decoration:  InputDecoration(
                  hintText: 'Retrieve1'.tr,
                  focusColor: Colors.black,
                  hoverColor: Colors.black,
                  suffixIcon: IconButton(onPressed:(){
                    jk.toggle();
                  }, icon:Obx(()=>jk.value==true?Icon(FontAwesomeIcons.eyeSlash,size: Adaptive.sp(20),color: Colors.green.shade500):
                  Icon(FontAwesomeIcons.solidEye,size: Adaptive.sp(20),color: Colors.green.shade500,) ) )
              ),
            ) )  )
      ],);
else
  return Container(
    height: Adaptive.h(85),
    width: Adaptive.w(75),
    decoration: BoxDecoration(
      shape: BoxShape.circle
    ),
      child:ColorFiltered( child:Image.asset('asset/images/1024.png'),
      colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
    )
  );
}
  String  Errorname (String c)
  {
    if(c.isEmpty)
      return 'error1'.tr;
    else  if (c.length < 5)
      return 'must be more than 5 characters';
  }

}
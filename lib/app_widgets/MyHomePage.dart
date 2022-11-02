// ignore_for_file: division_optimization
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app_widgets/About.dart';
import 'package:flutter_app/app_widgets/Addads.dart';
import 'package:flutter_app/app_widgets/Contact.dart';
import 'package:flutter_app/app_widgets/Favourits.dart';
import 'package:flutter_app/authentication/Sign.dart';
import 'package:flutter_app/app_widgets/packages.dart';
import 'package:locally/locally.dart';
import 'setting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'Ads.dart';
import '../modules/Files.dart';
import '../authentication/Logs.dart';
import 'Myads.dart';
import '../chat/Mychat.dart';
import 'Pick.dart';
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();}
class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Locally locally;
  List<String> lang= ['العربية','English'];
   List<String> widget1= ["car","homes","mobile","tv","decor","fashion","pets","kids","book","jobs","trade","service"];
  List<dynamic> widget2= [ Icon(FontAwesomeIcons.car,color: Colors.deepOrange,size: Adaptive.sp(30),),
    Icon(FontAwesomeIcons.home,color: Colors.blue.shade800,size: Adaptive.sp(35)),
    Image.asset('asset/images/icons/3137807.png',height:60,width: Adaptive.w(10),) ,
    Image.asset('asset/images/icons/1384499.png',height:70,width: Adaptive.w(10),),
    Icon( FontAwesomeIcons.chair ,color: Colors.teal.shade900,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.tshirt ,color: Colors.deepPurple.shade800,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.dog ,color: Colors.blue,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.baby ,color: Colors.purpleAccent,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.music ,color: Colors.red,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.shoppingBag ,color: Colors.green,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.industry ,color: Colors.brown,size: Adaptive.sp(35),),
    Icon(FontAwesomeIcons.key ,color: Colors.black,size: Adaptive.sp(35),),];
  @override
  void initState() {
    super.initState();
    ill.value=Countryees.val;
   Files().write('location.country',Countryees.val,Filter.value);
    local();
    messaging();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
                  drawer: Drawer(
                    backgroundColor:Colors.grey.shade100 ,
                    child:    Column(
                      children: [
                        Container(
                    constraints: BoxConstraints(
                    maxHeight: double.infinity,
                    ), width:double.infinity ,
                           decoration:BoxDecoration(image:DecorationImage(
                             image: AssetImage('asset/images/Untitled-2.png'),
                             fit: BoxFit.cover
                           )),
                           child:Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center
                               ,children:[
                             DrawerHeader(
                                 child: Container(
                                     height:Adaptive.h(24) ,
                                     width:Adaptive.w(double.infinity/2) ,
                                     decoration: BoxDecoration(
                                       border: Border.all(
                                           color: Colors.white,
                                           width: Adaptive.sp(7)),
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey.shade400,
                                           spreadRadius: 2,
                                           blurRadius: 3,
                                           offset: Offset(0,8)
                                         )],
                                       shape: BoxShape.circle,
                                       image: DecorationImage(
                                         image: AssetImage('asset/images/1024.png'),
                                       ), ) )),
                             Visibility(visible:true,
                                 child:i.currentUser==null?ElevatedButton(   style: ElevatedButton.styleFrom(
                                     primary: Colors.purple,
                                     onPrimary: Colors.white, shape:  RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(50)),
                                     minimumSize: Size(MediaQuery.of(context).size.width/3,MediaQuery.of(context).size.width/7 )  //////// HERE
    ),onPressed: (){
                                   if(login.val=='phone' || login.val==null)
                                     Get.offAll(()=>Fetch());
                                   else
                                     Get.offAll(()=>Logs());
                                 }, child:Text("login".tr,style: TextStyle(color: Colors.white, fontSize: Adaptive.sp(20)))
                                   ,):Text('${'Username'.tr} ${i.currentUser.displayName !=null?
                                 i.currentUser.displayName:i.currentUser.phoneNumber !=null?i.currentUser.phoneNumber:i.currentUser.email}',style: TextStyle(color: Colors.purple,fontSize: Adaptive.sp(20)),)
                             )
                           ]) ),Expanded(child:   ListView(children: [ ListTile(
                        leading:ImageIcon(AssetImage('asset/images/icons/263115.png')),
                        title: Text("Home".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                        onTap: (){_scaffoldKey.currentState.openEndDrawer();}) ,
                        ListTile(
                          leading:ImageIcon(AssetImage('asset/images/icons/149309.png')),
                          title: Text("Ads".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Files().Querys(Filter.value);
                            cvv.value='Choose Category';
                            Get.to(()=>Ads(dad:Filter.value,page:'MyHome'));
                          },
                        ), ListTile(
                          leading:ImageIcon(AssetImage('asset/images/icons/2948035.png')),
                          title: Text("My".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Get.to(()=> Myads());
                          },
                        ), ListTile(
                            trailing:Obx(()=>wbs.value>=1 ?Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepOrange,),
                                height:Adaptive.h(10) ,width:Adaptive.w(10),
                                child:Center(child:Text('${wbs.value}',style:TextStyle(fontSize: Adaptive.sp(16) )))):Text('')) ,
                          leading:ImageIcon(AssetImage('asset/images/icons/1370907.png')),
                          title: Text("chat".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){   _scaffoldKey.currentState.openEndDrawer();
                          Get.to(()=>Mychat());
                          },
                        ),ListTile(
                          leading:ImageIcon(AssetImage('asset/images/icons/2956879.png')),
                          title: Text("best".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Get.to(()=>Favourits());
                          },
                        ),ListTile(
                          leading:Image.asset('asset/images/icons/3303779.png',height: Adaptive.h(10),width: Adaptive.w(10),),
                          title: Text("place".tr,style: TextStyle(color: Colors.deepOrange,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            if(i.currentUser==null)
                            {Get.to(()=> Fetch());}
                            else
                            {Get.to(()=> Addads());}
                          },
                        ),Visibility(
                              child: ListTile(
                            title: Text('Packages'.tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                            onTap: (){
                              _scaffoldKey.currentState.openEndDrawer();
                              Get.to(()=> packages());
                            },
                          ),visible:i.currentUser !=null ?true:false ),
                          ListTile(
                          title: Text("contact".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Get.to(()=> Contact());
                          },
                        ),Visibility(child: ListTile(
                          title: Text("us".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Files().load(context);
                            Get.dialog(
                              AlertDialog(
                                  title:ListTile(title:Text('Customer Service'),
                                  trailing: IconButton(onPressed:(){Navigator.pop(context); }, icon:Icon(Icons.close)),
                                  ) ,
                                  scrollable:true ,
                                  content:SingleChildScrollView(
                                child:Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                  children: [
                                 Center(child: Text('there is no agent to response you please leave your request',
                                 style:TextStyle(color:Colors.red )   )),
                                Padding(padding: const EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),  child:
                                  TextFormField(
                                      controller: TextEditingController(),
                                      autofocus: true,
                                      validator: Files().Errort,
                                      decoration:  InputDecoration(
                                        hintText:'your name'.tr,
                                        fillColor: Colors.white,
                                        border:OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Adaptive.sp(0))),
                                      )
                                  )),
                                Padding(padding: const EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),  child:TextFormField(
                                      controller: TextEditingController(),
                                      autofocus: true,
                                      validator: Files().Errort,
                                      decoration:  InputDecoration(
                                        hintText:'phone'.tr,
                                        fillColor: Colors.white,
                                        border:OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Adaptive.sp(0))),
                                      )
                                  )), Padding(padding: const EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),  child: TextFormField(
                                      controller: TextEditingController(),
                                      minLines: 9,
                                      maxLines:10 ,
                                      autofocus: true,
                                      validator: Files().Errort,
                                      decoration:  InputDecoration(
                                        hintText:'description'.tr,
                                        fillColor: Colors.white,
                                        border:OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Adaptive.sp(0))),
                                      )
                                    ) ),
                                Padding(padding: const EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),  child:TextFormField(
                                      controller: TextEditingController(),
                                      autofocus: true,
                                      validator: Files().Errort,
                                      decoration:  InputDecoration(
                                        hintText:'email'.tr,
                                        fillColor: Colors.white,
                                        border:OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(Adaptive.sp(0))),
                                      )
                                  )),
                                 OutlinedButton(onPressed:(){}, child:Text('send'.tr))
                                ],) ,
                              ))
                            );
                          },
                        ),visible:i.currentUser !=null ?true:false ),
                        ListTile(
                          title: Text("country".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            y=1;
                            _scaffoldKey.currentState.openEndDrawer();
                            Get.to(()=> Pick());
                          },
                        )
                        ,ListTile(
                          title: Text("lang".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Get.defaultDialog(
                              radius:double.infinity ,
                              title: "lang".tr,
                              middleText:'',
                              content:Column(children:
                              lang.map((e) {
                                return TextButton(onPressed: ()async{
                                    Get.back();
                                    Files().load(context);
                                    if(e=="English")
                                    Get.updateLocale(Locale("en"));
                                    else
                                      Get.updateLocale(Locale("ar"));
                                    box.write('locale',Get.locale.languageCode );
                                  }, child:Text(e,style: TextStyle(fontSize: Adaptive.sp(20),color: Colors.black),) );
                              }).toList()
                           ),
                            );
                          },
                        ),ListTile(
                          title: Text("about".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                       Get.to(()=>About(dad:language.val=='ar'?"https://spearsupport.zendesk.com/hc/ar":
                       "https://spearsupport.zendesk.com/hc/en-gb" ));
                          },
                        ), Visibility(child: ListTile(
                          title: Text("Setting".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: (){
                            _scaffoldKey.currentState.openEndDrawer();
                            Get.to(()=>Setting());
                          },
                        ),visible:i.currentUser !=null ?true:false ),
                        Visibility(child: ListTile(
                          leading:Icon(Icons.logout),
                          title: Text("out".tr,style: TextStyle(color: Colors.black,fontSize: Adaptive.sp(15))),
                          onTap: ()async{
                            Files().load(context);
                            _scaffoldKey.currentState.openEndDrawer();
                            await  observer.analytics.logEvent(name: 'Log_out');
                            if(p != null){await  v.logOut();}
                            else if( x !=null)
                            {await g.signOut();}
                              await i.signOut();
                            setState(() {gg=0;});
                            if(login.val=='phone' || login.val==null)
                              Get.offAll(()=>Fetch());
                            else
                              Get.offAll(()=>Logs());
                          },
                        ),visible: i.currentUser != null?true:false)],) ,)
                        ,],)
                  ),
                  appBar: AppBar(
                    title: ListTile(
                      title:Obx(()=>Text(ill.value.tr,style: TextStyle(fontSize: Adaptive.sp(18),color:Colors.white ))),
                  leading: Icon( Icons.arrow_drop_down,color: Colors.white,) ,
                      onTap: (){
                        Files().dialog(context,Filter.value);
                      },),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient:const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.purple,
                              Colors.purpleAccent],
                            stops: [0.2,0.6]
                        ) )
                    ) ),
                  body: Column(children:[
           Countryees.val!=filters.val['location.country'] ?Container(
                  decoration:BoxDecoration(
                      gradient:const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.purpleAccent,
                        Colors.purple],
                      stops: [0.2,0.6]),
    )): ListTile(iconColor:Colors.black,
                            textColor:Colors.black, leading:Icon(FontAwesomeIcons.clock),onTap:(){
                              Files().Querys(filters.val);
                              LinkedHashMap<dynamic, dynamic> g=LinkedHashMap<dynamic, dynamic>.from(filters.val);
                              Get.to(()=>Ads(dad:g,page:'MyHomePage'));  } ,
                            title:Text('${"Continue Search for".tr} ${ filters.val['category'].toString().tr} ${"in".tr}'),
                            subtitle:Text('${filters.val['location.city']==null?filters.val['location.country']:filters.val['location.city']}') ,
                            trailing:Icon(Icons.arrow_forward_ios)),
                    new Expanded(child:Container(
                      decoration:BoxDecoration(
                        gradient:const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.purpleAccent,
                              Colors.purple],
                            stops: [0.2,0.6]),
                      ),
                      child: GridView.count(crossAxisCount: 2,
                          crossAxisSpacing: Adaptive.sp(10),
                          mainAxisSpacing: Adaptive.sp(10)
                          ,children:widget1.map((e) {return   GestureDetector(
                            onTap: (){
                              Files().write('category', e,Filter.value);
                              Files().Querys(Filter.value);
                              Get.to(()=>Ads(dad:Filter.value,page:'MyHomePage'));
                              cvv.value=e;
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight:Radius.circular(50),
                                      bottomLeft:Radius.circular(50) )) ,
                              child:Column(
                                mainAxisAlignment:MainAxisAlignment.center ,
                                crossAxisAlignment: CrossAxisAlignment.center
                                ,children: [
                                widget2.elementAt(widget1.indexOf(e)),
                                Text(e.tr,style: TextStyle(fontSize: Adaptive.sp(18)),),
                                Row(mainAxisAlignment:MainAxisAlignment.center ,
                                    children: [ Obx(()=> StreamBuilder<QuerySnapshot>(
                                        stream:ill.value==Countryees.val? query1.value.where('category',isEqualTo: e).snapshots():
                                        query1.value.where('category',isEqualTo: e).where('location.city',isEqualTo: ill.value).snapshots(),
                                        builder:(context,ss){
                                          if(!ss.hasData) return Text('0');
                                          int y=   ss.data.size;;
                                          return Text('${y}');
                                        }  )), Text(' ${'Ad'.tr}',style: TextStyle(fontSize: Adaptive.sp(18)) )  ])
                              ]   )) ,
                          );}).toList()
                      ) ) ) ])
             ,      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: ElevatedButton(child:Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center ,children:[Padding(padding:EdgeInsets.only(right: Adaptive.w(2)) ,child: Icon( FontAwesomeIcons.camera,size:Adaptive.sp(15),color: Colors.white,),),
        Text(" ${"place".tr}",style: TextStyle(color: Colors.white,fontSize: Adaptive.sp(18)),)]),onPressed: (){
                  if(i.currentUser==null)
                    Get.to(()=>Fetch());
                  else
                   Get.to(()=>Addads());
                } ,style: ElevatedButton.styleFrom(shape:
            RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) )
            ,maximumSize:Size(180, 50),primary:Colors.deepOrange ))
              );
  }
Future messaging()async{
    var per=await fbm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (per.authorizationStatus == AuthorizationStatus.authorized || per.authorizationStatus == AuthorizationStatus.provisional)
      { var gim=await fbm.getInitialMessage();
        if(gim != null)
      {
        await fbm.getInitialMessage().then((event) {
          locally.show(title: event.notification.title, message: event.notification.body);
        });}
      else if(FirebaseMessaging.onMessageOpenedApp != null)
      { await FirebaseMessaging.onMessageOpenedApp.listen((event) {
        locally.show(title: event.notification.title, message: event.notification.body);
      });}
  await   FirebaseMessaging.onMessage.listen((event) {
     locally.show(title: event.notification.title, message: event.notification.body);
      });
      }
    else
      Toast.show("you don‘t have permission to send notifications",gravity: Toast.bottom,duration:Toast.lengthLong );
  }
  void local() {
    locally = Locally(
      iosRequestAlertPermission: true,
      iosRequestBadgePermission: true,
      iosRequestSoundPermission: true,
      appIcon: 'play_store_512',
      context: context,
      payload: 'test',
      pageRoute: MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
}

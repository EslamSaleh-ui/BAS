import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_badger/flutter_badger.dart';
import 'Chat.dart';
import '../modules/Files.dart';
class Mychat extends StatefulWidget {
  @override
  _Mychat createState() => _Mychat();
}
class _Mychat extends State<Mychat> with TickerProviderStateMixin  {
final List <String> mas=['All Answers','Only marked with star','unread'];
final data  d=Get.put(data());
TabController tc;
void badge()
{wbs.value=0;
  d.s2.snapshots().listen((event) {event.docs.forEach((e) {
    wbs.value+= e.get('unread.${i.currentUser.uid}');  });  });
d.s1.snapshots().listen((event) {event.docs.forEach((e) {
  wbs.value+=  e.get('unread.${i.currentUser.uid}');  });  });
wbs.listen((p0) {  FlutterBadger.updateBadgeCount(p0); });
}
@override
  void initState() {
  super.initState();
  if(i.currentUser !=null){
    d.take();
  d.broad();
  d.add();
  tc=TabController(vsync:this , length: 2);}
}
@override
  void dispose() {
  super.dispose();
  if(i.currentUser !=null)
  {badge();}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.grey.shade200 ,
        appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
              Get.back();
            },),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient:const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.purple,
                      Colors.purpleAccent,
                    ],stops: [0.2,0.6]
                )
            ),
          ),
          title: Text('My Chats'.tr),
            bottom:i.currentUser !=null? TabBar(
              controller:tc,
              labelColor: Colors.purple,
              indicatorColor:Colors.white ,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
              color: Colors.deepPurpleAccent),
              tabs: [
                Tab(child: Text('messages'.tr,style: TextStyle(color: Colors.white),),),
                Tab(child: Text('archives'.tr,style: TextStyle(color: Colors.white),),),
              ],
              onTap: (e){
                tc.animateTo(e);
                    if(e==0){
                      d.add();
                    if(d.visible.value==false) d.visible.toggle();
                    }
                    else
                    {
                    d.add1();
                    if(d.visible.value==true) d.visible.toggle();
                    }
               },
            ):null,actions:i.currentUser !=null?[Obx(()=>d.visible.value==true? PopupMenuButton(itemBuilder: (context){
          return  mas.map((e) {
            return PopupMenuItem(child: Text(e.tr),
                value: e,
                onTap: () {
                  if (e == 'All Answers') {
                    d.take();
                    d. add();
                  } else if (e == 'Only marked with star') {
                    d.take();
                    d. s1 = d.s1.where('marked.${i.currentUser.uid}', isEqualTo: 'true');
                    d. s2 =d. s2.where('marked.${i.currentUser.uid}', isEqualTo: 'true');
                    d.add();
                  }
                  else if (e == 'unread') {
                    d.take();
                    d.s1 =d. s1.where('unread.${i.currentUser.uid}', isGreaterThan:0);
                    d. s2 =d. s2.where('unread.${i.currentUser.uid}', isGreaterThan:0);
                    d.add(); }
                });
          }).toList();
        }):Container(width: 0.0, height: 0.0))]:[]),
        body:i.currentUser !=null?StreamBuilder(
          stream:d.sc1.stream,
          builder:( context, snapshot1) {
        return StreamBuilder(
            stream:d.sc2.stream,
            builder: (context,snapshot2){
              if(snapshot2.connectionState==ConnectionState.waiting)
                return new Center(child:CircularProgressIndicator(color: Colors.grey.shade400,) ,);
              if (!snapshot2.hasData && !snapshot1.hasData ) return  Center(child:Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly ,children: [Icon(FontAwesomeIcons.facebookMessenger,size: Adaptive.sp(50
              ),),Text("No Chats",style: TextStyle(fontSize: Adaptive.sp(25)),)],) );
              if(!snapshot1.hasData)
                return ListView( children:!d.sc1.isClosed && !d.sc2.isClosed?  [wid(snapshot2.data)]:[Container()],);
              if(!snapshot2.hasData)
                return ListView(children:!d.sc1.isClosed && !d.sc2.isClosed?  [wid(snapshot1.data)]:[Container()],);
              return ListView(
                children:!d.sc1.isClosed && !d.sc2.isClosed? [wid(snapshot1.data),wid(snapshot2.data)]:[Container()],);
            });
          } ):Center(child:Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly ,children: [Icon(FontAwesomeIcons.facebookMessenger,size: Adaptive.sp(50
        ),),Text("No Chats",style: TextStyle(fontSize: Adaptive.sp(25)))]) )
      );
}
  Widget wid(QuerySnapshot q)
  {
  return Column(
    children:q.docs.map((DocumentSnapshot document)  {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return StreamBuilder<QuerySnapshot>(
        stream:ff.collection('/chats').doc(document.id).collection('/messages')
            .orderBy('time',descending: true).limit(1).snapshots() ,
        builder:(context,ss){
          if(!ss.hasData) return Container();
            return Column(
            children:ss.data.docs.map((e){
              Map<String, dynamic> d = e.data() as Map<String, dynamic>;
              DateTime dt=d['time']==null?DateTime.now():d['time'].toDate() as DateTime;
              String d12 = DateFormat('dd-MM-yy  hh:mm a').format(dt);
           return   GestureDetector(
                onTap: (){
                  Get.to(()=> Chat(chatId:document.id));},
                child: Card(
                  color:data['unread']['${i.currentUser.uid}']>=1?Colors.deepOrangeAccent.shade100:Colors.white,
                  margin: EdgeInsets.all(10),
                  child:Column(
                    mainAxisAlignment:MainAxisAlignment.center ,
                    crossAxisAlignment: CrossAxisAlignment.start
                    ,children: [
                    ListTile(
                      trailing:data['unread']['${i.currentUser.uid}']>=1?Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepOrange,),
                          height:Adaptive.h(12) ,width:Adaptive.w(12),
                          child:Center(child:Text(data['unread']['${i.currentUser.uid}'].toString(),style:TextStyle(fontSize: Adaptive.sp(16)))))
                          :ImageIcon(AssetImage('asset/images/icons/1370907.png'),size: Adaptive.sp(25),) ,
                      title:Text(d12),
                      subtitle: Text('${data['ad']}',style:TextStyle(fontSize: Adaptive.sp(20))),
                    ),
                    Divider(thickness: Adaptive.sp(3),color: Colors.black,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child:Text(d['sender_id']==i.currentUser.uid?'  ${'you'.tr}: ${d['text']}':'  ${"Other User".tr}: ${d['text']}',style: TextStyle(fontSize:Adaptive.sp(20)),) ,),Center( child:data['marked']['${i.currentUser.uid}']=='true'?Icon(Icons.star,color: Colors.amber,size:40):null ,)],)
                  ],
                  ),)  );
            }).toList()
          ); }
      );
    }).toList() );
  }
}

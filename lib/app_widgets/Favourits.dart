import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import 'package:translator/translator.dart';
import 'AD.dart';
import 'Ads.dart';
import '../modules/Files.dart';

class Favourits extends StatefulWidget {
  @override
  _Favourits createState() => _Favourits();
}
class _Favourits extends State<Favourits> with TickerProviderStateMixin {
  TabController tc;
  final data  d=Get.put(data());
  @override
  void initState() {
    super.initState();
    if(i.currentUser !=null){
    d.marks();
    tc=TabController(vsync:this , length: 2);
   }
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return   ResponsiveSizer(builder:
    (context,orientation,screenType) {
      return  Scaffold(
          backgroundColor:Colors.grey.shade200 ,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient:const  LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.purple,
                        Colors.purpleAccent,
                      ],
                      stops: [0.2,0.6]
                  )
              ),
            ),
            title:  Text("best".tr),
            actions: [Obx(()=> d.favourits==null || d.favourits.isEmpty || d.selected.isFalse?
      Container(width: 0.0, height: 0.0):
            IconButton(onPressed:(){
              showDialog(context: context,builder: (context){
                return AlertDialog(
                    title: Text("3".tr)
                    ,titlePadding:EdgeInsets.all(Adaptive.sp(10)) ,
                    actions: [TextButton(child: Text("Remove".tr,style:TextStyle(color: Colors.red.shade500,locale:Get.locale)),
                        onPressed:(){d.remove_all(d.favourits);
                        Navigator.pop(context);
                        Toast.show("2".tr, gravity: Toast.bottom, duration: Toast.lengthLong);}),
                      TextButton(child: Text("Cancel".tr,style:TextStyle(color: Colors.blue.shade500)),
                          onPressed:(){Navigator.pop(context);})]);
              });
            }, icon:Icon(Icons.delete,color:Colors.white))
               )],
            bottom:i.currentUser !=null? TabBar(
              controller:tc,
              labelColor: Colors.purple,
              indicatorColor:Colors.white ,
              tabs: [
                Tab(child: Text("Ads".tr,style: TextStyle(color: Colors.white),),),
                Tab(child: Text("Searches".tr,style: TextStyle(color: Colors.white),),),
              ],
              onTap: (e){
                tc.animateTo(e);
                if(e==1)
                  {
                    d.marks_searches();
                    if(d.selected.value==true)
                    d.selected.toggle();}
                else
               {d.marks();
               if(d.selected.value==false)
                 d.selected.toggle();}
              },
            ):null,
          ),
          body:i.currentUser!=null? Obx(()=> d.favourits==null || d.favourits.isEmpty ?
          Center(child:Text('NO Results') ):d.selected.isFalse?Column(
            children:d.favourits.map((element){
              Map<String,dynamic> result=element;
              return Padding(padding: EdgeInsets.all(10),child:Column(children:
              [Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                  crossAxisAlignment:CrossAxisAlignment.start ,
                  children:result.keys.map((e){
                    return Text('${e}: ${result[e]}',style: TextStyle(fontWeight:FontWeight.bold ));
                  }).toList()),Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                  children: [ElevatedButton(onPressed: (){ ff.collection('/users').doc(i.currentUser.uid).update(
                      {'searches':FieldValue.arrayRemove([element]) });},
                  child:Row(children:[Icon(Icons.delete,color:Colors.white),Text('Remove'.tr,style: TextStyle(color:Colors.white ))])),
                ElevatedButton(onPressed: (){     cvv.value='Choose Category';
                LinkedHashMap<dynamic, dynamic> g=LinkedHashMap<dynamic, dynamic>.from(element);
                  Files().Querys(element); Get.to(()=>Ads(dad:g,page:'Favourits'));
                }, child:Row(children:[Icon(Icons.show_chart,color:Colors.white),Text('show'.tr,style: TextStyle(color: Colors.white))]))]),
              Divider(color:Colors.black)]  ));
            }).toList()
          ):SingleChildScrollView(padding:EdgeInsets.fromLTRB(3,5, 3,5) , child: Column(children: [   Column(children:d.favourits.map((e) {
            return StreamBuilder<DocumentSnapshot>(
                stream:e==null?{}: ff.collection('/ads').doc(e).snapshots() ,
                builder: (context,dq){
                  if(dq.connectionState==ConnectionState.waiting)
                    return new Center(child:CircularProgressIndicator(color: Colors.grey.shade400,) ,);
                  if(!dq.hasData) return Center(child:Text('No Data'));
                  Map<String,dynamic> data=dq==null?{}:dq.data.data() as Map<String,dynamic>;
                  DateTime dt =  (data['time'] as Timestamp).toDate();
                  return Obx(()=>d.favourits.contains(dq.data.id)  ?
                  GestureDetector(
                      onTap: (){
                        Get.to(()=>AD(dad:'Favourits' , Id: dq.data.id,));},
                      child:Card(
                        color:Colors.white,
                        margin: EdgeInsets.all(10),
                        child:Column(
                          children: [
                            Row(children:[
                              Stack(children: [
                                Container(color: Colors.white,
                                  child:data['image'].isEmpty || data['image']==null?Center(child:Text('no photo') ,):
                                  Image.network(data['image'][0],fit: BoxFit.cover),
                                  height: Adaptive.h(18),width: Adaptive.w(45),),
                                IconButton(icon:Icon(Icons.star,size: Adaptive.sp(25),color:Colors.yellowAccent),
                                    onPressed:(){d.remove(dq.data.id);
                                    Toast.show("2".tr, gravity: Toast.bottom, duration: Toast.lengthLong);
                                    })   ]),
                              Container(height: Adaptive.h(18),width: Adaptive.w(45),
                                child:  Column ( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [ Text(' ${data['name']}',style:TextStyle(fontSize:20,locale:Get.locale )),Text(' ${data['price']} LE',style:TextStyle(locale:Get.locale ))]),
                                    FutureBuilder<Translation>(future:translator.translate(data['location']['city'],from:'en',to: language.val ),
                                        builder:(context,ss){
                                          if(ss.connectionState==ConnectionState.waiting)
                                            return Text('');
                                          return  Text(' ${ss.data.text}',style:TextStyle(locale:Get.locale ));
                                        })
                                  ],),)
                            ],),
                            Divider(thickness: Adaptive.h(0.05),color: Colors.black,),
                            Row(crossAxisAlignment:CrossAxisAlignment.start,children: [Text('  ${Jiffy([dt.year,dt.month,dt.day]).format("MMM do yyyy")}',style:TextStyle(locale:Get.locale )),],)
                          ], ),)
                  ): Container()
                  );
                });
          }).toList() ),i.currentUser !=null?Admob():Container()
          ],))
              ): Center(child:Text("No Results",style: TextStyle(fontSize: Adaptive.sp(25))) )
      );});
  }
  }

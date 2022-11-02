import 'package:flutter/material.dart';
import 'package:flutter_app/app_widgets/pay_way.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../modules/Files.dart';
import 'AD.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Myads extends StatefulWidget {
  @override
  _Myads createState() => _Myads();
}
class _Myads extends State<Myads>  {
  final data  d=Get.put(data());
  List<String> cho=['Remove','Edit','share'];
  List<String> prop=['chats','calls','views','favourit'];
@override
  void initState() {
    super.initState();
    if(i.currentUser !=null){d.marks();}
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ResponsiveSizer(builder:
    (context,orientation,screenType) {
      return Scaffold(
        backgroundColor:Colors.grey.shade200 ,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient:const  LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.purple,
                      Colors.purpleAccent,],
                    stops: [0.2,0.6]
                )
            ),
          ),
        title: Text("My".tr),
         ),body:i.currentUser !=null?StreamBuilder<QuerySnapshot>(
        stream:ff.collection('/ads').where('uid',isEqualTo: i.currentUser.uid).snapshots() ,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            return new Center(child:CircularProgressIndicator(color: Colors.grey.shade400,) ,);
          if (!snapshot.hasData  ) return  Center(child:Text("No Results",style: TextStyle(fontSize: Adaptive.sp(25))) );
          return  ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> ad = document.data() as Map<String, dynamic>;
              List<dynamic> img= ad['image'] as List<dynamic>;
              DateTime dt =  (ad['time'] as Timestamp).toDate();
              String d12 = DateFormat('dd-MM-yyyy,hh:mm a').format(dt);
              return   GestureDetector(
                onTap: (){
                  Get.to(()=>AD(dad:'Myads' , Id: document.id,));
                },
                child:Container(
                  decoration:BoxDecoration(
                    border:Border.all(width:0.5) ,
                  color:Colors.white),
                  margin: EdgeInsets.all(10),
                  child:Column(
                    children: [
                      Row(children:[
                        Stack(children: [
                          Container(
                      decoration:BoxDecoration(
                          border:img.isEmpty?Border.all(width:0.5):null ,
                          color:Colors.white),
                            child:img.isEmpty?ElevatedButton(child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[const Icon(Icons.add,) , Text("add image".tr)]),onPressed:(){}):
                            Image.network(ad['image'][0],fit: BoxFit.cover),
                            height: Adaptive.h(18),width: Adaptive.w(45)), IconButton(icon:
                              Obx(()=>d.favourits.contains(document.id)? Icon(Icons.star,size: Adaptive.sp(25),
                                  color: Colors.yellowAccent):Icon(Icons.star,size: Adaptive.sp(25),
                                  color: Colors.grey.shade500))
                         ,onPressed:(){
                            if(d.favourits.contains(document.id))
                            {d.remove(document.id);
                            Toast.show("2".tr, gravity: Toast.bottom, duration: Toast.lengthLong);
                            }
                            else
                            {d.put(document.id);
                            Toast.show("1".tr, gravity: Toast.bottom, duration: Toast.lengthLong);}
                          })
                         ]),
                      Container( child:  Column ( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [ Text(' ${ad['name']}',style:TextStyle(fontSize:20,locale:Get.locale )),
                Text(' ${ad['price']} LE',style:TextStyle(locale:Get.locale ))],),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(' ${ad['category']}',style:TextStyle(fontSize:20,locale:Get.locale )), Divider(thickness: Adaptive.h(0.1),color: Colors.black,)]),
                          Text(' ${d12}',style:TextStyle(locale:Get.locale )),
                          Text(' ${document.get('location.city')}',style:TextStyle(locale:Get.locale ))
                        ],),)
                       ],),
                      Row(mainAxisAlignment:  MainAxisAlignment.start, children:prop.map((e) {
                        return SizedBox(width:Adaptive.w(23),child:ListTile(title:Text(e.tr) ,
                        subtitle: Text(ad[e].toString()) ));
                      }).toList(),),
                      Divider(thickness:0.1,color: Colors.black,),
                      Row(children: [ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.purple ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/2 ,80), //////// HERE
    ), child: Text("promote".tr,style:TextStyle(fontSize:20 , color: Colors.white)),onPressed:(){
                        Get.to(()=>pay_way());
                        }),
                        SizedBox(width:Adaptive.w(45), child:PopupMenuButton(
                          icon:const Text('...',style:TextStyle(fontSize:30 )) , itemBuilder:(context){return cho.map((e){
                          return PopupMenuItem(child: Text(e.tr),onTap: ()async{
                            if(e=='Remove')
                              {Get.back();
                              Get.defaultDialog(
                                  title:'Do you want to remove ad?'
                                  ,middleText: ''
                                  , actions:[TextButton(child:Text('Confirm'),onPressed:(){ff.collection('/ads').doc(document.id).delete();
                              Get.back();
                              Toast.show("Ad removed", gravity: Toast.bottom, duration: Toast.lengthLong);} ,),
                                    TextButton(child:Text('cancel',style:TextStyle(color:Colors.red ) ,),onPressed:(){Get.back();} ,)
                                  ]);
                             Get.defaultDialog( );
                              }else if(e=='share')
                                {final Link=await d.link(document.id);
                                  Share.share( Link.toString());  }
                          },);
                        }).toList();},) ,)],)
                    ], ),)
              );
            }).toList() );

        }): Center(child:Text("No Results",style: TextStyle(fontSize: Adaptive.sp(25))) ) ,
    );});
  }
}


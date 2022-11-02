import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';

class Addads extends StatefulWidget {
  @override
  _Addads createState() => _Addads();
}
class _Addads extends State<Addads> {
  final List<String> vivo = [   "homes", "car",
    "mobile", "tv", "decor", "fashion", "pets", "kids", "jobs", "book", "trade", "service"];
  List<String> h=['camera','gallery','Cancel'];
  List<String> hs=['Remove','Cancel'];
  List<Icon> j=[Icon(FontAwesomeIcons.camera),Icon(Icons.album),Icon(Icons.cancel)];
  final value='homes'.obs;
var u=TextEditingController();
var q=TextEditingController();
var w=TextEditingController();
var e=TextEditingController();
var s=TextEditingController();
final photos=[].obs;
final ad_elements={}.val('ad_elements');
final n={}.obs;
var image;
final GlobalKey<FormState> k=GlobalKey<FormState>();
Future<void> readJson() async {
  final  response = await DefaultAssetBundle.of(context).loadString('asset/jsons/properties.json');
  final data = await json.decode(response);
  n.addAll(data);
  WidgetsBinding.instance
      .addPostFrameCallback((_) =>showDialog(context:context,
      barrierDismissible: false
      ,builder: (context){
    return  WillPopScope(child: AlertDialog(
      title:Container(width: Adaptive.w(double.infinity),
        height: Adaptive.h(7.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey.shade500),
        child:Text('Choose Category'.tr,style:TextStyle(fontSize: Adaptive.sp(20))),),
      actions: [TextButton(onPressed: (){Navigator.pop(context,true);}, child: Text('Cancel'.tr,style: TextStyle(color:Colors.green.shade500)))],
      content:SingleChildScrollView(child:Column(
          children:n.keys.map((e) {
            return TextButton(child:Text('${e.toString().tr}'),onPressed: (){
              value.value=e;
             Map<String,dynamic> g=n[e];
            });}).toList())) ,
    ),onWillPop:()async{return false;} );
  }) );
}
  String isValidPasscode(String value)  {
    if(value.isEmpty)
      return 'empty';
    else  if (value.length < 5)
      return 'at least 5 characters';
    else if(value.length>=70)
      return 'must not be more than 70 characters';
       return null;}
  @override
  void initState() {
    super.initState();
    q.text=i.currentUser.displayName==null?null:i.currentUser.displayName;
    w.text=i.currentUser.phoneNumber==null?null:i.currentUser.phoneNumber;
    Files().load(context);
    readJson();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:const Icon(Icons.arrow_back)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient:const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.purple,
                      Colors.purpleAccent,
                    ],
                    stops: [0.2,0.6])),),
          title: Text('place'.tr),),
        body:Form(key: k,child:SingleChildScrollView(padding:EdgeInsets.only(top:Adaptive.h(5)) , child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap:() {pick_photos();},
           child:Column(children:[ListTile(title: Text('\t${"Add photos (Limited 8)".tr}',style: TextStyle(fontSize:Adaptive.sp(17.5))),
             trailing:Icon(Icons.arrow_forward_ios,) ), Container(
          height:140,
              width:MediaQuery.of(context).size.width ,
              decoration:BoxDecoration(
                color:Colors.greenAccent ,
              ),
              child:Container(
                  height:160,
                  width:MediaQuery.of(context).size.width ,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(50) ,
                    color:Colors.green ,
                  ),child:Obx(()=>photos.length>0?

              ListView(
                    reverse: true,
                      scrollDirection:Axis.horizontal,
              children:photos.map((e){return GestureDetector(
                onTap: (){
                  Get.bottomSheet(BottomSheet(onClosing:(){}, builder:(context){
                    return Column(children:hs.map((r){
                      return  TextButton(child:Text(r.tr),onPressed:(){
                        if(r=='Remove')
                          photos.remove(e);
                        Get.back();
                      });
                    }).toList());
                  }));
                },
                child:Padding(padding:EdgeInsets.all(5) ,
                    child: Container(
                  height:80,
                  width:80 ,
                  decoration:BoxDecoration(
                      borderRadius:BorderRadius.circular(25) ,
                      image:DecorationImage(image:FileImage(File(e)) )
                  ) ,
                ) ),
              );}).toList()): Icon(FontAwesomeIcons.camera,color:Colors.greenAccent ,size: Adaptive.sp(30))
          )))])),  Padding(padding:  EdgeInsets.all(Adaptive.sp(20)),  child:
            TextFormField(
              controller:u,
                autovalidateMode:AutovalidateMode.onUserInteraction,
              keyboardType:TextInputType.text ,
              validator:isValidPasscode,
              onChanged:(i){u.text=i;setState((){});} ,
              decoration:  InputDecoration(
                suffixIcon:isValidPasscode(u.text)==null && u.text.length>0?Icon(Icons.done,color:Colors.green):null,
                counter:Text('${u.text.length.toString()}/70') ,
                 enabledBorder:OutlineInputBorder() ,
                focusedBorder: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(borderSide:BorderSide(color:Colors.red )),
                labelText: 'Add Ad Name',
              ) ),
          ),
           Padding(padding: const EdgeInsets.only(top:20,left: 20,right: 20,bottom: 20),  child:
          TextFormField(
            controller: e,
            minLines: 1,
            maxLines:10 ,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              keyboardType:TextInputType.text ,
              onChanged:(i){e.text=i;setState((){});} ,
            validator: Files().Errort,
            decoration:  InputDecoration(
              counter:Text('${e.text.length.toString()}/120') ,
              enabledBorder:OutlineInputBorder() ,
              focusedBorder: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(
                borderRadius:BorderRadius.circular(0),
                  borderSide:BorderSide(color:Colors.red)),
              suffixIcon:Files().Errort(e.text)==null && e.text.length>0?Icon(Icons.done_outline_sharp,color:Colors.green):null,
                labelText:'description'.tr
            )
          )), Padding(padding:  EdgeInsets.all(Adaptive.sp(20)),
                child: Obx(()=>DropdownButtonFormField<String>(
                  value:value.value,
                  validator: Files().Errorph,
                  decoration: InputDecoration(
                    hintText: 'Category'.tr,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w800),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black26),
                      gapPadding: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black26),
                      gapPadding: 16,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black26),
                      gapPadding: 16,
                    ),
                  ),
                  items: vivo.map((item) {
                    return DropdownMenuItem(
                      child: Text(item.tr),
                      value:item,
                      onTap: (){},
                    );
                  }).toList(),onChanged: (r){},),
                )),
            Column(),
            Padding(padding:  EdgeInsets.all(Adaptive.sp(20)),  child:
            TextFormField(
              controller:s,
              keyboardType:TextInputType.number ,
              onChanged:(i){s.text=i;setState((){});} ,
              validator: Files().Errorphs,
              decoration:  InputDecoration(
                labelText: 'Price'.tr,
                enabledBorder:OutlineInputBorder() ,
                focusedBorder: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(borderSide:BorderSide(color:Colors.red )),
                suffixIcon:Files().Errorphs(s.text)==null && s.text.length>0?Icon(Icons.done_outline_sharp,color:Colors.green):null,
              ),
            ),
            ),
            Padding(padding:  EdgeInsets.all(Adaptive.sp(20)),  child:
            TextFormField(
              controller:q,
              validator: Files().Errorphs,
              keyboardType:TextInputType.text ,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              onChanged:(i){q.text=i;setState((){});} ,
              decoration:  InputDecoration(
                enabledBorder:OutlineInputBorder() ,
                focusedBorder: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(borderSide:BorderSide(color:Colors.red )),
                suffixIcon:Files().Errorphs(q.text)==null && q.text.length>0?Icon(Icons.done_outline_sharp,color:Colors.green):null,
                labelText: 'User Name'.tr),
            ),
            ), Padding(padding:  EdgeInsets.all(Adaptive.sp(20)),  child:
            TextFormField(
              textDirection:TextDirection.ltr ,
              keyboardType:TextInputType.phone ,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              controller:w,
              validator: Files().Errorphs,
              decoration:  InputDecoration(
                border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Adaptive.sp(0))) ,
                labelText: 'phone'.tr,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                      w.text=' ';
                   },),
                focusColor: Colors.black,
                hoverColor: Colors.black,
              ),
            ),
            ),
          ],),),),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniCenterDocked ,
      floatingActionButton: ElevatedButton(   style: ElevatedButton.styleFrom(
        primary: Colors.purple ,
        onPrimary: Colors.white, shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)),
        minimumSize: Size(MediaQuery.of(context).size.width/2 ,80), //////// HERE
      ),onPressed: (){
        if(k.currentState.validate()) {}},
          child:Text('Add Ad'.tr,style:TextStyle(fontSize:Adaptive.cm(0.7) , color:Colors.white )
      ))
      );
  }
  void pick_photos(){
  Get.bottomSheet(BottomSheet(onClosing:(){}, builder:(context){
    return Column(children:
    h.map((e) {
      return ListTile(onTap: () async {
        if(photos.length<=8){
        if(e=='camera'){ image = await new ImagePicker().getImage(
            source: ImageSource.camera);
        }
        else if(e=='gallery'){
            image = await new ImagePicker().getImage(
              source: ImageSource.gallery);
        }}
        else
          Toast.show('Unavailable more than 8 Photos',duration:Toast.lengthLong,gravity:Toast.bottom  );
        Get.back();
        if(image !=null){
        photos.add(image.path);
      }},
        title: Text(e.tr, style: TextStyle(
            fontSize: Adaptive.sp(20),
            color: Colors.black),),
        leading: j.elementAt(h.indexOf(e)),
      );
    }).toList()
    );
  }));
 }
}
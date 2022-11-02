import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../modules/Files.dart';

class packages extends StatefulWidget {
  @override
  _packages createState() => _packages();
}

class _packages extends State<packages>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
    Get.back();
    },),actions: [IconButton(onPressed:(){}, icon:Icon(Icons.add) )],
    title: Text('Packages'),
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
    ),),
body: StreamBuilder<QuerySnapshot>(
        stream:ff.collection('/packages').where('uid',isEqualTo: i.currentUser.uid).snapshots() ,
    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
      if (!snapshot.hasData) return Center(child:Text('No Data'));
      else if(snapshot.connectionState==ConnectionState.waiting)
        return CircularProgressIndicator();
      return ListTile(title:Text('') ,);
    }),
    );
  }
}
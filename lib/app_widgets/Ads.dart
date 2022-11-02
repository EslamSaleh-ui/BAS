import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:suggestion_providers/suggestion_providers.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'package:translator/translator.dart';
import 'AD.dart';
import '../authentication/Sign.dart';

class Ads extends StatefulWidget {
  final LinkedHashMap<dynamic, dynamic> dad;
  final String page;
  const Ads({@required this.dad,@required this.page, Key key}) : super(key: key);
  @override
  _Ads createState() => _Ads();}
class _Ads extends State<Ads>  with TickerProviderStateMixin {
  List<String> bar = ['Filter', 'Sort', 'Save Results'];
  final List <Icon> icons = [
    const Icon(FontAwesomeIcons.filter, color: Colors.white),
    const Icon(FontAwesomeIcons.sort, color: Colors.white),
    const Icon(FontAwesomeIcons.save, color: Colors.white)];
  final List <String> filter = ['the newest', 'high prices', 'low prices'];
  final data d = Get.put(data());
  void jiffy() async {await Jiffy.locale(language.val);}
  LinkedHashMap<dynamic, dynamic> g;
  @override
  initState(){
    super.initState();
    if(widget.page=='Favourits')
    g=LinkedHashMap<dynamic, dynamic>.from(widget.dad);}
  @override
  dispose() {
    change();
    super.dispose();}
  @override
  Widget build(BuildContext context) {
    jiffy();
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          bottom: TabBar(
            controller: TabController(vsync: this, length: 3),
            labelColor: Colors.purple,
            indicatorColor: Colors.white,
            tabs: bar.map((e) {
              return Tab(
                  child: Text(e.tr, style: TextStyle(color: Colors.white),),
                  icon: icons.elementAt(bar.indexOf(e)));
            }).toList(),
            onTap: (e) {
             if(e==2)
               save_result();
             else if (e == 1) {
                Get.bottomSheet(
                    BottomSheet(onClosing: () {}, builder: (context) {
                      return Column(children: filter.map((e) {
                        return TextButton(onPressed: () {
                          filter.forEach((element) {
                            widget.dad.removeWhere((key, value) =>
                            value == element);
                          });
                          if (e == 'the newest')
                            Files().write('time', e,widget.dad);
                          else if (e == 'low prices')
                            Files().write('price.asending', e,widget.dad);
                          else if (e == 'high prices')
                            Files().write('price.dsending', e,widget.dad);
                          Files().Querys(widget.dad);
                          Get.back();
                        },
                            child: Text(e.tr));
                      }).toList());
                    }));
              }
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.purple,
                    Colors.purpleAccent],
                  stops: [0.2, 0.6]
              ),
            ),
          ),
          automaticallyImplyLeading: true,
          title: Obx(() =>
              ListTile(
                  title: Text(cvv.value.tr, style: TextStyle(
                      fontSize: Adaptive.sp(18), color: Colors.white)),
                  subtitle: Text(ill.value.tr, style: TextStyle(
                      fontSize: Adaptive.sp(18), color: Colors.white)),
                  leading: Icon(Icons.arrow_drop_down, color: Colors.white,),
            onTap: () { Files().dialog(context,widget.dad);   })   ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => SearchPage());
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: Obx(() =>
            StreamBuilder<QuerySnapshot>(
                stream: stream.value.snapshots(),
                builder: (context, dq) {
                  if (dq.connectionState == ConnectionState.waiting)
                    return new Center(child: CircularProgressIndicator(
                      color: Colors.grey.shade400,),);
                  if (!dq.hasData) return Center(child: Text('No Ads'));
                  final datas = dq.data;
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = dq == null ? {} : datas
                            .docs[index].data() as Map<String, dynamic>;
                        DateTime dt = (data['time'] as Timestamp).toDate();
                        return GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  AD(dad: 'Ads',
                                      Id: datas.docs[index].id));
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius
                                        .circular(10))),
                                color: Colors.white,
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(color: Colors.white,
                                      child: data['image'].isEmpty ||
                                          data['image'] == null ? Center(
                                        child: Text('no photo'),) :
                                      Image.network(
                                          data['image'][0], fit: BoxFit.cover),
                                      height: Adaptive.h(18),
                                      width: Adaptive.w(45),),
                                    Container(height: Adaptive.h(18),
                                      width: Adaptive.w(45),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .stretch,
                                        children: [
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Row(mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                    children: [
                                                      Text(' ${data['name']}',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              locale: Get
                                                                  .locale)),
                                                      IconButton(icon: Stack(
                                                          children: [
                                                            Icon(Icons.star,
                                                                size: Adaptive
                                                                    .sp(25),
                                                                color: Colors
                                                                    .black),
                                                            Icon(Icons.star,
                                                                size: Adaptive
                                                                    .sp(22),
                                                                color: Colors
                                                                    .white),
                                                          ]),
                                                          onPressed: () {
                                                            if (i.currentUser ==
                                                                null)
                                                              Toast.show(
                                                                  'Login Firstly',
                                                                  gravity: Toast
                                                                      .bottom,
                                                                  duration: Toast
                                                                      .lengthLong);
                                                            else {
                                                              d.marks();
                                                              if (!d.favourits
                                                                  .contains(
                                                                  datas
                                                                      .docs[index]
                                                                      .id))
                                                                d.put(datas
                                                                    .docs[index]
                                                                    .id);
                                                              Toast.show("1".tr,
                                                                  gravity: Toast
                                                                      .bottom,
                                                                  duration: Toast
                                                                      .lengthLong);
                                                            }
                                                          })
                                                    ]),
                                                Text(' ${data['price']} LE',
                                                    style: TextStyle(
                                                        locale: Get.locale))
                                              ]),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween, children:
                                          [
                                            FutureBuilder<Translation>(
                                                future: translator.translate(
                                                    data['location']['city'],
                                                    from: 'en',
                                                    to: language.val),
                                                builder: (context, ss) {
                                                  if (ss.connectionState ==
                                                      ConnectionState.waiting)
                                                    return Text('');
                                                  return Text(
                                                      ' ${ss.data.text}',
                                                      style: TextStyle(
                                                          locale: Get.locale));
                                                }),
                                            Text('${ Jiffy(
                                                [dt.year, dt.month, dt.day])
                                                .format("MMM do yyyy")} ',
                                                style: TextStyle(
                                                    locale: Get.locale))
                                          ],)
                                        ],),)
                                  ],))
                        );
                      }, separatorBuilder: (context, index) {
                    if (index % 3 == 0)
                      return Admob();
                    return Text('');
                  },
                      itemCount: datas.size);
                })));
  }
  void save_result(){
    if(i.currentUser==null)
      Get.offAll(()=>Fetch());
    else
    { ff.collection('/users').doc(i.currentUser.uid).update(
        {'searches':FieldValue.arrayUnion([widget.dad]) });
    Toast.show('Results Saved',gravity: Toast.bottom,duration:Toast.lengthLong );
    }   }
  void change()async{
    if (widget.page=='MyHomePage')
    {   Map<String, dynamic> data = new Map<String, dynamic>.from(widget.dad);
      filters.val.clear();filters.val.addAll(data );
      await Filter.removeWhere((key, value) =>
    key != 'location.city' && key != 'location.country');
  }
   else if(widget.page=='Favourits'&& widget.dad !=g)
    {ff.collection('/users').doc(i.currentUser.uid).update({'searches':FieldValue.arrayRemove([g]) });
    ff.collection('/users').doc(i.currentUser.uid).update({'searches':FieldValue.arrayUnion([widget.dad]) });}
  }
}
class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}
class _SearchPage extends State<SearchPage>  {
  var uu=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient:  LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.purple,
                        Colors.purpleAccent],
                      stops: [0.2,0.6])),
            ),
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child:TypeAheadField(
                  getImmediateSuggestions: true,
                  keepSuggestionsOnSuggestionSelected: true,
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: uu,
                      autofocus: false,
                      style: TextStyle(fontSize: Adaptive.sp(15),color: Colors.black,),
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.search,color: Colors.blue,),
                        suffixIcon: IconButton(onPressed: (){
                            uu.text='';}, icon: Icon(Icons.cancel)),
                        border: OutlineInputBorder(),
                      )
                  ),
                  suggestionsCallback: (pattern) async {
                    var brb=  await Suggestions().google.suggestions(pattern);
                    return brb;},
                  itemBuilder: (context, m) {
                    return ListTile(
                      leading: Icon(Icons.search),
                      title: Text(m),
                    ); },
                  onSuggestionSelected: (suggestion) {cvv.value=suggestion;Get.back();}
                )),
            )) );
    }

  }
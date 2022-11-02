import 'dart:convert';
import '../chat/Chat.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_slider/image_slider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modules/Files.dart';
import '../authentication/Sign.dart';
class AD extends StatefulWidget {
  final String Id;
  final String dad;
  const AD({@required this.Id,this.dad, Key key}) : super(key: key);
  @override
  _AD createState() => _AD();
}
class _AD extends State<AD> with   TickerProviderStateMixin  {
  final data  dag=Get.put(data());
  RxString ph=''.obs;
  RxInt inl=0.obs;
  RxString date=''.obs;
  RxString name=''.obs;
  RxString uid=''.obs;
  RxString ad_name=''.obs;
  final h={}.obs;
  final location =''.obs;
  RxBool f=false.obs; final List <String> advices = ["4".tr, "5".tr, "6".tr, "7".tr];
  var t=TextEditingController();
  Animation<double> _animation;
  AnimationController _animationController;
  final GlobalKey<FormState> k=GlobalKey<FormState>();
  List<String> rep=[  'Offensive content','Fraud','Duplicate ad','Product already sold','Other'];
  List<String> Bub1=['Phone Call','Send Message','Copy','Save contact'];
  List<IconData> Bub2=[Icons.phone,Icons.message,Icons.copy,Icons.person];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Get.back(); },),
        backgroundColor:Colors.transparent ,
        shadowColor:Colors.purple ,
        elevation: 6,
       actions: [IconButton(icon:Icon(Icons.share,color:Colors.white ),onPressed:()async{
         final Link=await dag.link(widget.Id);
         Share.share( Link.toString());
       })],
      ) ,
      body:   StreamBuilder<DocumentSnapshot>(
    stream:ff.collection('/ads').doc(widget.Id).snapshots(),
      builder: (context,ds) {
        if (!ds.hasData) return Container();
        else if(ds.connectionState==ConnectionState.waiting)
          return Center(child:CircularProgressIndicator() ,);
        Map<String, dynamic> d =ds.data !=null? ds.data.data() as Map<String, dynamic>:{};
        List<dynamic> img=d['image'];
        ph.value=d['phone'].toString();
        name.value=d['advertiser'].toString();
        date.value=dag.member_date(date, d['uid']);
        uid.value=d['uid'];
        ad_name.value=d['name'];
        Map<String, dynamic> details = d['details'];
       if(h.length>0) h.clear();
        details.forEach((key, value)async {
          var u=await translator.translate(key,to: language.val);
          var uu=await translator.translate(value,to: language.val);
          h.addAll({uu:u});
        if (key.length==details.length)
        {  var f=await translator.translate(d['location']['state'],from: 'en',to: language.val);
          var dn=await translator.translate(d['location']['city'],from:'en' ,to: language.val);
          location.value= '${f.text},${dn.text}';}
        });
        DateTime dt=d['time']==null?DateTime.now():d['time'].toDate() as DateTime;
        String d12 = DateFormat('dd/MM/yyyy').format(dt);
        TabController   tc=TabController(vsync: this,length: img !=null && img.length>0?img.length:1);
        return  ListView(
          children: [
          Stack(
              alignment:AlignmentDirectional.bottomCenter ,
              children: [GestureDetector(
                  onTap:img.length>0? (){ImageViewer(img.map((e){
                    return  Image.network(e).image;
                  }).toList());}:null ,
                  child:img.length>0?
              ImageSlider(tabController:tc,
                showTabIndicator: true,
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height/3 ,
                children: img.map((e) { return new  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(e,
                      width: MediaQuery.of(context).size.width,
                      height:MediaQuery.of(context).size.height/3 ,
                      fit: BoxFit.cover
                    ));}).toList(),
              ): Container(
        width: double.infinity,
        height:350,child: Center(child:Text( 'no photos',style:TextStyle(fontSize: 20,locale:Get.locale ))
              ) )),
                Container(
              width: double.infinity,
              height:150
              ,decoration:BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape:BoxShape.rectangle ) ,
              child:Column(
             crossAxisAlignment: CrossAxisAlignment.start
                ,children: [Text('  ${d['name']}',style:TextStyle(color:Colors.white,fontSize:25,locale:Get.locale)),
                Divider(color:Colors.white ,thickness: 1),
                Text(' ${d['price']}  LE',style:TextStyle(color:Colors.white,fontSize:25,locale:Get.locale)),
                Divider(color:Colors.white ,thickness: 1),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [IconButton(onPressed:widget.dad=='Myads'||
                  (i.currentUser!=null &&uid.value==i.currentUser.uid)?null:(){
                if(i.currentUser ==null)
                  Toast.show('Login Firstly', gravity: Toast.bottom, duration: Toast.lengthLong);
              else{ dag.marks();
                if(!dag.favourits.contains(widget.Id))
                dag.put(widget.Id);
                Toast.show("Added to favourites", gravity: Toast.bottom, duration: Toast.lengthLong);}
              }, icon:widget.dad=='Myads'||(i.currentUser!=null &&uid.value==i.currentUser.uid)?Row(children:
              [ Icon(Icons.star,color:Colors.white,size:16)
                ,Text('${d['favourit']}',style:TextStyle(color:Colors.white)),] )
                  :Icon(Icons.star,color:Colors.white,size:25),),
                IconButton(onPressed:widget.dad=='Myads'||(i.currentUser!=null &&uid.value==i.currentUser.uid)?null:(){
                  if(i.currentUser ==null)
                    Toast.show('Login Firstly', gravity: Toast.bottom, duration: Toast.lengthLong);
                  else
                    {
                      Get.bottomSheet(BottomSheet(onClosing:(){}, builder:(context){
                        return ListView(
                            children: [
                              Text('  ${"Ad Report".tr}',style:TextStyle(fontSize: 25 )),
                         Column(children: rep.map((e){
                            return Obx(()=>RadioListTile(title:Text(e.tr) , value:rep.indexOf(e), groupValue:inl.value ,
                                onChanged:(e){
                                  inl.value=e;
                                }));
                          }).toList() ),
                          Form(key:k,
                              child:new TextFormField(
                                controller: t,
                                validator: Files().Errorph,
                                decoration:  InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),suffixIcon: IconButton(icon:Icon(Icons.close),onPressed:(){t.text='';}),
                                  labelText: 'Comment'.tr,
                                  hintText: 'Comment'.tr,
                                  focusColor: Colors.black,
                                  hoverColor: Colors.black,
                                ),
                              ) ),
                           Row(mainAxisAlignment:MainAxisAlignment.end
                             ,children: [TextButton(child:Text('Cancel'.tr,style:TextStyle(color:Colors.red ) ,) ,onPressed:(){Get.back();}),
                                    TextButton(child:Text('Send'.tr,style:TextStyle(color:Colors.blue ) ,) ,onPressed:(){
                                      if(k.currentState.validate())
                                        {send_email(rep.elementAt(inl.value),t.text);
                                          t.text='';Get.back();
                                        Toast.show("sent".tr, gravity: Toast.bottom, duration: Toast.lengthLong);
                                        }  })
                                    ],) ]);
                      }) ); }
                }, icon:widget.dad=='Myads' || (i.currentUser!=null && uid.value==i.currentUser.uid )?Row(children:
                [ Icon(Icons.remove_red_eye,color:Colors.white,size:16)
                  ,Text('${d['views']}',style:TextStyle(color:Colors.white)),] )
                    :Icon(Icons.flag,color:Colors.red.shade700,size:25))
              ])
              ],) ,
            )])
,ListTile(title:Text(' '+'${d['category']}'.tr,style:TextStyle(fontWeight: FontWeight.bold) ,),
        subtitle:Obx(()=>location.value==''?Center(child:Container()):Row(children: [Icon(Icons.place),Text(location.value)]) ),
          trailing:Text('$d12')),
          Divider(color:Colors.black ,thickness: 0.5),
          Text('  ${'details'.tr}',style:TextStyle(fontWeight: FontWeight.bold)),
          Obx(()=>h.length==0?Center(child:Container()):Column(children:
          h.keys.map((value)  {
         return Column(children: [
           ListTile(title:Text('${h[value]}',style:TextStyle(fontWeight: FontWeight.bold)),
             trailing:Text('${value}'),),
           Divider(color:Colors.black ,thickness: 0.25)],);
          }).toList())),
          ListTile(title:Text('description'.tr,style:TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${d['description']}')),
       Container(child:widget.dad=='Myads' || (i.currentUser!=null &&uid.value==i.currentUser.uid)?null: Obx(()=> ListTile(
           leading: CircleAvatar(child:Image.asset('asset/images/icons/download1.png')) ,
           title:Text(name.value),
          subtitle:RichText(text:TextSpan(children:[TextSpan(text:'Member from:${date.value}\n'
              ,style:TextStyle(color:Colors.black)),
              TextSpan(text:'Show all ads'.tr,style:TextStyle(color:Colors.blue) )] ) ,) ,
              trailing:f.value?Icon(Icons.arrow_forward_ios):Icon(Icons.arrow_back_ios) ,
          onTap:(){
             f.toggle();
          } ,
         ))),
         Obx(()=>f.value && widget.dad!='Myads'&& (i.currentUser!=null &&uid.value!=i.currentUser.uid)?user_ads(d['uid']):Container()) ,
            Divider(color:Colors.black ,thickness: 0.5),
            widget.dad!='Myads' || (i.currentUser!=null &&uid.value==i.currentUser.uid)?Admob():Container(),
            Divider(color:Colors.black ,thickness: 0.5),
            Text('  ${"Ad published in".tr}',style:TextStyle(fontSize:20)),
            GestureDetector(
            onTap:()async{
              List<Location> locations = await locationFromAddress('${d['location']['state']}, ${d['location']['city']}');
              Get.to(()=>maps(locations.first.latitude,locations.first.longitude));} ,
            child: Container(
                decoration:BoxDecoration(
        image:DecorationImage(image:AssetImage('asset/images/image.jpg'),
        colorFilter:ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.colorBurn)),
              ),  height:MediaQuery.of(context).size.height/3,
                  width:MediaQuery.of(context).size.width,padding:EdgeInsets.all(5)  )) ,
        Divider(color:Colors.black ,thickness: 0.5),
            widget.dad=='dynamic'? ListTile(title:Text('Important Advices'.tr) ,
            subtitle:Column(children:advices.map((e) {
              return Text('-${e}');
            }).toList()) ,focusColor:Colors.orange):Spacer()
        ],);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: widget.dad=='Myads'?
        Container()
            : Column(
            mainAxisAlignment:MainAxisAlignment.end ,
            children: [
              FloatingActionBubble(backGroundColor:Colors.purple,
                iconColor:Colors.white,
                onPress:()=> _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward(), items:
                Bub1.map((e){
                  return  Bubble(
                    title:e.tr,
                    iconColor :Colors.white,
                    bubbleColor : Colors.purple,
                    icon:Bub2.elementAt(Bub1.indexOf(e)),
                    titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
                    onPress: () {
                      if(i.currentUser!=null &&uid.value==i.currentUser.uid)
                        Toast.show("Unavailable It‘s your ad", gravity: Toast.bottom, duration: Toast.lengthLong);
                      else{
                      if(e=='Phone Call')
                        laun("tel:+${ph.value}");
                      else if(e=='Send Message')
                        laun('sms:+${ph.value}');
                      else if(e=='Copy')
                      { Clipboard.setData(ClipboardData(text:ph.value ));
                      Toast.show("Copied to Clipboard", gravity: Toast.bottom, duration: Toast.lengthLong);
                      }
                      else{FlutterContacts.openExternalInsert();}}
                    },
                  );
                }).toList(),
                iconData:Icons.phone, animation: _animation ,
              ),Container(color:Colors.white ,  child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Padding(padding:EdgeInsets.all(5),
                      child: ElevatedButton(onPressed: ()  {
                        if(i.currentUser==null )
                          Get.to(()=>Fetch());
                        else if( uid.value==i.currentUser.uid)
                          Toast.show("Unavailable".tr, gravity: Toast.bottom, duration: Toast.lengthLong);
                        else
                          login_chat(uid1:i.currentUser.uid,uid2:uid.value);} ,
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) )
                              ,primary:Colors.black,
                              maximumSize: Size(MediaQuery.of(context).size.width/2 ,50), //////// HERE
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.chat,color:Colors.white), Text('  ${"chat".tr}',style:TextStyle(color:Colors.white ))],))

                  ) ,ElevatedButton(   style: ElevatedButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(borderRadius:BorderRadius.circular(50) )
                      ,maximumSize:Size(MediaQuery.of(context).size.width/2 -10, 50),primary:Colors.black  //////// HERE
    ),onPressed: (){
                        if(i.currentUser==null )
                          Get.to(()=>Fetch());
                        else if( uid.value==i.currentUser.uid)
                          Toast.show("Unavailable".tr, gravity: Toast.bottom, duration: Toast.lengthLong);
                        else
                          login_chat(uid1:i.currentUser.uid,uid2:uid.value,offer: '8'.tr);
                      },
                      child:Row(mainAxisAlignment:MainAxisAlignment.start,
                        children: [ImageIcon(AssetImage('asset/images/icons/price-tag.png',),color:Colors.white), Text('  ${"offer".tr}',style:TextStyle(color:Colors.white ))],))]
              ))
            ])
    );
  }
  void ImageViewer(List<ImageProvider<Object>> k) {
    MultiImageProvider multiImageProvider = MultiImageProvider(k);
    showImageViewerPager(context, multiImageProvider,
        onPageChanged: (page) {
          Toast.show("Page changed to ${page+1}", gravity: Toast.bottom,
              duration: Toast.lengthLong);
        }, onViewerDismissed: (page) {
          Toast.show(
              "Dismissed while on page ${page+1}", gravity: Toast.bottom,
              duration: Toast.lengthLong);
        });
  }
  void login_chat({@required String uid1,@required String uid2,String offer})async
  {   if(i.currentUser.uid != null)
    {
    await   ff .collection('/chats').where('user2' ,isEqualTo :uid1).
  where('user1' ,isEqualTo :uid2)
      .snapshots().listen((event) {
    if(event.size==1)
    {event.docs.forEach((e) {
      Get.to(()=>Chat(chatId:e.id,offer: offer,)); });}
    else
    {
      ff .collection('/chats').where('user1' ,isEqualTo :uid1).
      where('user2' ,isEqualTo :uid2)
          .snapshots().listen((event) {
        if(event.size==1)
        {event.docs.forEach((e) {
          Get.to(()=>Chat(chatId:e.id,offer:offer)); });}
        else
        {  dag.rege_chat(uid2:uid.value,ad:ad_name.value, uid1:i.currentUser.uid,offer: offer );
        ff.collection('/ads').doc(widget.Id).
        update({'chats':FieldValue.increment(1) });}
      }); }
  });}
  else
    Toast.show("Login Firstly".tr, gravity: Toast.bottom, duration: Toast.lengthLong);
  }
  void laun(String lan)async
  {if(await canLaunch(lan) )
  { await launch(lan);
  await ff.collection('/ads').doc(widget.Id).
  update({'calls':FieldValue.increment(1) });}
    else
    Toast.show("Something went Error", gravity: Toast.bottom, duration: Toast.lengthLong);
  }
  void send_email(String reason,String comment)
  async{
    final url=Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await http.post(url,
        headers: {
          'origin':'http://localhost',
          'Content-Type':'application/json'
        },
        body:jsonEncode({
          'service_id':'service_v8o8reb',
          'template_id':'template_3wg93vc',
          'user_id':'user_RgzN069dm5Icl0OtLCVIn',
          'template_params':{
            'user_name':'${i.currentUser.displayName}',
            'user_subject':'Complain Ad ${widget.Id}',
            'user_message':'reason:${reason}',
            'user_messager':'comment:${comment}'
          }
        })
    ).catchError(
            (e){
          Toast.show(e,gravity: Toast.bottom,duration:Toast.lengthLong );
        }
    );
  }
  Widget user_ads(String uid)
  {
    return StreamBuilder<QuerySnapshot>(
      stream: ff.collection('/ads').where('uid',isEqualTo:uid ).snapshots(),
        builder:(context,dq){
          if(!dq.hasData) return Container();
  return Container(
    color: Colors.white,
    height:MediaQuery.of(context).size.height/5 ,
    width: MediaQuery.of(context).size.width,
    child:ListView(
 scrollDirection:Axis.horizontal ,
  children: dq.data.docs.map((DocumentSnapshot document) {
          Map<String,dynamic> data=document.data() as Map<String,dynamic>;
          DateTime dt =  (data['time'] as Timestamp).toDate();
          String d12 = DateFormat('dd-MM-yyyy,hh:mm a').format(dt);
          return GestureDetector(
              onTap: (){},
              child:Card(
                color:Colors.grey.shade200,
                margin: EdgeInsets.all(10),
                child:
                    Row(children:[
                      Stack(children: [
                        Container(color: Colors.white70,
                          child:data['image'].isEmpty || data['image']==null?Center(child:Text('no photo') ,):
                          Image.network(data['image'][0],fit: BoxFit.cover),
                          height:MediaQuery.of(context).size.height/5,width:MediaQuery.of(context).size.width/3,),
                        IconButton(icon:Icon(Icons.star,size:30,color:Colors.blueGrey),
                            onPressed:(){
                              if(i.currentUser ==null)
                                Toast.show('Login Firstly'.tr, gravity: Toast.bottom, duration: Toast.lengthLong);
                              else{ dag.marks();
                              if(!dag.favourits.contains(widget.Id))
                                dag.put(widget.Id);
                              Toast.show("1".tr, gravity: Toast.bottom, duration: Toast.lengthLong);}
                            })   ]),
                      Container(height: MediaQuery.of(context).size.height/5,
                        width: MediaQuery.of(context).size.width/2,
                        child:  Column ( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [ Text(' ${data['name']}',style:TextStyle(fontSize:20)),Text(' ${data['price']} LE')],),
                            Text(' ${data['location']['city']}'),
                            Divider(height:20,color: Colors.black,),
                            Row(crossAxisAlignment:CrossAxisAlignment.start,children: [Text('${d12}',style:TextStyle(fontSize:15)),],)
                          ],),)
                    ],) )
          );}).toList()));
        } );
  }

}
class maps extends StatefulWidget {
  final double long;
  final double lati;
  const maps(this.long,this.lati,{Key key}) : super(key: key);
  @override
  _maps createState() => _maps();
}
class _maps extends State<maps>  {
  CircleId cid=CircleId('1');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text('Ad Location'.tr) ,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient:const  LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.purple,
                             Colors.purpleAccent],
                    stops: [0.2,0.6]
                ),
              ),)
        ),
      body:GoogleMap(initialCameraPosition:CameraPosition(
        target: LatLng(widget.long,widget.lati),
        zoom: 14.4746,
      ), mapType: MapType.normal,
      circles:{Circle(circleId: cid,
        radius:600,
        center:LatLng(widget.long,widget.lati),
        fillColor:Colors.blue.shade200,
        strokeColor: Colors.blue.shade200
      )} ,) ,
    );  } }
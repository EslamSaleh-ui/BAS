import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/chat/Chat.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:translator/translator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../app_widgets/City.dart';
FirebaseAnalytics fa =FirebaseAnalytics.instance;
FirebaseMessaging fbm=FirebaseMessaging.instance;
CollectionReference  cr=ff.collection('/chats');
FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: fa);
final GoogleSignIn g = GoogleSignIn(scopes: ['email']);
FacebookLogin v= FacebookLogin();
final box = GetStorage();
var ff=FirebaseFirestore.instance,i=FirebaseAuth.instance;
final language='en'.val('locale'),Var=0.obs,login=''.val('login'),ill='Choose Location'.obs, routing=true.obs
,Countryees=''.val('country'),vs=''.val('code'),
query1=ff.collection('/ads').where('location.country',isEqualTo:Countryees.val).obs,filters={}.val('filters'),
Filter={}.obs,stream=query1.value.obs, cvv='Choose Category'.obs,city={}.val('City')
, c_code=''.val('c_code'), wbs=0.obs,loca='City'.obs,currency=''.val('currency');
GoogleSignInAccount x;
final translator = GoogleTranslator();
int y;
class Files{
 String vv;
 void Querys(LinkedHashMap<dynamic, dynamic> base){
  stream.value=query1.value;
   base.forEach((key, value) {
    switch(key)
    {case 'category':
     stream.value=stream.value.where('category',isEqualTo:value );
     break;
     case 'location.city':
      stream.value=stream.value.where('location.city',isEqualTo:value );
      break;
     case 'price.asending':
      stream.value=stream.value.orderBy('price' );
      break;
     case 'price.dsending':
      stream.value=stream.value.orderBy('price',descending: true );
      break;
     case 'time':
      stream.value=stream.value.orderBy('time',descending: true );
      break;
    }
   });
 }
 void write(String key,String value1,LinkedHashMap<dynamic, dynamic> base){
  if(base.containsKey(key))
   base.update(key, (value) => value1.toString());
   else
   base.addAll({key:value1}); }
 void dialog(BuildContext context,LinkedHashMap<dynamic, dynamic> base)async{
 var g=await translator.translate(Countryees.val,to: language.val);
 showDialog(context: context, builder: (context){
 return SimpleDialog(
 title:ListTile(title: Text('Choose Location'.tr,style: TextStyle(fontSize: Adaptive.sp(20))),
 trailing:IconButton(onPressed:(){Navigator.pop(context); }, icon:Icon(Icons.close)) ),
 children: [city.val.length==0?Container():
 InkWell(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children:[
 Container(height:30,width:double.infinity ,child:Text('recently'.tr,style: TextStyle(fontSize: Adaptive.sp(20),color: Colors.black)),decoration: BoxDecoration(color: Colors.grey.shade500),) ,
  Column(children:city.val.keys.map((key) {
  return TextButton( child:Text('${city.val[key]}',style: TextStyle(fontSize: Adaptive.sp(19),color: Colors.black)),onPressed:city.val=='no results'?null: (){
    ill.value=city.val[key];
    write('location.city',city.val[key],base);
    Querys(base);
    Navigator.of(context).pop();
   });
 }).toList())
 ]  ),
 ),
 Divider(height: Adaptive.sp(8),thickness:Adaptive.sp(5),color: Colors.black26,),
 TextButton(onPressed: (){
  ill.value=Countryees.val;
  write('location.country',Countryees.val,base);
  base.removeWhere((key, value) => key=='location.city');
  Querys(base);
  Navigator.of(context).pop();
 }, child:Text('${'Whole Country'.tr} ${g}',style: TextStyle(fontSize: Adaptive.sp(20),color: Colors.black)), ),
 Divider(height: Adaptive.sp(8),thickness:Adaptive.sp(5),color: Colors.black26,),
 TextButton(onPressed: (){
 Get.back();
 Get.to(()=>City(dad:base));
 }, child:Row(
 crossAxisAlignment:CrossAxisAlignment.center,
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 Icon( Icons.my_location,color: Colors.blue.shade600,),
 Text(' ${'Choose Location'.tr}',style: TextStyle(fontSize: Adaptive.sp(20),color: Colors.black)),
 ])  )]    );
 });
}
 load(BuildContext context)async{
  Loader.show(context,overlayColor:Colors.black.withOpacity(0.5) ,
      progressIndicator: Row(crossAxisAlignment: CrossAxisAlignment.center,
   mainAxisAlignment: MainAxisAlignment.center,
   children: [CircularProgressIndicator(color:Colors.lightBlue),Text(' '),Text("load".tr,style: TextStyle(color: Colors.white,fontSize: Adaptive.sp(20)))]  ));

  await Future.delayed(Duration(seconds: 3),(){Loader.hide();});
 }
 String  ErrorP (String c)
 {
  String v= r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp S=new RegExp(v);
  if(c.isEmpty)
   return "error1".tr;
  else if(!S.hasMatch(v) )
   return   "uppercase".tr;
 }
 String Error (String c)
 {
  if(c.isEmpty)
   return "error1".tr;
  else  if(! c.contains('@') )
   return  'invalid Email Format'.tr;
  else if (! c.contains('.com') )
   return   'invalid Email Format'.tr;
 }
 String Errort (String c)
 {
  if(c.isEmpty)
   return "error1".tr;
  else if(c.length <50)
   return 'must be more than 50 character';
  return null;
 }
 String Errorph (String c)
 {
  if(c==null || c.isEmpty)
   return "error1".tr;
 }
 String  Errorotp (String c)
 {
  if(c.isEmpty)
   return "error1".tr;
  else  if (c.length != 6)
   return 'OTP must be of 6 digit'.tr;
 }
 String Errorphs (String c)
 {
  if(c.isEmpty)
   return "error1".tr;
  else if (c.length < 5)
   return 'must be at least 6 Chars'.tr;
 }
 void After_login()async{
  await  observer.analytics.logEvent(name: 'login');
  await observer.analytics.setUserId(id: i.currentUser.uid);
  await ff.collection('/users').doc(i.currentUser.uid).update(
      {  'token':await  fbm.getToken()  });
 }
 void rege()async{
  await ff..collection('/users').doc(i.currentUser.uid).set(
      {
       "email":i.currentUser.email,
       'number':i.currentUser.phoneNumber==null?'00000':i.currentUser.phoneNumber,
       'favourites':[],
       'searches':[],
       'location':'0',
       'member_date': FieldValue.serverTimestamp()
      }
  );
 }
 static String get ad_link
 {if(kDebugMode)
  return BannerAd.testAdUnitId;
  else{
  if (GetPlatform.isAndroid)
  return 'ca-app-pub-6147850335148644/2328466045';
 else if(GetPlatform.isIOS)
  return 'ca-app-pub-6147850335148644/9444183519';
 else
  throw Exception('unsupported Platform');}
 }
}
class Admob extends StatefulWidget {
 @override
 _Admob createState() => _Admob();}
class _Admob extends State<Admob>  {
 BannerAd myBanner;
 @override
 void initState() {
  super.initState();
  myBanner = BannerAd(
   request: AdRequest(),
   size: AdSize.largeBanner,
   adUnitId: Files.ad_link,
   listener: BannerAdListener(
       onAdLoaded:(ad){Container(child:Center(child:CircularProgressIndicator())) ;}
   ),);
  myBanner.load();}
 @override
 void dispose() {
  myBanner.dispose();
  super.dispose();}
 @override
 Widget build(BuildContext context) {
  return  Container(width:double.infinity ,
      alignment:Alignment.center ,
      color: Colors.grey.shade100,
      height:myBanner.size.height.toDouble(),
      child: AdWidget(ad: myBanner));
 } }
class data extends GetxController {
 final favourits=[].obs;
 final visible=true.obs;
 final selected=true.obs;
 StreamController<QuerySnapshot> sc1,sc2;
 Map<String, dynamic> paymentIntentData;
 Query s1,s2;
 void add()
 {s2.snapshots().listen((event) {
  sc2.add(event);
 });
 s1.snapshots().listen(( event) {
  sc1.add(event);
 });
 }
 void add1()
 {   cr.where('user2',isEqualTo: i.currentUser.uid).where('archived.${i.currentUser.uid}',isEqualTo: 'true').snapshots().listen((event) {
  sc1.add(event);
 });
 cr.where('user1',isEqualTo: i.currentUser.uid).where('archived.${i.currentUser.uid}',isEqualTo: 'true').snapshots().listen((event) {
  sc2.add(event);
 });
 }
 void marks()
 {
   ff.collection('/users').doc(i.currentUser.uid).snapshots().listen((event) {
    favourits.clear();
    final ads= RxList<dynamic>.from(event.get('favourites') );
    ads.forEach((element) { favourits.add(element); });
  });
 }
 String member_date(RxString v,String uid)
 {
  ff.collection('/users').doc(uid).snapshots().listen((event) {
   DateTime dt=event.get('member_date')==null?DateTime.now():event.get('member_date').toDate() as DateTime;
   v.value = DateFormat('dd/MM/yyyy').format(dt);
  });
  return v.value;
 }
 void marks_searches()
 {
  ff.collection('/users').doc(i.currentUser.uid).snapshots().listen((event) {
   favourits.clear();
   final ads= RxList<dynamic>.from(event.get('searches') );
   ads.forEach((element) { favourits.add(element); });
  });
 }
void remove(String id)
{
 ff.collection('/ads').doc(id).update({
  'favourit':FieldValue.increment(-1)});
 ff.collection('/users').doc(i.currentUser.uid).update(
     {'favourites':FieldValue.arrayRemove(['${id}']) });
}
 void remove_(String id)
 {
  ff.collection('/users').doc(i.currentUser.uid).update(
      {'searches':FieldValue.arrayRemove(['${id}']) });
 }
 void remove_all(RxList<dynamic> id)
 {
  id.forEach((element) {
   ff.collection('/ads').doc(element).update({
    'favourit':FieldValue.increment(-1)});
   ff.collection('/users').doc(i.currentUser.uid).update(
       {'favourites':FieldValue.arrayRemove(['${element}']) });
  });
 }

 void remove_all_(RxList<dynamic> id)
 {
  id.forEach((element) {
   ff.collection('/users').doc(i.currentUser.uid).update(
       {'searches':FieldValue.arrayRemove(['${element}']) });
  });
 }
 void put(String id)
 {
  ff.collection('/ads').doc(id).update({
   'favourit':FieldValue.increment(1)});
  ff.collection('/users').doc(i.currentUser.uid).update(
      {'favourites':FieldValue.arrayUnion(['${id}']) });}
 void put_(String id)
 {
  ff.collection('/users').doc(i.currentUser.uid).update(
      {'searches':FieldValue.arrayUnion(['${id}']) });}
 void take(){
  s1= cr.where('user2',isEqualTo: i.currentUser.uid).
  where('archived.${i.currentUser.uid}',isEqualTo: 'false');
  s2=cr.where('user1',isEqualTo: i.currentUser.uid)
      .where('archived.${i.currentUser.uid}',isEqualTo: 'false');}
 void broad(){
  sc1=StreamController.broadcast();
  sc2=StreamController.broadcast();
 }

 Future<Uri> link(String id)async{
  String url="https://esl123.page.link";
  final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('$url/$id/${language.val}'),
      uriPrefix: url,
      androidParameters:  AndroidParameters(packageName: "com.example.flutter_app",minimumVersion: 0),
      iosParameters:  IOSParameters(bundleId: "com.example.flutter_app",minimumVersion:"0"),
      socialMetaTagParameters:SocialMetaTagParameters(title:'BAS',description: '' )
  );
  final  dynamicLink =
  await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  return dynamicLink.shortUrl;
 }
 void rege_chat({@required String uid1,@required String uid2,@required String ad,String offer})async{
  await ff..collection('/chats').add(
      {
       "ad":ad,
       'archived':{uid1:"false",
                  uid2:"false"},
       'block':{uid1:"false",
        uid2:"false"},
       'marked':{uid1:"false",
        uid2:"false"},
       'unread':{uid1:0,
        uid2:0},
       'user1':uid1,
       'user2':uid2,
      }
  ).then((value){
   Get.to(()=>offer !=null?Chat(chatId: value.id,offer:offer):Chat(chatId: value.id));
  });
 }
 Future<void> makePayment() async {
  try {
   paymentIntentData =
   await createPaymentIntent('30', currency.val);
   await Stripe.instance.initPaymentSheet(
       paymentSheetParameters: SetupPaymentSheetParameters(
          googlePay: true,
           paymentIntentClientSecret: paymentIntentData['client_secret'],
           style: ThemeMode.light,
           merchantDisplayName: 'ANNIE')).then((value){
    displayPaymentSheet();
   });
  } catch (e, s) {}
 }
 displayPaymentSheet() async {
  try {
   await Stripe.instance.presentPaymentSheet(
       parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData['client_secret'],
        confirmPayment: true,
       )).then((newValue){
Get.snackbar('','Paid Successfully',backgroundColor: Colors.green,colorText:Colors.white,snackPosition:SnackPosition.BOTTOM );
    paymentIntentData = null;

   }).onError((error, stackTrace){
    Get.snackbar('',error,backgroundColor: Colors.red);
   });
  } on StripeException catch (e) {
   Get.snackbar('','Exception/DISPLAYPAYMENTSHEET==> $e',backgroundColor: Colors.red,snackPosition:SnackPosition.BOTTOM);
  } catch (e) {}
 }
 createPaymentIntent(String amount, String currency) async {
  try {
   Map<String, dynamic> body = {
    'amount': calculateAmount(amount),
    'currency': currency,
    'payment_method_types[]': 'card'

   };
   print(body);
   var response = await http.post(
       Uri.parse('https://api.stripe.com/v1/payment_intents'),
       body: body,
       headers: {
        'Authorization': 'Bearer sk_test_51Kvqp7AX0jo6diTptlUpAJRY2ybl00VoUSj1qLrmlJaYwkXmNj99tg73z7YIqR0cF4408RI88p0RVumVuBSAC8C3003sbLhbTC',
        'Content-Type': 'application/x-www-form-urlencoded'
       });
   return jsonDecode(response.body);
  } catch (err) {
   Get.snackbar('','Exception/DISPLAYPAYMENTSHEET==> $err',backgroundColor: Colors.red,snackPosition:SnackPosition.BOTTOM);
  }
 }
 calculateAmount(String amount) {
  final a = (int.parse(amount))*100 ;
  return a.toString();
 }
}
class errors extends StatelessWidget{
 @override
 Widget build(BuildContext context) {
  return  WillPopScope(child:Scaffold(
   appBar:AppBar(title: Text('Re-connect your wifi'.tr),
       flexibleSpace: Container(
        decoration: BoxDecoration(
         gradient: const LinearGradient(
             begin: Alignment.topRight,
             end: Alignment.bottomLeft,
             colors: [
              Colors.purple,
              Colors.purpleAccent,],
             stops: [0.2,0.6]
         ),
        ),
       )) ,
   body:Center(child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [Padding(padding:EdgeInsets.only(bottom:5) ,child:Icon(Icons.wifi,color:Colors.grey.shade500,size:Adaptive.sp(45))),
     Text('no Internet Connection'.tr,style: TextStyle(fontSize:Adaptive.sp(20),color: Colors.deepPurpleAccent ),),
    ],
   ),),
  ),onWillPop:()
  async{return routing.value;});
 }
}
class Languages implements Translations{
  @override
  Map<String, Map<String, String>> get keys =>{
   "ar":{
    "Add photos (Limited 8)":"ضع صور مسموح حتى (8 فقط)",
    "Ad Report":"بلغ عن الاعلان",
    "Offensive content":"محتوى غير لائق",
    "Fraud":"احتيال",
    "Duplicate ad":"إعلان مكرر",
    "Product already sold":"تم بيعه بالفعل",
    "Other":"آخر",
    "Phone Call":"مكالمة",
    "Send Message":"أرسل رسالة",
    "Send":"أرسل",
    "Copy":"نسخ",
    "messages":"الرسائل",
    "recently":"المستخدم أخيرا",
    "Important Information":"معلومات تهمك",
    "must be at least 6 Chars":"يجب أن يحتوى على 6 حروف عالاقل",
    "OTP must be of 6 digit":"الكود يجب أن يكون 6 حروف فقط",
    "Save contact":"حفظ الاتصال",
    "Save":"حفظ",
    "login": "تسجيل الدخول",
    "email": "أدخل البريد الالكترونى",
    "phone": "أدخل الهاتف",
    "code":"أدخل الكود",
    "codes":"أختر كود البلد الخاص بك",
    "password": "أدخل رمز المرور",
    "f_password": "نسيت رمز المرور",
    "question": "ليس لديك حساب؟",
    "register": "سجل الان",
    "Register Email":"سجل بريدك الالكترونى",
    "Verification":"تم أرسال بريد التحقق",
    "Ad published in":"تم نشر الاعلان فى",
    "sent":"تم الإرسال",
    "Important Advices":"نصائح تهمك",
    "description":"الوصف",
    "Verify":"التحقق",
    "Verify Phone Number":"تسجيل رقم الهاتف",
    "by": "تسجيلك للدخول موافقة على",
    "terms": "شروط الاستخدام",
    "Invalid Phone Number":"رقم الهاتف خاطي",
    "Reset":"إعادة ضبط",
    "you":"أنت",
    "Other User":"المستخدم الاخر",
    "already":"الهاتف مسجل بالفعل",
    "gmail":"تسجيل الدخوول بالايميل",
    "google":"تسجيل الدخول بحساب جوجل",
    "facebook":"تسجيل الدخول بحساب فيسبوك",
    "ph":"تسجيل الدخول بالهاتف",
    "Remove":"حذف",
    "Choose Category":"أختر الفئة",
    "Cancel":"ألغاء",
    "invalid Email Format":"البريد الالكترونى خاطى",
    "Comment":"ضع تعليفك",
    "Edit":"عدل",
    "promote":"زود مشاهدات",
    "share":"مشاركة",
    "homes": "عقارات",
    "car": "سيارات",
    "mobile": "هواتف واكسسوارها",
    "tv": "أجهزة منزلية",
    "decor": "أثاث منزلى",
    "fashion": "الموضة والجمال",
    "pets": "حيوانات أليفة",
    "kids": "مستلزمات أطفال",
    "jobs": "وظائف",
    "book": "هوايات-رياضة-كتب",
    "trade": "تجارة-زراعة-صناعة",
    "service": "خدمات",
    "error1": "هذا الحقل مطلوب",
    "Home": "الرئيسية",
    "Ads": "الاعلانات",
    "Searches":"نتائج",
    "My": "إعلاناتى",
    "us":"دردش معنا",
    "chat": "دردشة",
    "chats":"دردشة",
    "calls":"مكالمات",
    "views":"مشاهدات",
    "favourit":"أعجاب",
    "best": "المفضلات",
    "add image":"أضافة صورة",
    "1":"تم الاضافة للمفضلات",
    "2":"تم الحذف",
    "3":"هل تريد حذف جميع الاعلانات؟",
    "4":"قابل العميل فى مكان عام ومزدحم مثل المترو أو محطة الاتوبيس",
    "5":"لا تذهب لمقابلة البائع /المشترى بمفردك اصطحب صديق",
    "6":"أفحص المنتج بدقة قبل أستلامه",
    "7":"لا تقم بتحويل أموال قبل أستلام وفحص منتجك",
    "8":"أريد أن أقدم لك عرضا",
    "9":"هل أنت متاكد من أنك تريد حذف الحساب ؟",
    "10":"سبب طلبك (أختيارى)",
    "Ad Link (Optional)":"رابط الاعلان (أختيارى)",
    "Login Firstly":"سجل دخولك أولا",
    "Only marked with star":"المفضلة فقط",
    "unread":"الغير مقروء",
     "offer":"عرض",
    "All Answers":"جميع الرسائل",
    "Send OTP":"أرسل الكود",
    "uppercase":"يجب أن يكون 8 حروف عالاقل ,مكون من حروف ,أرقام  ورموز",
    "Ad Location":"موقع الاعلان",
    "Enter Email":"أدخل بريدك ألالكترونى",
    "Unavailable":"غير متاح هذا إعلانك",
    "My Chats":"دردشتى",
    "place": "أضافة إعلان",
    "contact": "تواصل معنا",
    "country": "أختر البلد",
    "lang": "أختر اللغة",
    "Category":"الفئة",
    "Confirm":"تأكيد",
    "Setting":"الاعدادات",
    "Deleted":"تم حذف الحساب بنجاح",
    "about": "عن التطبيق",
    "details":"التفاصيل",
    "Change profile Details":"تعديل المعلومات الشخصية",
    "change Password":"تغيير الرقم السرى",
    "Change Email":"تغيير البريد الالكترونى",
    "System Mode Setting":"تغيير الوضع",
    "Upgrade Application":"تطوير التطبيق",
    "Delete Account":"حذف الحساب",
    "Password Updated":"تم تعديل الرقم السرى",
    "identical":"قيم الخلايا غير متطابقة",
    "Profile Details Updated":"تم تعديل معلوماتك",
    "out": "خروج",
    "Ad":"إعلانات",
    "Save Results":"حفظ النتائج",
    "Subject":"الموضوع",
    "Enter Your Name":"أدخل اسمك",
    "your request explain":"أشرح طلبك بالتفصيل",
    "load": "تحميل",
    "countries": "أختر بلدك الحالية",
    "ok":"حسنا",
    "show":"أظهر النتائج",
    "Add Ad":"أضف الأعلان",
    "Show all ads":"عرض الجميع",
    "Enter name":"أسم الحساب",
    "Retrieve":"أعد أدخال بريدك الالكترونى",
    "Retrieve1":"أعد أدخال رمز المرور الجديد",
    "Dark":"الوضع الليلى",
    "White":"الوضع النهارى",
    "System":"وضع النظام",
    "mail sent successfully":"تم الارسال بنجاح",
    "Some thing went wrong":"حدث خطأ",
    "archives":"الأرشيف",
    "no Internet Connection":"لا يوجد اتصال بالإنترنت",
    "archive":"نقل للأرشيف",
    "Block":"حظر",
    "mark with star":"أضافة للمفضل",
    "unarchive":"حذف من الارشيف",
    "unblock":"رفع الحظر",
    "non-mark with star":"حذف من المفضل",
    "Re-connect your wifi":"أعد توصيل wifi الخاص بك",
    "Choose Location":"أختر موقعك",
    "Whole Country":"كل البلد",
    "high prices":"الأعلى سعرا",
    "low prices":"الأقل سعرا",
    "Filter":"منقي",
    "User Name":"أسم المستخدم",
    "Packages":"حزم",
    "Sort":"ترتيب",
    "camera":"ألتقط صورة",
    "gallery":"الأستديو",
    "Username":"المستخدم",
    "the newest":"الأحدث",
    "Continue Search for":"تابع البحث عن",
    "in":"فى",
    "and":"و",
    "Privacy Policy":"سياسة الخصوصية"},
   "en":{
    "and":"and",
    "Privacy Policy":"Privacy Policy",
    "Add photos (Limited 8)":"Add photos until (Limited 8)",
    "gallery":"gallery",
    "Packages":"Packages",
    "low prices":"low prices",
    "high prices":"high prices",
    "the newest":"the newest",
    "Sort":"Sort",
    "show":"show result",
    "Choose Category":"Choose Category",
    "Ad":"Ads",
    "Save Results":"Save Results",
    "Filter":"Filter",
    "Whole Country":"Whole Country",
    "Username":"Username",
    "Choose Location":"Choose Location",
    "Re-connect your wifi":"Re-connect your wifi",
    "no Internet Connection":"no Internet Connection",
    "uppercase": "Password must be at least 8 characters, include an uppercase letter, number and symbol",
    "mail sent successfully":"mail sent successfully",
    "Some thing went wrong":"Some thing went wrong",
    "Enter Your Name":"Enter Your Name",
    "Important Information":"Important Information",
    "System":"System Mode",
    "messages":"messages",
    "archive":"archive",
    "Block":"Block",
    "recently":"recently",
    "mark with star":"mark with star",
    "unarchive":"unarchive",
    "unblock":"unblock",
    "non-mark with star":"non-mark with star",
    "archives":"archives",
    "your request explain":"your request explain",
    "Category":"Category",
    "Dark":"Dark Mode",
    "White":"White Mode",
    "Enter name":"Enter name",
    "Deleted":"Your Account Has Successfully Deleted",
    "Ad Report":"Ad Report",
    "Profile Details Updated":"Profile Details Updated",
    "Offensive content":"Offensive content",
    "Fraud":"Fraud",
    "Duplicate ad":"Duplicate ad",
    "Product already sold":"Product already sold",
    "Other":"Other",
    "Change profile Details":"Change profile Details",
    "change Password":"change Password",
    "Change Email":"Change Email",
    "System Mode Setting":"System Mode Setting",
    "Upgrade Application":"Upgrade Application",
    "Delete Account":"Delete Account",
    "Phone Call":"Phone Call",
    "Send":"Send",
    "Show all ads":"Show all ads",
    "Send OTP":"Send OTP",
    "Send Message":"Send Message",
    "Copy":"Copy",
    "unread":"unread",
    "Save contact":"Save contact",
    "Save":"Save",
    "identical":"Fields are not identical",
    "login": "login",
    "All Answers":"All Answers",
    "Only marked with star":"Only marked with star",
    "Unavailable":"Unavailable It‘s your ad",
    "Login Firstly":"Login Firstly",
    "email": "Enter Email",
    "phone": "Enter Phone",
    "User Name":"User Name",
    "code":"Enter code",
    "camera":"take photo",
    "Subject":"Subject",
    "details":"details",
    "codes":"Select your phone code",
    "must be at least 6 Chars":"must be at least 6 Chars",
    "OTP must be of 6 digit":"OTP must be of 6 digit",
    "already":"Phone Number is already Exist",
    "not":"Phone Number not found",
    "password": "Enter password",
    "f_password": "Forget password",
    "question": "Don't have Account?",
    "register": "Register now",
    "Register Email":"Register Email",
    "Verification":"Email Verification sent",
    "description":"description",
    "Ad published in":"Ad published in",
    "sent":"sent",
    "Other User":"Other User",
    "My Chats":"My Chats",
    "Important Advices":"Important Advices",
    "Verify":"Verify",
    "Verify Phone Number":"Verify Phone Number",
    "by": "By logging you accept our",
    "terms": "terms of use",
    "Invalid Phone Number":"Invalid Phone Number",
    "invalid Email Format":"invalid Email Format",
    "Password Updated":"Password Updated",
    "Reset":"Reset",
    "you":"you",
    "Continue Search for":"Continue Search for",
    "in":"in",
    "gmail":"Login With Email",
    "google":"Login With Google",
    "facebook":"Login With Facebook",
    "ph":"Login With Mobile",
    "Remove":"Remove",
    "Cancel":"Cancel",
    "Comment":"Comment",
    "Edit":"Edit",
    "share":"share",
    "promote":"promote",
    "homes": "Properties",
    "car": "Vehicles",
    "mobile": "Mobile,accessory",
    "tv": "Home Electronics",
    "decor": "Home Furniture",
    "fashion": "Fashion & Beauty",
    "pets": "Pets-Accessories",
    "kids": "Kids-Babies",
    "jobs": "Jobs",
    "book": "Books-Sports-Hobbies",
    "trade": "Trade-Industry-Agriculture",
    "service": "Services",
    "error1": "This field needed",
    "Home": "Home",
    "Ads": "Browse Ads",
    "Searches":"Searches",
    "My": "My Ads",
    "us":"Chat With Us",
    "chat": "Chats",
    "chats":"chats",
    "calls":"calls",
    "views":"views",
    "favourit":"favourit",
    "best": "Favorites",
    "add image":"add image",
    "2":"Removed from favourites",
    "1":"Added to favourites",
    "3":"Do you want to remove all ads?",
    "4":"only meeting in public/crowded places like bus station or metro",
    "5":"never go alone to meet buyer/seller,always take someone with you",
    "6":"check and inspect the product properly before purchasing it",
    "7":"never buy anything advance or transfer money before inspecting the product",
    "8":"I want to introduce an offer for you",
    "9":"Are You Sure You Want To Delete Your Account?",
    "10":"Your Request Reason (Optional)",
    "Ad Link (Optional)":"Ad Link (Optional)",
    "Confirm":"Confirm",
     "offer":"offer",
    "Add Ad":"Add Ad",
    "Ad Location":"Ad Location",
    "Enter Email": "Enter Email",
    "place": "Place an Ads",
    "Retrieve":"Retrieve New Email",
    "Retrieve1":"Retrieve password",
    "contact": "Contact",
    "country": "Choose Country",
    "lang": "Choose Language",
    "about": "About Us",
    "Setting":"Setting",
    "out": "Log Out",
    "load": "Loading",
    "countries": "Choose Your Current Country",
    "ok":"Ok"
   }
  };
}
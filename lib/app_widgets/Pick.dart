import 'package:flutter/material.dart';
import 'package:flutter_app/app_widgets/MyHomePage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/authentication/Logs.dart';
import 'package:flutter_app/authentication/Sign.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import '../modules/Files.dart';
import 'dart:convert';
class Pick extends StatefulWidget {
  @override
  State<Pick> createState() => _Pick();
}
class _Pick extends State<Pick> {
  Future<Map<String, dynamic>> futureData;
  final t=TextEditingController();
  final f={}.obs;
  final where =''.obs;
  @override
  void initState() {
    super.initState();
    futureData=fetchData();
    if(language.val=='ar')
      translate();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
                  appBar: AppBar(
                      leading:  IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
                        Get.off(()=>MyHomePage() );},),
                    bottom:PreferredSize(preferredSize: Size(double.infinity,60),
                    child:Padding(padding:EdgeInsets.only(left: 15,right: 15,bottom: 10,top:2) ,
                 child:   TextField(
                   controller: t,
                      style:TextStyle(color:Colors.white) ,
                      keyboardType: TextInputType.text,
                      cursorColor:Colors.white ,
                      decoration:  InputDecoration(
                          hintText: "Search",
                          hintStyle:TextStyle(color:Colors.white) ,
                          suffixIcon:  IconButton(icon:Icon(Icons.search,color:Colors.white), onPressed: ()async{
                     if(t.text !='' && t.text !=null ){
                            if(language.val=='ar')
                   {   var input=await translator.translate(t.text,from:language.val,to: 'en' );
                     where.value= Uri.encodeQueryComponent(jsonEncode({
                       "name": {
                         "\$regex": input.toString()
                       }
                     }));}   else
                          where.value= where.value= Uri.encodeQueryComponent(jsonEncode({
                            "name": {
                              "\$regex": t.text}
                          }));
                       futureData=fetchData();
                            if(language.val=='ar')
                         translate();
                          setState((){});}
                     else
                       Toast.show('error1'.tr,gravity: Toast.bottom,duration:Toast.lengthLong );
                          } ),
                      prefixIcon:IconButton(icon:Icon(Icons.close,color:Colors.white), onPressed: (){
                        t.text='';
                      } ) ),
                    )) ),
                    title: Text("country".tr),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                          gradient:const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.purple,
                                Colors.purpleAccent,],
                              stops: [0.2,0.6]),
                      ),
                    ),
                  ),
                  body:Center(
    child: new SingleChildScrollView(
    child:FutureBuilder<Map<String, dynamic>>(
      future: futureData,
      builder: (context,snapshot) {
        if (!snapshot.hasData) return Container();
     else   if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }else if(snapshot.connectionState==ConnectionState.waiting)
          {return CircularProgressIndicator();}
        List<dynamic> details=snapshot.data.values.first ;
        return Obx(()=>(language.val=='ar'&& f.length<1)||(language.val=='en'&& f.length<0)?CircularProgressIndicator(): Column(children: details.map((element) =>
           Column(children:[ ListTile(leading: Text('${details.indexOf(element)+1} -') ,title:Row(children:[ Text('(${element['phone']})  '),language.val=='ar'?
          Expanded(child:  Text(f[element['name']]==null?'${element['name']}':'${f[element['name']]}')):
          Expanded(child: Text('${element['name']}'))]),
              style:ListTileStyle.list,onTap:()async{
                Files().load(context);
                // if(y==0){
                //   Get.off(()=>Fetch());
                //   box.write('code',element['phone'] );
                //   box.write('country',element['name'] );
                
              //   box.write('c_code',element['code'] );
                //   box.write('currency',element['currency'] );
                // }
                // else
                // {
                  if (vs.val!=element['phone'])
                {Get.off(()=>Logs());
                box.write('code',element['phone'] );
                box.write('country',element['name'] );
                box.write('c_code',element['code'] );
                box.write('currency',element['currency'] );
                if(i.currentUser != null){
                  if(p != null){await  v.logOut();}
                  else if( x !=null)
                  {await   g.signOut();}
                  await i.signOut();}
                }
                else
                Get.to(()=>MyHomePage());
                // }
                await  observer.analytics.logEvent(name: 'change_country');
              }
              ),
            Divider(color:Colors.black)])
        ).toList()));
      },
    )
    )),
    );
  }
  Future<Map<String, dynamic>> fetchData() async {
    var j;
    if(where.value !='')
      j= Uri.parse( 'https://parseapi.back4app.com/classes/Continentscountriescities_Country?limit=250&excludeKeys=emoji,capital,continent,shape&where=${where.value}');
    else
      j= Uri.parse('https://parseapi.back4app.com/classes/Continentscountriescities_Country?limit=250&order=name&excludeKeys=emoji,capital,continent,shape');
    final response = await http.get(
      j ,
        headers: {
          "X-Parse-Application-Id": "CXaHoa9gfLcqgKfsr4aqvrRts2chtDKnbHPB7abk",
          "X-Parse-REST-API-Key": "aYGnOATisWaMmX5gsNofUbNvt4ALTd6aMsOMIRv2"
        }
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  void translate()async{
    Map<String,dynamic> result=await futureData;
    List<dynamic> countries=result.values.first;
    if (f.length>0) {f.clear();}
   for(int i=0;i<=countries.length-1;i++){
       await translator.translate(countries[i]['name'],from: 'en',to:language.val ).then((value) {
           f.addAll({countries[i]['name']:value.toString()});   });
    }
  }
}
import 'dart:collection';
import 'dart:convert';
import '../modules/Files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/modules/Files.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';

class City extends StatefulWidget {
  final LinkedHashMap<dynamic, dynamic> dad;
  const City({this.dad, Key key}) : super(key: key);
  @override
  _CityState createState() => _CityState();
}
class _CityState extends State<City> {
  final data  d=Get.put(data());
  Future<Map<String, dynamic>> futureData;
  final where =''.obs;
  final f={}.obs;
  @override
  void initState() {
    super.initState();
    initial();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back,size:Adaptive.sp(20) ,),onPressed: (){
            if(Var.value==1)
              Var.value=0;
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
                  ],
                  stops: [0.2,0.6]
              ),
          ),
        ),
        title:const Text('Choose Your City'),
      ),body:Center(
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
               return Obx(()=>(f.length<1 && language.val=='ar')||(f.length<0 && language.val=='en')?CircularProgressIndicator():Column(children: details.map((element) =>
               Column(children:[ ListTile(leading: Text('${details.indexOf(element)+1} -') ,
                   title:Text('${(f[element['Subdivision_Name']]==null && language.val=='ar')|| language.val=='en'?element['Subdivision_Name']:f[element['Subdivision_Name']]}'),
                    style:ListTileStyle.list,onTap:()async{
                     List< dynamic> n=await Data();
                   List<dynamic> v= n.where((element1) => element1['state_code']==element['Subdivision_Code'] && element1['country_code']==c_code.val).toList();
               if (v.length==0){
                 Do(element['Subdivision_Name']);
                }
                else{
                  Files().load(context);
                 Get.defaultDialog(
                    radius:double.infinity ,
                   title: 'Cities',
                   middleText:'',
                   content:SingleChildScrollView(child:  Column(children:v.map((e) {
                       return ListTile(title:Text('${e['name']}'),onTap: (){
                          Do(e['name']);
                          Get.back();
                    } );
                    }).toList() ))
               );}
                 }),
                 Divider(color:Colors.black)])
              ).toList()));
             },)
        )) ,
     );
  }
  void Do(String c){
    if( Var.value==1 )
    {loca.value=c;
    Var.value=0;}
    else
    {
    if(city.val.length>=5)
      city.val.remove(city.val.keys.first);
        final v={c:c}; city.val.addAll(v);
      ill.value=c;
    Files().write('location.city',c,widget.dad);
    Files().Querys(widget.dad);
    }
    Get.back();}

  Future<List<dynamic>> Data() async {
    final response = await http.get(Uri.parse("https://raw.githubusercontent.com/eslamsalehtaha/city/04985dc789f6fdeaee6affde61cd5d3ca78dc4c0/db.json"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    } }
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://parseapi.back4app.com/classes/Continentscountriescities_Subdivisions_States_Provinces?order=Subdivision_Name&excludeKeys=country&where=${where.value}'),
        headers: {
          "X-Parse-Application-Id": "CXaHoa9gfLcqgKfsr4aqvrRts2chtDKnbHPB7abk",
          "X-Parse-REST-API-Key": "aYGnOATisWaMmX5gsNofUbNvt4ALTd6aMsOMIRv2"}
        );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    } }
  void translate()async{
    Map<String,dynamic> result=await futureData;
    List<dynamic> countries=result.values.first;
    if (f.length>0) {f.clear();}
    for(int i=0;i<=countries.length-1;i++){
      String city=countries[i]['Subdivision_Name'];
      await translator.translate(city.replaceAll(RegExp('AI'),'').toLowerCase(),from:'en'  ,to:language.val ).then((value) {
        f.addAll({countries[i]['Subdivision_Name']:value.toString()});   });
    } }
  void initial(){
where.value = Uri.encodeQueryComponent(jsonEncode({
      "Country_Code": c_code.val  }));
    futureData = fetchData();
    if(language.val=='ar')
      translate();
  } }


import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'authentication/Logs.dart';
import 'app_widgets/MyHomePage.dart';
import 'app_widgets/Pick.dart';
import 'app_widgets/AD.dart';
import 'authentication/Sign.dart';
import 'modules/Files.dart';

void main()async{
   WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  final PendingDynamicLinkData initialLink =
  await FirebaseDynamicLinks.instance.getInitialLink();
  Stripe.publishableKey ='pk_test_51Kvqp7AX0jo6diTpYYbZyrXW01s6FDaikaN0702baAcbtU75NFYkhtcooKmGQ4wOV491w6nHPzfbwJDrj6OwFyxP00PJuxNlkn';
  ErrorWidget.builder=(FlutterErrorDetails D)=>error();
   runApp( GetMaterialApp(
       theme: Get.theme,
       debugShowCheckedModeBanner: false,
       locale:Locale(language.val),
       fallbackLocale:Locale("en") ,
       translations:Languages() ,
       home:dynamic(initialLink)) );
}
class My extends StatefulWidget {
  @override
  State<My> createState() => _My();
}
class _My extends State<My> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder:
          (context,orientation,screenType) {
        return Scaffold(
            body:
            SplashScreen(
              seconds:5,
              gradientBackground : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: const [
                  Colors.purpleAccent,
                  Colors.purple,
                  Colors.deepPurpleAccent,
                  Colors.deepPurple
                ],
                stops: const [0.2,0.4,0.6,0.8],
              ),
              image:  Image.asset('asset/images/-2.png'),
              navigateAfterSeconds:show(),
              photoSize:Adaptive.h(10),
              useLoader: false,
              loadingText: Text(' From\nSpear',style:TextStyle(fontSize: Adaptive.sp(20),color: Colors.white,fontFamily: 'Lobster' )
                ,) ,
            ));
    }
      );
  }
  Widget show() {
    Widget b;
    internet();
    if(i.currentUser == null)
      {
        if(vs.val=='')
       {b=Pick();
       y=0;
       }
        else
       {if(login.val=='phone' || login.val=='')
         b= Fetch();
       else
         b=Logs();
       }
      }
    else
      b=MyHomePage();
    return b;
  }
}

void internet(){
  InternetConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        { if(routing.value==false){routing.toggle();
          Get.back();}}
        break;
      case InternetConnectionStatus.disconnected:
        {if(routing.value==true){routing.toggle();
          Get.to(()=>errors());}}
        break;
    }       });   }
error() {
  return Container(child: Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [Transform.scale(
      scale: 1,
      child: CircularProgressIndicator(strokeWidth: Adaptive.w(2),),
    ),
      Divider(height: Adaptive.h(5),),
      Text('Waiting For Processing',style: TextStyle(fontSize:Adaptive.sp(20) ),)
    ],),),);
}

Widget dynamic(PendingDynamicLinkData initialLink)
{
  if( routing.value==false)
    return errors();
else if (initialLink != null && routing.value==false)
  {List <String> k=initialLink.link.path.split("/");
  Get.updateLocale(Locale(k.elementAt(2)));
  return AD(dad:'dynamic' ,Id:k.elementAt(1));
  }
return My();
}


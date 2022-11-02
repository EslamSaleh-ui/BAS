import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toast/toast.dart';
import 'Email.dart';
import '../modules/Files.dart';
import '../app_widgets/MyHomePage.dart';
import 'Sign.dart';

class Logs extends StatefulWidget {
  @override
  State<Logs> createState() => _Logs();
}
class _Logs extends State<Logs> {
  @override
  void initState() {
    super.initState();
    box.write('login', 'logs');
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("login".tr),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.purple,
                    Colors.purpleAccent,
                  ],
                  stops: [0.2, 0.6]
              ),
            ),
          ),
        ),
        body: Center(child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start
          ,
          children: [
            ElevatedButton(
             style: ElevatedButton.styleFrom(
    primary: Colors.deepPurple ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ), onPressed: () {
                Get.offAll(() => Fetch());
              },
              child: Row(children: [
                Icon(FontAwesomeIcons.mobile, size: Adaptive.sp(25),
                  color: Colors.white,),
                Text('\b\b'),
                Text("ph".tr, style: TextStyle(
                    fontSize: Adaptive.sp(18), color: Colors.white),)
              ],),)
            , Divider(height: Adaptive.h(5),), ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.redAccent.shade100 ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ),
              onPressed: () {
                Get.offAll(() => Second());
              },
              child: Row(children: [
                Image.asset(
                  'asset/images/icons/2504727.png', height: Adaptive.h(10),
                  width: Adaptive.w(10),),
                Text('\b\b'),
                Text("gmail".tr, style: TextStyle(
                    fontSize: Adaptive.sp(18), color: Colors.white),)
              ],),),
            Divider(height: Adaptive.h(5),),ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.red ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ), onPressed: () async {
                Files().load(context);
                await g.signIn().then((value) async {
                  setState(() {
                    x = value;
                  });
                  try {
                    final GoogleSignInAuthentication googleAuth = await x
                        .authentication;
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );
                    await i.signInWithCredential(credential);
                    if (x != null) {
                      Get.offAll(() => MyHomePage());
                      await ff.collection('/users').doc(i.currentUser.uid).
                      snapshots().listen((event) {
                        if (event.exists == false) {
                          Files().rege();
                        }
                      });
                      Files().After_login();
                    }
                  }
                  on FirebaseException catch (e) {
                    Toast.show(e.code, gravity: Toast.bottom,
                        duration: Toast.lengthLong);
                    g.signOut();
                  }
                }).catchError((e) {
                  Toast.show(e.toString(), gravity: Toast.bottom,
                      duration: Toast.lengthLong);
                });
              },
              child: Row(children: [
                Image.asset(
                  'asset/images/icons/2504739.png', height: Adaptive.h(10),
                  width: Adaptive.w(10),),
                Text('\b\b'),
                Text("google".tr, style: TextStyle(
                    fontSize: Adaptive.sp(18), color: Colors.white),)
              ],),)
            , Divider(height: Adaptive.h(5),), ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.blue ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ), onPressed: () async {
                Files().load(context);
                var o = await v.logIn(
                    permissions: [FacebookPermission.publicProfile]);
                switch (o.status) {
                  case FacebookLoginStatus.success:
                    {
                      p = await v.getUserProfile();
                      try {
                        final OAuthCredential facebookAuthCredential = FacebookAuthProvider
                            .credential(o.accessToken.token);
                        await i.signInWithCredential(facebookAuthCredential);
                        Files().After_login();
                        Get.offAll(() => MyHomePage());
                        await ff.collection('/users').doc(i.currentUser.uid).
                        snapshots().listen((event) {
                          if (event.exists == false) {
                            Files().rege();
                          }
                        });
                      } on FirebaseException catch (e) {
                        Toast.show(e.code, gravity: Toast.bottom,
                            duration: Toast.lengthLong);
                        v.logOut();}
                    }
                    break;
                  case FacebookLoginStatus.cancel:
                    break;
                  case FacebookLoginStatus.error:
                    {
                      Toast.show('Some Thing Went Error', gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    } break;
                }
              },
              child: Row(children: [
                ImageIcon(AssetImage('asset/images/icons/174848.png'),
                  size: Adaptive.sp(28), color: Colors.white,)
                ,
                Text('\b\b'),
                Text("facebook".tr, style: TextStyle(
                    fontSize: Adaptive.sp(18), color: Colors.white),)
              ],),)
          ],))
        )
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../modules/Files.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
final TextEditingController _textController =
new TextEditingController();
final _isWrittings = false.obs;
var image;
String archived,blocked,marked,tokken,user_block;
class Chat extends StatefulWidget {
  final String chatId;
  final String offer;
  const Chat({@required this.chatId,this.offer,Key key}) : super(key: key);
  @override
  State<Chat> createState() {return new  _Chat();}
}
class _Chat extends State<Chat> {
  final s_key='AAAAPqwtgSs:APA91bFoDuS8_'
      '27ZD7UIMzgx8fzilXpym-bBWhgGYGNBUSmG3ckNLcsNHzNO2PoWzqDa9W-'
      '9Ma5G9W_3gXabA0ISprLR379IebUWpdAMJrcss7'
      '-GymTJSr7684PzxdSviSOJzIrgplXW';
  final List <String> m1 = ['archive', 'Block', 'mark with star'];
  final List <String> m2 = ['unarchive', 'unblock', 'non-mark with star'];
  final List <Icon> m3 = [const Icon(Icons.delete, color: Colors.white),
   const Icon(Icons.block, color: Colors.white),
   const Icon(Icons.star, color: Colors.white)];
   List <String> m4 = [archived, blocked, marked];
  final List <String> advices = ["4".tr, "5".tr, "6".tr, "7".tr];
  final List <Icon> ad3 = [const Icon(Icons.person, color: Colors.grey),
  const  Icon(FontAwesomeIcons.diceTwo, color: Colors.grey),
 const   Icon(FontAwesomeIcons.solidEye, color: Colors.grey),
   const Icon(FontAwesomeIcons.dollarSign, color: Colors.grey)];
  Future<void> logs() async
  {await observer.analytics.logEvent(name: 'chat_with_app_agents');}
  @override
  void initState() {
    super.initState();
    reader();
    marks();
    logs();
    if(widget.offer !=null)
    _sendText(widget.offer);
  }
  @override
  void dispose() {
    readable();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Get.back();
          },
              icon: const Icon(Icons.arrow_back)),
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
          title:  Text("chat".tr),
          actions: [
            IconButton(onPressed: () {
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  alignment:Alignment.center ,
                  contentPadding:EdgeInsets.all(Adaptive.sp(10)) ,
                  title:Container(color:Colors.purple ,width:double.infinity ,height:Adaptive.h(5),
                    child:Center(child: Text('Important Information'.tr,style:TextStyle(color: Colors.white )) ,) ,) ,
                  content: SingleChildScrollView(child: Column(mainAxisAlignment:MainAxisAlignment.start ,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Container(color:Colors.purple ,width:double.infinity ,height:Adaptive.h(11),
                    child:Center(child:Container(child:Center(child: Icon(Icons.lightbulb,size:Adaptive.h(10) ,color:Colors.yellow )
                    ),decoration:BoxDecoration(shape:BoxShape.circle,color:Colors.white),height:Adaptive.h(20) ,
                    width:Adaptive.w(20) ,)),),
                      Divider(thickness:Adaptive.h(2) ,color: Colors.white,),
                    Column(children:advices.map((e) {
                      return Column(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.center,
                          children: [ad3.elementAt(advices.indexOf(e)),Expanded(child:Text(' ${e}'))],),
                      Divider(thickness:Adaptive.h(0.1) ,color: Colors.black) ]);
                      }).toList() ) ]) ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [ElevatedButton(   style: ElevatedButton.styleFrom(
    primary: Colors.teal ,
    onPrimary: Colors.white, shape:  RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50)),
    minimumSize: Size(MediaQuery.of(context).size.width/7 ,80), //////// HERE
    ),child:const Text('OK',style:TextStyle(
                  color: Colors.white)),
                    onPressed:(){Navigator.pop(context);})]  );
              });
            },
                icon:const Icon(Icons.lightbulb, color: Colors.yellow,)),
            PopupMenuButton(
                color: Colors.black,
                itemBuilder: (context) {
                  return m1.map((e) {
                    return PopupMenuItem(
                      child: ListTile(
                        title: m4.elementAt(m1.indexOf(e)) == 'false' ? Text(
                          e.tr, style: TextStyle(color: Colors.white),)
                            : Text(m2.elementAt(m1.indexOf(e)).tr,
                          style: TextStyle(color: Colors.white),),
                        leading: m3.elementAt(m1.indexOf(e)),),
                      value: m4.elementAt(m1.indexOf(e)) == 'false' ? e : m2
                          .elementAt(m1.indexOf(e)),
                      onTap: () {
                        if (m4.elementAt(m1.indexOf(e)) == 'false') {
                          if (e == 'archive') {
                            ff.collection('/chats').doc(widget.chatId).update(
                                {
                                  'archived.${i.currentUser.uid}': 'true'
                                });
                          }
                          else if (e == 'mark with star') {
                            ff.collection('/chats').doc(widget.chatId).update(
                                {
                                  'marked.${i.currentUser.uid}': 'true'
                                });
                          } else {
                            ff.collection('/chats').doc(widget.chatId).update(
                                {
                                  'block.${i.currentUser.uid}': 'true'
                                });
                            setState((){});
                          }
                        }
                        else {
                          if (e == 'archive') {
                            ff.collection('/chats').doc(widget.chatId).update(
                                {
                                  'archived.${i.currentUser.uid}': 'false'
                                });
                          }
                          else if (e == 'mark with star') {
                            ff.collection('/chats').doc(widget.chatId).update(
                                {
                                  'marked.${i.currentUser.uid}': 'false'
                                });
                          } else {
                            ff.collection('/chats').doc(widget.chatId).update(
                                {
                                  'block.${i.currentUser.uid}': 'false'
                                });
                            setState((){});
                          }
                        }
                        marks();
          Toast.show("Changes Saved", gravity: Toast.bottom, duration: Toast.lengthLong);
                      },
                    );
                  }).toList();
                }),
          ],
        ), body: SafeArea(
        child: new Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: ff.collection("/chats").doc(widget.chatId).collection(
                  '/messages').orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting)
                  return new Center(child:CircularProgressIndicator(color: Colors.grey.shade400,) ,);
                if (!snapshot.hasData) return new Text("No Chat");
                return Expanded(
                  child: new ListView(
                    reverse: true,
                    children: generateMessages(snapshot),
                  ),
                );
              },
            ),
            new Container(
              decoration: new BoxDecoration(color: Theme
                  .of(context)
                  .cardColor),
              child: blocked == 'false' ? Container(width: double.infinity,
                  alignment: Alignment.center,
                  height: 35,
                  color: Colors.lightGreenAccent,
                  constraints: BoxConstraints(maxHeight: double.infinity),
                  child: Text('User Blocked',
                    style: TextStyle(color: Colors.green, fontSize: 20),))
                  : _buildTextComposer(),
            )
          ],
        ),
      ),
      );
  }

  void ImageViewer(List<ImageProvider<Object>> k) {
    MultiImageProvider multiImageProvider = MultiImageProvider(k);
    showImageViewerPager(context, multiImageProvider,
        onPageChanged: (page) {
          Toast.show("Page changed to $page", gravity: Toast.bottom,
              duration: Toast.lengthLong);
        }, onViewerDismissed: (page) {
          Toast.show(
              "Dismissed while on page $page", gravity: Toast.bottom,
              duration: Toast.lengthLong);
        });
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    DateTime dt = documentSnapshot.get('time') == null
        ? DateTime.now()
        : (documentSnapshot.get('time') as Timestamp).toDate();
    String d12 = DateFormat('dd-MM-yy,hh:mm a').format(dt);
    if(documentSnapshot.get('fcm') == false && i.currentUser.uid == documentSnapshot.get('sender_id'))
     {
       send_fbm(1,documentSnapshot.get('text') ,'Islam', tokken);
     ff.collection("/chats").doc(widget.chatId).collection('/messages')
            .doc( documentSnapshot.id)
            .update({'fcm': true});
      }
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(padding: EdgeInsets.only(right: 5),
              child: Text(d12),),
            new Container(
              padding: EdgeInsets.only(right: 5),
              margin: const EdgeInsets.only(top: 5.0),
              child: documentSnapshot.get('image_url') != ''
                  ? InkWell(
                child: new Container(
                  height: Adaptive.h(30),
                  width: Adaptive.w(50),
                  child: Image.network(
                    documentSnapshot.get('image_url'),
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.green.shade300,),
                  padding: EdgeInsets.all(5),
                ),
                onTap: () {
                  ImageViewer([
                    Image
                        .network(documentSnapshot.get('image_url')).image
                  ]);
                },
              )
                  : new Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.green.shade300,
                ),
                padding: EdgeInsets.all(Adaptive.sp(15)),
                width: Adaptive.w(60),
                child: Text(documentSnapshot.get('text'),
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    DateTime dt = documentSnapshot.get('time') == null
        ? DateTime.now()
        : (documentSnapshot.get('time') as Timestamp).toDate();
    String d12 = DateFormat('dd-MM-yy,hh:mm'
        ' a').format(dt);
    if (documentSnapshot.get('sender_id') != i.currentUser.uid ) {
      ff.collection("/chats").doc(widget.chatId).collection('/messages')
          .doc( documentSnapshot.id)
          .update({'read': true,
                  'fcm':true});
    }
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(padding: EdgeInsets.only(left: 5),
              child: Text(d12),),
            new Container(
              padding: EdgeInsets.only(left: 5),
              margin: const EdgeInsets.only(top: 5.0),
              child: documentSnapshot.get('image_url') != ''
                  ? InkWell(
                child: new Container(
                  child: Image.network(
                    documentSnapshot.get('image_url'),
                    fit: BoxFit.fitWidth,
                  ),
                  height: Adaptive.h(30),
                  width: Adaptive.w(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey.shade400,),
                  padding: EdgeInsets.all(5),
                ),
                onTap: () {
                  ImageViewer([
                    Image
                        .network(documentSnapshot.get('image_url'))
                        .image,
                  ]);
                },
              )
                  : new Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey.shade400,
                ),
                padding: EdgeInsets.all(Adaptive.sp(15)),
                width: Adaptive.w(60),
                child: Text(documentSnapshot.get('text'),
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),),
            ),
          ],
        ),
      ),
    ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map<Widget>((doc) {
      var ps = doc.get('sender_id');
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: ps != i.currentUser.uid
              ? generateReceiverLayout(doc)
              : generateSenderLayout(doc),
        ),
      );
    })
        .toList();
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
        icon: new Icon(Icons.send),
        onPressed: () {
          SystemSound.play(SystemSoundType.alert);
          if (_isWrittings.isTrue)
            _sendText(_textController.text);
          else
            null;
        }
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color:Theme.of(context).accentColor
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    onPressed: () async {
                      showDialog(context: context, builder: (context) {
                        return SimpleDialog(
                          children: [
                            ListTile(onTap: () async {
                              Navigator.of(context).pop();
                              image = await new ImagePicker().getImage(
                                  source: ImageSource.camera);
                              int timestamp = new DateTime.now()
                                  .millisecondsSinceEpoch;
                              var storageReference = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(
                                  'chats/img_' + timestamp.toString() + '.jpg');
                              File f = File(image.path);
                              var uploadTask =
                              storageReference.putFile(f);
                              await uploadTask.whenComplete(() async {
                                String fileUrl = await storageReference
                                    .getDownloadURL();
                                _sendImage(
                                    messageText: null, imageUrl: fileUrl);
                              });
                            },
                              title: Text('camera'.tr, style: TextStyle(
                                  fontSize: Adaptive.sp(20),
                                  color: Colors.black),),
                              leading:const Icon(FontAwesomeIcons.camera),
                            ),
                            ListTile(onTap: () async {
                              Navigator.of(context).pop();
                              image = await new ImagePicker().getImage(
                                  source: ImageSource.gallery);
                              int timestamp = new DateTime.now()
                                  .millisecondsSinceEpoch;
                              var storageReference = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(
                                  'chats/img_' + timestamp.toString() + '.jpg');
                              File f = File(image.path);
                              var uploadTask =
                              storageReference.putFile(f);
                              await uploadTask.whenComplete(() async {
                                String fileUrl = await storageReference
                                    .getDownloadURL();
                                _sendImage(
                                    messageText: null, imageUrl: fileUrl);
                              });
                            },
                              title: Text('gallery'.tr, style: TextStyle(
                                  fontSize: Adaptive.sp(20),
                                  color: Colors.black),),
                              leading:const Icon(Icons.album),
                            )
                          ],
                        );
                      });
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    if (messageText.length > 0 && _isWrittings.isFalse)
                     _isWrittings.toggle();},
                  onSubmitted: _sendText,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    if (user_block == 'false') {
      if (_textController.text.length > 0 || text==widget.offer) {
        _textController.clear();
        ff.collection("/chats").doc(widget.chatId).collection('/messages').add({
          'text': text,
          'sender_id': i.currentUser.uid,
          'image_url': '',
          'read': false,
          'fcm': false,
          'time': FieldValue.serverTimestamp(),
        }).then((documentReference) {
           if(_isWrittings.isTrue)  _isWrittings.toggle();
        }).catchError((e) {});
      }
      else {
        Toast.show("Message can‘t be empty", gravity: Toast.bottom,
            duration: Toast.lengthLong);
      }
    }
    else {
    Toast.show("Your Are Blocked By User", gravity: Toast.bottom,
          duration: Toast.lengthLong);
    }
  }

  void _sendImage({String messageText, String imageUrl}) {
    ff.collection("/chats").doc(widget.chatId).collection('/messages').add({
      'text': messageText != null ? messageText : '',
      'sender_id': i.currentUser.uid,
      'image_url': imageUrl,
      'read': false,
      'fcm': false,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void readable() async
  {
    await ff.collection('/chats').doc(widget.chatId).collection('/messages')
        .where('sender_id', isEqualTo: '${i.currentUser.uid}')
        .where('read', isEqualTo: false).snapshots()
        .listen((event) {
      ff.collection('/chats').doc(widget.chatId).get().then((value) {
        if (event.size > 0) {
          if (value.get('user2') == i.currentUser.uid) {
            ff.collection('/chats').doc(widget.chatId).update(
                {
                  'unread.${value.get('user1')}': event.size
                });
          }
          else {
            ff.collection('/chats').doc(widget.chatId).update(
                {
                  'unread.${value.get('user2')}':event.size
                });
          }
        }
      });
    });
  }

  void reader() {
    ff.collection('/chats').doc(widget.chatId).update(
        {
          'unread.${i.currentUser.uid}': 0
        });
  }

  void marks() {
    ff.collection('/chats').doc(widget.chatId).snapshots().listen((event) {
          if (event.get('user1') == i.currentUser.uid) {
            user_block = event.get('block.${event.get('user2')}');
            ff.collection('/users').doc(event.get('user2')).get().then((value) {tokken=value.get('token');});}
          else
          {
            user_block = event.get('block.${event.get('user1')}');
            ff.collection('/users').doc(event.get('user1')).get().then((value) {tokken=value.get('token');});}
          archived = event.get('archived.${i.currentUser.uid}');
          marked = event.get('marked.${i.currentUser.uid}');
          blocked = event.get('block.${i.currentUser.uid}');
          m4 = [archived, blocked, marked];
    });
  }
  Future send_fbm(int id,String body,String Title,String token)async{
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$s_key',
      },
      body: jsonEncode (
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title':Title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id,
            'status': 'done'
          },
          'to': token,
        },
      ),
    ); }
}
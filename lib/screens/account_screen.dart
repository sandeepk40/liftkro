import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:haggle/screens/account_form.dart';
import 'package:haggle/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../services/firebase_services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);
  static const String id = 'account-screen';
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isEnabled = false;
  final FirebaseService _service = FirebaseService();

  String? address;
  String? name;
  String? phone;
  String? email;
  String? shop;
  var imageFile;
  var totalLike = [];
  var totalLikeCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    getTotalLikes();
    super.initState();
  }

  @override
  getTotalLikes() {
    _service.getUserData().then((value) => {
          for (var i = 0; i < value['productId'].length; i++)
            {
              _service
                  .getProductDetails(value['productId'][i])
                  .then((value) => {
                        setState(() {
                          totalLike.add(value['likeCount'][0]['totalLike']);
                        })
                      }),
              // print('snapshot data: ${value['productId'][i]}'),
            }
        });
  }

  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    var data = _service.getUserData();
    for (var i = 0; i < totalLike.length; i++) {
      totalLikeCount += int.parse(totalLike[i].toString());
    }

    print('product data: ${totalLikeCount}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton<int>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text(
                  'Logout ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            onSelected: (value) => SelectedItem(context, value),
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _service.getUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          // var ddata = snapshot.data!.data();
          if (snapshot.hasError) {
            print('snapshot: ${_service.getUserData()}');
            return const Text(
              "Something went wrong",
            );
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          var ddd;
          if (snapshot.connectionState == ConnectionState.waiting) {
            // print('product data: ${}');
            // _service.getProductDetails(ddd).then((value) => {
            //   setState(() {
            //     ddd = value['uid'];
            //     print('urid: $ddd');
            //   }),
            // // print('getuserdata: ${value.data()}')
            // });
            // _service.getProductDetails(value)

            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          }
          // name = snapshot.data?['name'] ?? "";
          // phone = snapshot.data?['mobile'] ?? "";
          // shop = snapshot.data?['shop'] ?? "";
          // email = snapshot.data?['email'] ?? "";
          // address = snapshot.data?['address'] ?? "";
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  // TextButton(onPressed: (){getTotalLikes();}, child: Text('$totalLike')),
                  const SizedBox(height: 30),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          snapshot.data?['profile'] != null
                                              ? NetworkImage(
                                                  snapshot.data?['profile'])
                                              : const NetworkImage('url'),
                                      // child:  snapshot.data?['profile'] != null ? Image.network(snapshot.data?['profile'],fit: BoxFit.f,):
                                      // Icon(
                                      //   CupertinoIcons.person_alt,
                                      //   color: Colors.grey,
                                      //   size: 50,
                                      // )
                                      // : Image.file(imageFile,fit: BoxFit.cover,),
                                    ),
                                    // Positioned(
                                    //   bottom: 2,
                                    //   right: 5,
                                    //   child: CircleAvatar(
                                    //     radius: 20,
                                    //     backgroundColor: Colors.white,
                                    //     child: CircleAvatar(
                                    //       radius: 18,
                                    //       backgroundColor: Colors.grey[300],
                                    //       child: IconButton(
                                    //         onPressed: (){
                                    //           getImage(true);
                                    //         },
                                    //         icon: Icon(Icons.camera_enhance,size: 15),
                                    //         color: Colors.black,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${snapshot.data?['name'] ?? ""}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    
                                    '${snapshot.data?['seller_type'] ?? ""}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 30, 20, 20),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: const [
                                          Text(
                                            "5.0",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Rating',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        indent: 12,
                                        endIndent: 12,
                                        color: Colors.black54,
                                        thickness: 2,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "${snapshot.data?['productId'].length.toString()}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Uploads',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        indent: 12,
                                        endIndent: 12,
                                        color: Colors.black54,
                                        thickness: 2,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            totalLikeCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Likes',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${snapshot.data?['about'] ?? ""}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    // decoration: const BoxDecoration(
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(10.0),
                    //   ),
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          Row(
                            children: [
                              const Text(
                                'Phone',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 90,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':  ${snapshot.data?['mobile'] ?? ""}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shop Name',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 53,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':  ${snapshot.data?['shop_name'] ?? ""}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 95,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // 'mail',
                                      ':  ${snapshot.data?['email'] ?? ""}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 75.5,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // 'add',
                                      ':  ${snapshot.data?['address'] ?? ""}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bodyProgress() {
    return Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. wait...",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SelectedItem(BuildContext context, value) {
    switch (value) {
      case 0:
        setState(() {
          Navigator.pushNamed(context, AccountForm.id);
        });
        break;
      case 1:
        FirebaseAuth.instance.signOut();
        Navigator.popAndPushNamed(context, LoginScreen.id);
        break;
    }
  }

  Future getImage(bool isgallery) async {
    PickedFile? galleryFile;
    bool isLoading = false;
    if (isgallery) {
      try {
        galleryFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
        );

        if (galleryFile != null) {
          try {
            Widget okButton = TextButton(
              child: const Text(
                "Upload",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () async {
                File file = File(galleryFile!.path);
                String imageName =
                    'profileImage/${DateTime.now().microsecondsSinceEpoch}';
                String downloadUrl;
                await FirebaseStorage.instance.ref(imageName).putFile(file);
                downloadUrl = await FirebaseStorage.instance
                    .ref(imageName)
                    .getDownloadURL();
                _service.uploadProfile(
                    downloadUrl, _service.user!.uid, context);
                Navigator.of(context).pop();
              },
            );
            Widget cacelButton = TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
            AlertDialog alert = AlertDialog(
              title: const Text("Upload Profile"),
              content: Container(
                  height: 200,
                  width: 300,
                  child: Image.file(
                    File(galleryFile.path),
                    fit: BoxFit.cover,
                  )),
              actions: [
                cacelButton,
                okButton,
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
            setState(() {
              imageFile = new File(galleryFile!.path);
            });
          } finally {}
        }
      } catch (e) {
        print(e);
      }
    }
  }
}

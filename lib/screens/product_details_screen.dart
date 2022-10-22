import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/provider/product_provider.dart';
import 'package:haggle/screens/chat/chat_conversation_screen.dart';
import 'package:haggle/screens/chat/chat_screen.dart';
import 'package:haggle/screens/editproduct.dart';
import 'package:haggle/screens/product_list.dart';
import 'package:haggle/screens/sellItems/product_by_category_screen.dart';
import 'package:haggle/screens/sellItems/seller_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:like_button/like_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/product_card.dart';
import 'main_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({Key? key, this.data}) : super(key: key);
  static const String id = 'product-details-screen';
  var data;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _loading = true;
  int _index = 0;
  final _format = NumberFormat("##,##,##0");
  late GoogleMapController _controller;
  final FirebaseService _service = FirebaseService();
  var fav;
  bool _isLiked = false;
  var reviewsData = ['Excellent', 'Very Good', 'Good', 'Average', 'Poor'];
  var userIdList = [];
  bool isliked = false;
  // bool _isLiked = false;
  var likeCount1;
  double size = 20;
  final animationDuration = const Duration(milliseconds: 200);


  // var data;

  var _productProvider;

  @override
  void initState() {
    print('pruduct details: ${widget.data}');
    Timer(const Duration(seconds: 1), () {
      //after 2 secs loading will false
      setState(() {
        _loading = false;
      });
    });
    _service.users.get().then((value) => {
      value.docs.forEach((element) {
        userIdList.add(element.id);
        setState(() {});
      })
    });
    likeCount1 = widget.data['likeCount'][0]['totalLike'];
    isliked = widget.data['likeCount'][0]['isLike'];
    super.initState();
  }

  _mapLauncher(location) async {
    final availableMaps = await launcher.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: "Seller Location is here",
    );
  }

  // _callSeller(number) {
  //   launchUrlString(number);
  // }

  createChatRoom(ProductProvider _provider) {
    Map<String, dynamic> product = {
      'productId': _provider.productData.id,
      'productImage': _provider.productData['images'][0],
      'price': _provider.productData['price'],
      'productname': _provider.productData['productName'],
      'seller': _provider.productData['sellerUid'],
    };
    List<String> users = [
      _provider.sellerDetails['uid'],
      _service.user!.uid,
    ];
    String chatRoomId =
        "${_provider.sellerDetails['uid']}.${_service.user!.uid}.${_provider.productData.id}";
    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'read': false,
      'product': product,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch,
    };
    _service.createChatRoom(
      chatData: chatData,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChatConversations(
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }

  // @override
  // void didChangeDependencies() {
  //   var _productProvider = Provider.of<ProductProvider>(context);
  //   getFavourites(_productProvider);
  //   super.didChangeDependencies();
  // }

  getFavourites(ProductProvider _productProvider) {
    _service.products.doc(_productProvider.productData.id).get().then((value) {
      setState(() {
        fav = value['favourites'];
      });
      // if (fav.contains(_service.user!.uid)) {
      //   setState(() {
      //     _isLiked = true;
      //   });
      // } else {
      //   setState(() {
      //     _isLiked = false;
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('products').where('productId',isEqualTo: widget.data['productId']).snapshots();
    Stream<QuerySnapshot> chatMessageStream = FirebaseFirestore.instance
        .collection('products')
        .where('productId', isEqualTo: widget.data['productId'])
        .snapshots();
    _productProvider = Provider.of<ProductProvider>(context);
    var _catProvider = Provider.of<CategoryProvider>(context);
    var dd = _catProvider.getCategory(widget.data['category']);
    var rattingUserList = [];
    var _price = int.parse(widget.data['price']);
    var excellent = 0;
    var veryGood = 0;
    var good = 0;
    var average = 0;
    var poor = 0;
    print('chatMessageStream ${chatMessageStream}');
    if(widget.data['ratting'] != []) {
      for (var i = 0; i < widget.data['ratting'].length; i++) {
        print('indie: ');
        // (5*252 + 4*124 + 3*40 + 2*29 + 1*33) / (252+124+40+29+33) = 4.11 and change
        if (widget.data['ratting'][i]['rating'] >= 4) {
          setState(() {
            excellent++;
          });
          print('excellentindex: $excellent');
        } else if (widget.data['ratting'][i]['rating'] <= 4 &&
            3 < widget.data['ratting'][i]['rating']) {
          setState(() {
            veryGood++;
          });
          print('verygood: $veryGood');
        } else if (widget.data['ratting'][i]['rating'] <= 3 &&
            2 < widget.data['ratting'][i]['rating']) {
          setState(() {
            good++;
          });
          print('good: $good');
        } else if (widget.data['ratting'][i]['rating'] <= 1 &&
            0 < widget.data['ratting'][i]['rating']) {
          setState(() {
            poor++;
          });
          print('poor: $poor ${widget.data['ratting'][i]['rating']}');
        }
      }}

    var reviewsPercentage = [
      '$excellent%',
      '$veryGood%',
      '$good%',
      '$average%',
      '$poor%'
    ];
    List<double> ratingList = [
      excellent / 5,
      veryGood / 5,
      good / 5,
      average / 5,
      poor / 5
    ];
    var multiRatings =
        excellent * 5 + veryGood * 4 + good * 3 + average * 2 + poor * 1;
    var addAllRtings = excellent + veryGood + good + average + poor;
    var getaverageRtings = multiRatings / addAllRtings;
    String price = _format.format(_price);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Product details ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.share_outlined,
          //     color: Color.fromARGB(
          //       255,
          //       100,
          //       40,
          //       0,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 8),
          //   child: IconButton(
          //     icon: Icon(
          //         _isLiked ? Icons.bookmark_add : Icons.bookmark_add_outlined),
          //     color: _isLiked ? Colors.black : Colors.grey,
          //     onPressed: () {
          //       setState(() {
          //         _isLiked = !_isLiked;
          //       });
          //       // _service.updateFavourite(_isLiked, data.id, context);
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(Icons.share_outlined),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
                // _service.updateFavourite(_isLiked, data.id, context);
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: chatMessageStream,
          builder: (context, snapshot) {
            // print('steam data: ${snapshot.data!.docs[0]['ratting']}');
            return snapshot.data != null
                ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          color: Colors.white,
                          child: _loading
                              ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Loading Your Add',
                                ),
                              ],
                            ),
                          )
                              : Stack(
                            children: [
                              Center(
                                child: PhotoView(
                                  backgroundDecoration:
                                  const BoxDecoration(
                                    // color: Colors.white,
                                  ),
                                  imageProvider: NetworkImage(widget
                                      .data['images'][_index]),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                top: 10,
                                child: LikeButton(
                                  onTap: (isLiked1) async {
                                    _service.getProductDetails(widget.data['productId']).then((value) =>
                                    {
                                      if(isliked || value['likeCount'][0]['isLike'] == true){
                                        setState(() {
                                          isliked = false;
                                          likeCount1--;
                                          _service.updateFavourite(likeCount1,isliked, value['productId'], context);
                                        }),
                                      }else if(value['likeCount'][0]['isLike'] == false){
                                        setState(() {
                                          isliked = true;
                                          likeCount1++;
                                          _service.updateFavourite(likeCount1,isliked, value['productId'], context);
                                        }),
                                      }
                                    });
                                  },
                                  size: 40,
                                  isLiked: isliked,
                                  likeCount: likeCount1,
                                  likeBuilder: (isLiked1) {
                                    final color = isliked || isLiked1 ? Colors.red : Colors.grey;
                                    return Icon(Icons.thumb_up, color: color, size: 26);},
                                  animationDuration: animationDuration,
                                  likeCountPadding: const EdgeInsets.only(left: 5),
                                  countBuilder: (likeCount, isLiked, text) {
                                    final color = isliked || isLiked  ? Colors.black : Colors.black38;
                                    return Text(
                                      "${isLiked ? likeCount1 : likeCount1}",
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },

                                )
                              ),
                              Positioned(
                                bottom: 0.0,
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context)
                                      .size
                                      .width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: ListView.builder(
                                      scrollDirection:
                                      Axis.horizontal,
                                      itemCount: widget
                                          .data['images'].length,
                                      itemBuilder:
                                          (BuildContext context,
                                          int i) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _index = i;
                                            });
                                          },
                                          child: Container(
                                            height: 70,
                                            width: 60,
                                            decoration:
                                            BoxDecoration(
                                                color: Colors
                                                    .white,
                                                border:
                                                Border.all(
                                                  color: Colors
                                                      .black38,
                                                ),
                                                borderRadius:
                                                const BorderRadius
                                                    .all(
                                                    Radius.circular(
                                                        10))),
                                            child: Image.network(
                                                widget.data[
                                                'images'][i]),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10, bottom: 10),
                        child: Container(
                          child: Row(
                            children: [
                              Text(
                                'Type-${widget.data['type']}',
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _loading
                          ? Container()
                          : Container(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        widget.data['productName']
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '₹ $price',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Text(
                                        'Inclusive of all taxes',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            _loading
                                ? Container()
                                : StreamBuilder<QuerySnapshot>(
                                stream:  FirebaseFirestore.instance
                                    .collection('products')
                                    .where('productId', isEqualTo: widget.data['productId'])
                                    .snapshots(),
                                builder: (context, AsyncSnapshot<QuerySnapshot>snapshot1) {
                                  print('all details: ${snapshot1.data}');
                                  return Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.only(
                                                topRight: Radius
                                                    .circular(
                                                    15),
                                                topLeft: Radius
                                                    .circular(
                                                    15)),
                                          ),
                                          builder: (BuildContext context) {
                                            print("data!.docs[0]['ratting'] ${widget.data['ratting']}");
                                            return Scaffold(
                                              appBar: AppBar(
                                                backgroundColor:
                                                Colors.white,
                                                elevation: 0,
                                                title: Text(
                                                  'Review',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .transparent),
                                                ),
                                              ),
                                              body: Container(
                                                height:
                                                MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height,
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius
                                                          .circular(
                                                          30),
                                                      topRight: Radius
                                                          .circular(
                                                          30)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 0),
                                                      child:
                                                      Container(
                                                          child:
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Product Ratings & Review',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    20,
                                                                    fontWeight:
                                                                    FontWeight.bold),
                                                              ),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    // datat.then((value) => {
                                                                    //   // for(var i =0;i<=value.docs.length ; i++){
                                                                    //     print('all employee: ${value['uid']}')
                                                                    //
                                                                    //   // }
                                                                    // });
                                                                    // print('userdetails: ${datat.get()}');
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  icon:
                                                                  Icon(
                                                                    Icons.keyboard_arrow_down_outlined,
                                                                    color:
                                                                    Colors.black,
                                                                    size:
                                                                    26,
                                                                  ))
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(
                                                          8.0),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      getaverageRtings.toString() != 'NaN' ? getaverageRtings.toStringAsFixed(1) : '0',
                                                                      style: TextStyle(color: Colors.green, fontSize: 35, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons.star,
                                                                    color: Colors.green,
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 25),
                                                              Text(
                                                                '${getaverageRtings.toString() != 'NaN' ? getaverageRtings.toStringAsFixed(1) : '0'} ratings',
                                                                style:
                                                                TextStyle(color: Colors.grey),
                                                              ),
                                                              SizedBox(
                                                                  height: 8),
                                                              Text(
                                                                  '${widget.data['ratting'] != [] ? snapshot1.data!.docs[0]['ratting'].length : '0'} reviews',
                                                                  style: TextStyle(color: Colors.grey)),
                                                              SizedBox(
                                                                width:
                                                                30,
                                                              )
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child:
                                                            Container(
                                                              width:
                                                              250,
                                                              child:
                                                              ListView.builder(
                                                                itemCount:
                                                                reviewsData.length,
                                                                shrinkWrap:
                                                                true,
                                                                itemBuilder:
                                                                    (BuildContext context, int index) {
                                                                  print('rtting uid: $rattingUserList');
                                                                  return Padding(
                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text('${reviewsData[index]}'),
                                                                          ],
                                                                        ),
                                                                        // SizedBox(
                                                                        //   width: index == 0
                                                                        //       ? 10
                                                                        //       : index == 1
                                                                        //           ? 3
                                                                        //           : index == 2
                                                                        //               ? 33
                                                                        //               : index == 3
                                                                        //                   ? 16
                                                                        //                   : 38,
                                                                        // ),
                                                                        Row(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: LinearPercentIndicator(
                                                                                animation: true,
                                                                                lineHeight: 6.0,
                                                                                curve: Curves.easeInOutCubic,
                                                                                animationDuration: 2500,
                                                                                linearStrokeCap: LinearStrokeCap.roundAll,
                                                                                progressColor: index == 0
                                                                                    ? Colors.green
                                                                                    : index == 1
                                                                                    ? Colors.lightGreen
                                                                                    : index == 2
                                                                                    ? Colors.lightGreenAccent
                                                                                    : index == 3
                                                                                    ? Colors.orange
                                                                                    : Colors.red,
                                                                                width: MediaQuery.of(context).size.width / 2.7,
                                                                                percent: ratingList[index],
                                                                              ),
                                                                            ),
                                                                            Text('${reviewsPercentage[index]}'),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: 5.0,
                                                          right: 5),
                                                      child:
                                                      Container(
                                                        height: 1,
                                                        width: double
                                                            .infinity,
                                                        color: Colors
                                                            .grey,
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: widget.data['ratting'] !=
                                                          []
                                                          ? true
                                                          : false,
                                                      child:
                                                      Container(
                                                        height: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                            1.5,
                                                        child: StreamBuilder<QuerySnapshot>(
                                                        stream:  FirebaseFirestore.instance
                                                            .collection('products')
                                                            .where('productId', isEqualTo: widget.data['productId'])
                                                            .snapshots(),
                                                        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot1) {
                                                       return snapshot1.data == null ? Container(child: Center(child: CircularProgressIndicator(),),) : ListView.builder(
                                                            itemCount: snapshot1.data!.docs[0]['ratting'].length,
                                                            itemBuilder: (contex, index) {
                                                              rattingUserList.add(snapshot1.data!.docs[0]['ratting'][index]['uid']);
                                                              print('ratting12: ${snapshot1.data!.docs[0]['ratting'].length}');
                                                              return Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      child: Text(
                                                                        '${snapshot1.data!.docs[0]['ratting'] != [] ? snapshot1.data!.docs[0]['ratting'][index]['userName'] : '-'}',
                                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(3.0),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(color: Colors.green, border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(15)),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(3.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        Text(
                                                                                          snapshot1.data!.docs[0]['ratting'][index]['rating'].toString(),
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.star,
                                                                                          size: 17,
                                                                                          color: Colors.white,
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(
                                                                                  '*',
                                                                                  style: TextStyle(color: Colors.grey),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text("Posted on ${snapshot1.data!.docs[0]['ratting'][index]['postedDate'].toString() != '' ? DateFormat('dd MMM, yyyy').format(DateTime.parse(snapshot1.data!.docs[0]['ratting'][index]['postedDate'].toString())) : ''}", style: TextStyle(color: Colors.grey)),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                IconButton(
                                                                                    onPressed: () {
                                                                                      // print('getpresous: ${snapshot.data!.docs[1]['ratting']}');
                                                                                      updateReviewDialog(snapshot1.data!.docs[0]['ratting'][index],snapshot.data!.docs[0]['ratting'],context);
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.edit,
                                                                                      color: Colors.blue,
                                                                                    )),
                                                                                SizedBox(width: 7,),
                                                                                IconButton(
                                                                                    onPressed: () {
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: Text('Review Delete'),
                                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                                              //this right here
                                                                                              content: Text('Do You Want To Delete This Review'),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    _service.rattingRemoe(index, snapshot.data!.docs[0]['productId'], context);
                                                                                                    // print("datat ${ _service.products.doc(widget.data['productId']).update({"ratting":FieldValue.arrayRemove([index])})}");
                                                                                                    _service.products.doc(snapshot.data!.docs[0]['productId']).update({
                                                                                                      "ratting": FieldValue.arrayRemove([
                                                                                                        {
                                                                                                          'postedDate': snapshot1.data!.docs[0]['ratting'][index]['postedDate'],
                                                                                                          'rating': snapshot1.data!.docs[0]['ratting'][index]['rating'],
                                                                                                          'review': snapshot1.data!.docs[0]['ratting'][index]['review'],
                                                                                                          'userName': snapshot1.data!.docs[0]['ratting'][index]['userName'],
                                                                                                          'uid':snapshot1.data!.docs[0]['ratting'][index]['uid'],
                                                                                                        }
                                                                                                      ])
                                                                                                    });
                                                                                                    _service.products.doc('ratting').delete();
                                                                                                    Navigator.of(context).pop();
                                                                                                    // Navigator.of(context).pop();
                                                                                                    const SnackBar(
                                                                                                      content: Text(
                                                                                                        'Review Deleted Successfully !!',
                                                                                                        style: TextStyle(color: Colors.white),
                                                                                                      ),
                                                                                                      behavior: SnackBarBehavior.floating,
                                                                                                      backgroundColor: Colors.green,
                                                                                                    );
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    'Delete',
                                                                                                    style: TextStyle(color: Colors.red, fontSize: 16),
                                                                                                  ),
                                                                                                ),
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                  child: Text(
                                                                                                    'Cancel',
                                                                                                    style: TextStyle(color: Colors.green, fontSize: 16),
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          });
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.delete,
                                                                                      color: Colors.red,
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(snapshot.data!.docs[0]['ratting'] != [] ? snapshot1.data!.docs[0]['ratting'][index]['review'] : '0', style: TextStyle(color: Colors.black)),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                                                                      child: Container(
                                                                        height: 1,
                                                                        width: double.infinity,
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                            );
                                                       },
                                                      ),
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                              floatingActionButton:
                                              FloatingActionButton(
                                                  child: Icon(
                                                      Icons
                                                          .add),
                                                  onPressed:
                                                      () {
                                                        var dd;
                                                    if (userIdList.any((item) => rattingUserList.contains(item))) {
                                                      _service.getUserData().then((value) =>{
                                                        for(var i=0; i< snapshot.data!.docs.length;i++){
                                                          _service.products.doc(widget.data['productId']).get().then((value) => {
                                                      }),
                                                          if( snapshot.data!.docs[0]['ratting'][i]['uid'] == value['uid']){
                                                            setState(() {
                                                              dd = snapshot.data!.docs[0]['ratting'][i]['rating'];
                                                            }),
                                                            showAlertDialog(widget.data['productId'], widget.data['ratting'],dd, context)
                                                        }
                                                        }
                                                      });
                                                    // ScaffoldMessenger.of(context).showSnackBar(
                                                    //     const SnackBar(
                                                    //       content: Text(
                                                    //         "Sorry you can't add more than 1 review for this item !!",
                                                    //         style: TextStyle(color: Colors.white),
                                                    //       ),
                                                    //       behavior: SnackBarBehavior.floating,
                                                    //       backgroundColor: Colors.red,
                                                    //     ));
                                                    // Lists have at least one common element
                                                    // } else {
                                                    //   print('outside');
                                                    }else{
                                                      showAlertDialog(widget.data['productId'], widget.data['ratting'],dd, context);
                                                    }
                                                        // print('previous: ${snapshot.data!.docs[0]['ratting']}');
                                                  }


                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                border: Border.all(
                                                    color: Colors
                                                        .green),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    15)),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .all(3.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "${getaverageRtings.toString() != 'NaN' ? getaverageRtings.toStringAsFixed(1) : '0'}",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                  Icon(
                                                    Icons.star,
                                                    size: 17,
                                                    color: Colors
                                                        .white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Row(children: [
                                            Icon(Icons
                                                .group_outlined),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                                '${widget.data['ratting'].length} reviews')
                                          ])
                                        ],
                                      ),
                                    ),
                                  );}),
                            SizedBox(
                              height: 20,
                            ),
                            // const Divider(
                            //     thickness: 1, height: 50, color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 30,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'PRODUCT TYPE',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.data['type'],
                                        // 'Jeans',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'SELLER TYPE',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        // data['sellerType'],
                                        'Wholesaler',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'TITLE',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.data['productName'],
                                        // 'Denim',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'MATERIAL',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        // data['material'],
                                        'Denim',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'SIZE',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.data['size'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'COLOR',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.data['color'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'MIN QTY',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.data['minQty'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        'SHOP NAME',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: const [
                                            Text(
                                              // data['shopName'],
                                              'ABC Garments',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
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

                            // const Divider(
                            //     thickness: 1, height: 50, color: Colors.black),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                title: const Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Text(
                                          widget
                                              .data['description'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                title: const Text(
                                  'Address',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            TextButton(
                                              child: Text(
                                                _productProvider
                                                    .sellerDetails[
                                                'address'],
                                                style:
                                                const TextStyle(
                                                  color: Colors
                                                      .lightBlue,
                                                  fontSize: 15,
                                                  fontStyle:
                                                  FontStyle
                                                      .italic,
                                                ),
                                              ),
                                              onPressed: () {
                                                // _mapLauncher(_location);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.orange[50],
                                  //     border: Border.all(
                                  //       color: Colors.black,
                                  //     ),
                                  //     borderRadius: const BorderRadius.only(
                                  //       topLeft: Radius.circular(10),
                                  //       topRight: Radius.circular(10),
                                  //     ),
                                  //   ),
                                  //   child: const Padding(
                                  //     padding: EdgeInsets.all(10.0),
                                  //     child: Text(
                                  //       'Shop location',
                                  //       style: TextStyle(
                                  //         color: Colors.black,
                                  //         fontSize: 20,
                                  //         fontWeight: FontWeight.bold,
                                  //         decoration: TextDecoration.underline,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Stack(
                                  //   children: [
                                  //     Center(
                                  //       child: GoogleMap(
                                  //         initialCameraPosition: CameraPosition(
                                  //           target: LatLng(
                                  //             _location.latitude,
                                  //             _location.longitude,
                                  //           ),
                                  //           zoom: 15,
                                  //         ),
                                  //         mapType: MapType.normal,
                                  //         onMapCreated:
                                  //             (GoogleMapController controller) {
                                  //           setState(
                                  //             () {
                                  //               _controller = controller;
                                  //             },
                                  //           );
                                  //         },
                                  //       ),
                                  //     ),
                                  //     Center(
                                  //       child: Icon(
                                  //         Icons.location_on,
                                  //         size: 35,
                                  //         color: Colors.red[900],
                                  //       ),
                                  //     ),
                                  //     // Center(
                                  //     //   child: CircleAvatar(
                                  //     //     radius: 60,
                                  //     //     backgroundColor:
                                  //     //         Colors.red.withOpacity(.2),
                                  //     //   ),
                                  //     // ),
                                  //     Positioned(
                                  //       right: 4.0,
                                  //       top: 4.0,
                                  //       child: Material(
                                  //         elevation: 4,
                                  //         shape: Border.all(
                                  //           color: Colors.orange.shade100,
                                  //         ),
                                  //         child: IconButton(
                                  //           onPressed: () {
                                  //             _mapLauncher(_location);
                                  //           },
                                  //           icon: const Icon(
                                  //               Icons.alt_route_outlined,
                                  //               color: Colors.black),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            // const SizedBox(
                            //   height: 15,
                            // ),

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(
                                //   color: Colors.black,
                                // ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    // const SizedBox(
                                    //   height: 15,
                                    // ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                          Colors.black,
                                          child: CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Colors
                                                .orange.shade100,
                                            child: const Icon(
                                              CupertinoIcons
                                                  .person_alt,
                                              color: Color.fromARGB(
                                                255,
                                                240,
                                                167,
                                                118,
                                              ),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              _productProvider
                                                  .sellerDetails[
                                              'name']
                                                  .toUpperCase(),
                                              style:
                                              const TextStyle(
                                                color:
                                                Color.fromARGB(
                                                    255,
                                                    100,
                                                    40,
                                                    0),
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            subtitle: const Text(
                                              'SEE SELLER PROFILE',
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                    const SellerDetails(),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons
                                                  .arrow_forward_ios),
                                              iconSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: _productProvider.productData[
                              'sellerUid'] !=
                                  _service.user!.uid
                                  ? const Text(
                                'CHAT WITH SELLER FOR MORE DETAILS',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                                  : const Text(''),
                            ),
                          ],
                        ),
                      ),
                      // ProductCard(data: widget.data, formattedPrice: '',),
                      // SizedBox(height: 60,),

                      _loading
                          ? Container()
                          : Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            width: 200,
                            child: TextButton(
                                onPressed: () {
                                  reportAlertDialog(
                                      widget.data['productId'],
                                      widget.data['reportProduct'],
                                      context);
                                },
                                child: Text(
                                  'Report This Products',
                                  style:
                                  TextStyle(color: Colors.blue),
                                ))),
                      ),
                      _loading
                          ? Container()
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                        child: Text(
                              'Releted Products',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16),
                        ),
                      ),
                              Container(
                                  height: 330,
                                  width: double.infinity,
                                  child: SingleChildScrollView(
                                      scrollDirection:
                                      Axis.horizontal,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        color: const Color.fromRGBO(238, 242, 246, 170),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                          child: FutureBuilder<QuerySnapshot>(
                                            // future: _service.products.orderBy('postedAt').get(),
                                            future: _catProvider.selectedSubCategory == null
                                                ? _service.products
                                                .orderBy('postedAt')
                                                .where('category', isEqualTo: _catProvider.selectedCategory)
                                                .get()
                                                : _service.products
                                                .orderBy('postedAt')
                                                .where('subCat', isEqualTo: _catProvider.selectedSubCategory)
                                                .get(),
                                            builder:
                                                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                              if (snapshot.hasError) {
                                                return const Text('Something went wrong');
                                              }

                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const Padding(
                                                  padding: EdgeInsets.only(left: 140, right: 140),
                                                  child: LinearProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                        Colors.black),
                                                    backgroundColor: Color.fromRGBO(238, 242, 246,170),
                                                  ),
                                                );
                                              }
                                              if (snapshot.data!.docs.isEmpty) {
                                                return Container(
                                                  height: MediaQuery.of(context).size.height,
                                                  child: const Center(
                                                    child: Text(
                                                      'No product added\nunder selected category',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              }
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // if (proScreen == false)
                                                  Container(
                                                    width: double.infinity,
                                                    height: 283,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.horizontal,
                                                      physics: const ScrollPhysics(),
                                                      // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      //
                                                      //   maxCrossAxisExtent: 200,
                                                      //   childAspectRatio: 2/3.8 ,
                                                      //   crossAxisSpacing: 8,
                                                      //   mainAxisSpacing: 10,
                                                      // ),
                                                      itemCount: snapshot.data!.size,
                                                      itemBuilder: (BuildContext context, int i) {
                                                        var data = snapshot.data!.docs[i];
                                                        print('datat details: ${data.data()}');
                                                        var _price = int.parse(data['price']);
                                                        // print('product: ${data['likeCount'][0]['isLike']}');
                                                        String _formattedPrice = '₹ ${_format.format(_price)}';

                                                        return ProductCard(
                                                            data: data, formattedPrice: _formattedPrice);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ))),
                            ],
                          ),
                      _loading
                          ? Container()
                          : InkWell(
                        onTap: () {
                          deleteProductAlertDialog(
                              widget.data['productId'], context);
                        },
                        child: Container(
                          // width: 100,
                          // margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent),
                                borderRadius:
                                BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            )
                : Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            );
          }),
      bottomSheet: BottomAppBar(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(
            15,
          ),
          child: _productProvider.productData['sellerUid'] == _service.user!.uid
              ? Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProductDetails(
                              productId: widget.data['productId'],
                            )));
                  },
                  style: const NeumorphicStyle(
                      border: NeumorphicBorder(
                        isEnabled: true,
                        color: Colors.black45,
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Edit Product',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    createChatRoom(_productProvider);
                  },
                  style: const NeumorphicStyle(
                    border: NeumorphicBorder(
                      isEnabled: true,
                      color: Colors.black,
                    ),
                    color: Color.fromRGBO(238, 242, 246, 170),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(CupertinoIcons.chat_bubble_text_fill,
                            size: 16, color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Chat Seller',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(var prid, previous,previousRating, BuildContext context) {
    var reviewCount;
    print('previousrating: $previousRating');
    var reviewEditTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            content: Container(
              height: 146,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      initialRating: previousRating != null ? previousRating : 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Container(
                        width: 7,
                        child: Icon(
                          Icons.star,
                          size: 7,
                          color: Colors.orange,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          reviewCount = rating;
                        });
                        // _service.updateRating(rating,data['productId'],context);
                        print("ratingupdate: $reviewCount");
                      },
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      controller: reviewEditTextController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Review *',
                        labelStyle: const TextStyle(color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        // contentPadding: const EdgeInsets.symmetric(
                        //     vertical: 20.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                      ),
                    ),
                  ]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancle",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  print('reviewcount $reviewCount');
                  if (reviewEditTextController.text.isNotEmpty &&
                      reviewCount != null) {
                    _service.getUserData().then((value) => {
                      setState(() {
                        _service.updateReview(
                            reviewEditTextController.text,
                            prid,
                            value['name'],
                            previous,
                            reviewCount,
                            value['uid'],
                            context);
                      }),
                    });
                    setState(() {});
                    // data = _productProvider.productData;
                    // Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please Enter Review',
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ],
          );
        });
    // var reviewCount;
    // var reviewEditTextController = TextEditingController();
    // Widget okButton = TextButton(
    //     child: const Text(
    //       "Submit",
    //       style: TextStyle(color: Colors.green, fontSize: 16),
    //     ),
    //     onPressed: () {
    //       print('reviewcount $reviewCount');
    //       if (reviewEditTextController.text.isNotEmpty) {
    //         _service.getUserData().then((value) => {
    //               setState(() {
    //                 _service.updateReview(reviewEditTextController.text, prid,
    //                     value['name'], previous,reviewCount, context);
    //               }),
    //             });
    //         data = _productProvider.productData;
    //         Navigator.of(context).pop();
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //             content: Text(
    //               'Please Enter Review',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //             behavior: SnackBarBehavior.floating,
    //             backgroundColor: Colors.red,
    //           ),
    //         );
    //       }
    //     });
    // Widget cancelButton = TextButton(
    //   child: Text(
    //     "Cancle",
    //     style: TextStyle(color: Colors.red, fontSize: 16),
    //   ),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    // AlertDialog alert = AlertDialog(
    //   title: Text("Review"),
    //   content: Column(
    //     children: [
    //       RatingBar.builder(
    //         initialRating: 0.0,
    //         minRating: 1,
    //         direction: Axis.horizontal,
    //         allowHalfRating: true,
    //         itemCount: 5,
    //         // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
    //         itemBuilder: (context, _) => Container(
    //           width: 15,
    //           child: Icon(
    //             Icons.star,
    //             size: 7,
    //             color: Colors.orange,
    //           ),
    //         ),
    //         onRatingUpdate: (rating) {
    //           setState(() {
    //             reviewCount = rating;
    //           });
    //           // _service.updateRating(rating,data['productId'],context);
    //           print("ratingupdate: $reviewCount");
    //         },
    //       ),
    //
    //       TextFormField(
    //         controller: reviewEditTextController,
    //         // enabled: isEnabled,
    //         decoration: InputDecoration(
    //           labelText: 'Review',
    //           hintText: "What's in your mind",
    //           labelStyle: const TextStyle(color: Colors.black),
    //           helperStyle: const TextStyle(color: Colors.black),
    //           errorStyle: const TextStyle(color: Colors.black),
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
    //           enabledBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           errorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedErrorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //         ),
    //         validator: (value) {
    //           if (value!.isEmpty) {
    //             return 'Tell about your speciality';
    //           }
    //           return null;
    //         },
    //       ),
    //     ],
    //   ),
    //   actions: [
    //     cancelButton,
    //     okButton,
    //   ],
    // );
    //
    // // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
  updateReviewDialog(var reviewData,previous,BuildContext context) {
    var reviewCount;
    var reviewEditTextController = TextEditingController();
    reviewEditTextController.text = reviewData['review'];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            content: Container(
              height: 146,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      initialRating: double.parse(reviewData['rating'].toString()),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Container(
                        width: 7,
                        child: Icon(
                          Icons.star,
                          size: 7,
                          color: Colors.orange,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          reviewCount = rating;
                        });
                        // _service.updateRating(rating,data['productId'],context);
                        print("ratingupdate: $reviewCount");
                      },
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      controller: reviewEditTextController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Review *',
                        labelStyle: const TextStyle(color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        // contentPadding: const EdgeInsets.symmetric(
                        //     vertical: 20.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                      ),
                    ),
                  ]),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancle",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  print('reviewcount $reviewCount');
                  if (reviewEditTextController.text.isNotEmpty ||reviewCount != null) {
                    // _service.products.doc(widget.data['productId']).collection('ratting').doc().update({
                    //   "ratting" : FieldValue.arrayRemove([{
                    //     'postedDate': reviewData['postedDate'],
                    //     'rating': reviewData['rating'],
                    //     'review': reviewData['review'],
                    //     'userName': reviewData['userName'],
                    //     'uid':reviewData['uid'],
                    //   }]),
                    //   'uid':reviewData['uid']
                    //   "ratting" : FieldValue.arrayRemove([{
                    //     'postedDate': reviewData['postedDate'],
                    //     'rating': reviewData['rating'],
                    //     'review': reviewData['review'],
                    //     'userName': reviewData['userName'],
                    //     'uid':reviewData['uid'],
                    //   }]),
                    //
                    // });
                    // _service.products.doc('ratting').delete();
                    // Future.delayed(Duration(seconds: 2),(){
                      _service.getUserData().then((value) => {
                        // setState(() {
                        //   _service.products.doc(widget.data['productId']).collection('ratting').doc(value['uid']).get().then((value) => {
                        //     print('indidedddd: ${value.data()}'),
                          // });
                          _service.updateNewReview(reviewEditTextController.text, widget.data['productId'], value['name'],reviewCount,value['uid'], context),
                      // });
                      // setState(() {});
                      // data = _productProvider.productData;
                      Navigator.of(context).pop(),
                      Navigator.of(context).pop(),
                    });

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please Enter Review',
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ],
          );
        });
    // var reviewCount;
    // var reviewEditTextController = TextEditingController();
    // Widget okButton = TextButton(
    //     child: const Text(
    //       "Submit",
    //       style: TextStyle(color: Colors.green, fontSize: 16),
    //     ),
    //     onPressed: () {
    //       print('reviewcount $reviewCount');
    //       if (reviewEditTextController.text.isNotEmpty) {
    //         _service.getUserData().then((value) => {
    //               setState(() {
    //                 _service.updateReview(reviewEditTextController.text, prid,
    //                     value['name'], previous,reviewCount, context);
    //               }),
    //             });
    //         data = _productProvider.productData;
    //         Navigator.of(context).pop();
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //             content: Text(
    //               'Please Enter Review',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //             behavior: SnackBarBehavior.floating,
    //             backgroundColor: Colors.red,
    //           ),
    //         );
    //       }
    //     });
    // Widget cancelButton = TextButton(
    //   child: Text(
    //     "Cancle",
    //     style: TextStyle(color: Colors.red, fontSize: 16),
    //   ),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    // AlertDialog alert = AlertDialog(
    //   title: Text("Review"),
    //   content: Column(
    //     children: [
    //       RatingBar.builder(
    //         initialRating: 0.0,
    //         minRating: 1,
    //         direction: Axis.horizontal,
    //         allowHalfRating: true,
    //         itemCount: 5,
    //         // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
    //         itemBuilder: (context, _) => Container(
    //           width: 15,
    //           child: Icon(
    //             Icons.star,
    //             size: 7,
    //             color: Colors.orange,
    //           ),
    //         ),
    //         onRatingUpdate: (rating) {
    //           setState(() {
    //             reviewCount = rating;
    //           });
    //           // _service.updateRating(rating,data['productId'],context);
    //           print("ratingupdate: $reviewCount");
    //         },
    //       ),
    //
    //       TextFormField(
    //         controller: reviewEditTextController,
    //         // enabled: isEnabled,
    //         decoration: InputDecoration(
    //           labelText: 'Review',
    //           hintText: "What's in your mind",
    //           labelStyle: const TextStyle(color: Colors.black),
    //           helperStyle: const TextStyle(color: Colors.black),
    //           errorStyle: const TextStyle(color: Colors.black),
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
    //           enabledBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           errorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedErrorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //         ),
    //         validator: (value) {
    //           if (value!.isEmpty) {
    //             return 'Tell about your speciality';
    //           }
    //           return null;
    //         },
    //       ),
    //     ],
    //   ),
    //   actions: [
    //     cancelButton,
    //     okButton,
    //   ],
    // );
    //
    // // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }

  reportAlertDialog(var prid, previous, BuildContext context) {
    var reviewCount;
    var reportEditTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Report'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            content: Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: reportEditTextController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'What You Want to Report ?'),
                      ),
                      // SizedBox(height: 10,),
                    ]),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancle",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (reportEditTextController.text.isNotEmpty) {
                    _service.updateProductReport(reportEditTextController.text,
                        prid, _service.user!.uid, previous, context);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please Enter Report',
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ],
          );
        });
    // var reviewCount;
    // var reviewEditTextController = TextEditingController();
    // Widget okButton = TextButton(
    //     child: const Text(
    //       "Submit",
    //       style: TextStyle(color: Colors.green, fontSize: 16),
    //     ),
    //     onPressed: () {
    //       print('reviewcount $reviewCount');
    //       if (reviewEditTextController.text.isNotEmpty) {
    //         _service.getUserData().then((value) => {
    //               setState(() {
    //                 _service.updateReview(reviewEditTextController.text, prid,
    //                     value['name'], previous,reviewCount, context);
    //               }),
    //             });
    //         data = _productProvider.productData;
    //         Navigator.of(context).pop();
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //             content: Text(
    //               'Please Enter Review',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //             behavior: SnackBarBehavior.floating,
    //             backgroundColor: Colors.red,
    //           ),
    //         );
    //       }
    //     });
    // Widget cancelButton = TextButton(
    //   child: Text(
    //     "Cancle",
    //     style: TextStyle(color: Colors.red, fontSize: 16),
    //   ),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    // AlertDialog alert = AlertDialog(
    //   title: Text("Review"),
    //   content: Column(
    //     children: [
    //       RatingBar.builder(
    //         initialRating: 0.0,
    //         minRating: 1,
    //         direction: Axis.horizontal,
    //         allowHalfRating: true,
    //         itemCount: 5,
    //         // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
    //         itemBuilder: (context, _) => Container(
    //           width: 15,
    //           child: Icon(
    //             Icons.star,
    //             size: 7,
    //             color: Colors.orange,
    //           ),
    //         ),
    //         onRatingUpdate: (rating) {
    //           setState(() {
    //             reviewCount = rating;
    //           });
    //           // _service.updateRating(rating,data['productId'],context);
    //           print("ratingupdate: $reviewCount");
    //         },
    //       ),
    //
    //       TextFormField(
    //         controller: reviewEditTextController,
    //         // enabled: isEnabled,
    //         decoration: InputDecoration(
    //           labelText: 'Review',
    //           hintText: "What's in your mind",
    //           labelStyle: const TextStyle(color: Colors.black),
    //           helperStyle: const TextStyle(color: Colors.black),
    //           errorStyle: const TextStyle(color: Colors.black),
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
    //           enabledBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           errorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedErrorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //         ),
    //         validator: (value) {
    //           if (value!.isEmpty) {
    //             return 'Tell about your speciality';
    //           }
    //           return null;
    //         },
    //       ),
    //     ],
    //   ),
    //   actions: [
    //     cancelButton,
    //     okButton,
    //   ],
    // );
    //
    // // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }

  deleteProductAlertDialog(var prid, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Product Delete'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            content: Text('Do You Want To Delete This Product'),
            actions: [
              TextButton(
                onPressed: () {
                  _service.users.doc(widget.data['sellerUid']).update({
                    "productId": FieldValue.arrayRemove([prid])
                  });

                  _service.products.doc(prid).delete();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  const SnackBar(
                    content: Text(
                      'Product Deleted Successfully !!',
                      style: TextStyle(color: Colors.white),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  );
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              )
            ],
          );
        });
    // var reviewCount;
    // var reviewEditTextController = TextEditingController();
    // Widget okButton = TextButton(
    //     child: const Text(
    //       "Submit",
    //       style: TextStyle(color: Colors.green, fontSize: 16),
    //     ),
    //     onPressed: () {
    //       print('reviewcount $reviewCount');
    //       if (reviewEditTextController.text.isNotEmpty) {
    //         _service.getUserData().then((value) => {
    //               setState(() {
    //                 _service.updateReview(reviewEditTextController.text, prid,
    //                     value['name'], previous,reviewCount, context);
    //               }),
    //             });
    //         data = _productProvider.productData;
    //         Navigator.of(context).pop();
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(
    //             content: Text(
    //               'Please Enter Review',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //             behavior: SnackBarBehavior.floating,
    //             backgroundColor: Colors.red,
    //           ),
    //         );
    //       }
    //     });
    // Widget cancelButton = TextButton(
    //   child: Text(
    //     "Cancle",
    //     style: TextStyle(color: Colors.red, fontSize: 16),
    //   ),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    // AlertDialog alert = AlertDialog(
    //   title: Text("Review"),
    //   content: Column(
    //     children: [
    //       RatingBar.builder(
    //         initialRating: 0.0,
    //         minRating: 1,
    //         direction: Axis.horizontal,
    //         allowHalfRating: true,
    //         itemCount: 5,
    //         // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
    //         itemBuilder: (context, _) => Container(
    //           width: 15,
    //           child: Icon(
    //             Icons.star,
    //             size: 7,
    //             color: Colors.orange,
    //           ),
    //         ),
    //         onRatingUpdate: (rating) {
    //           setState(() {
    //             reviewCount = rating;
    //           });
    //           // _service.updateRating(rating,data['productId'],context);
    //           print("ratingupdate: $reviewCount");
    //         },
    //       ),
    //
    //       TextFormField(
    //         controller: reviewEditTextController,
    //         // enabled: isEnabled,
    //         decoration: InputDecoration(
    //           labelText: 'Review',
    //           hintText: "What's in your mind",
    //           labelStyle: const TextStyle(color: Colors.black),
    //           helperStyle: const TextStyle(color: Colors.black),
    //           errorStyle: const TextStyle(color: Colors.black),
    //           contentPadding:
    //               const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
    //           enabledBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           errorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //           focusedErrorBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(12.0),
    //             borderSide: const BorderSide(color: Colors.black, width: .4),
    //           ),
    //         ),
    //         validator: (value) {
    //           if (value!.isEmpty) {
    //             return 'Tell about your speciality';
    //           }
    //           return null;
    //         },
    //       ),
    //     ],
    //   ),
    //   actions: [
    //     cancelButton,
    //     okButton,
    //   ],
    // );
    //
    // // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }

}

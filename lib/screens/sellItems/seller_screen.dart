import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/provider/product_provider.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/screens/sellItems/seller_category_list.dart';
import 'package:haggle/widgets/product_card.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:provider/provider.dart';
import '../../services/firebase_services.dart';

class SellerDetails extends StatefulWidget {
  const SellerDetails({Key? key}) : super(key: key);

  @override
  State<SellerDetails> createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  bool _loading = true;
  int _index = 0;
  final _format = NumberFormat("##,##,##0");
  late GoogleMapController _controller;
  final FirebaseService _service = FirebaseService();
  List fav = [];
  bool _isLiked = false;
  var uploadedProduct = [];
  var data1 = [];
  var getaverageRtings;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      //after 2 secs loading will false
      var userData = _service.getUserData();
      userData.then((value) {
        setState(() {
          data1.add(value);
          uploadedProduct = value['productId'];
        });
        print('userdate: ${uploadedProduct}');
        getSellerRating();
      });
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  getSellerRating() {
    var excellent = 0;
    var veryGood = 0;
    var good = 0;
    var average = 0;
    var poor = 0;
    for (var i = 0; i < data1[0]['ratting'].length; i++) {
      // (5*252 + 4*124 + 3*40 + 2*29 + 1*33) / (252+124+40+29+33) = 4.11 and change
      if (data1[0]['ratting'][i]['rating'] >= 4) {
        setState(() {
          excellent++;
        });
        print('excellentindex: $excellent');
      } else if (data1[0]['ratting'][i]['rating'] <= 4 &&
          3 <= data1[0]['ratting'][i]['rating']) {
        setState(() {
          veryGood++;
        });
        print('verygood: $veryGood');
      } else if (data1[0]['ratting'][i]['rating'] <= 3 &&
          2 <= data1[0]['ratting'][i]['rating']) {
        setState(() {
          good++;
        });
        print('good: $good');
      } else if (data1[0]['ratting'][i]['rating'] <= 1 &&
          0 < data1[0]['ratting'][i]['rating']) {
        setState(() {
          poor++;
        });
        print('poor: $poor ${data1[0]['ratting'][i]['rating']}');
      }
    }
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
    getaverageRtings = multiRatings / addAllRtings;
    print('datat $reviewsPercentage $ratingList $getaverageRtings');
  }

  _mapLauncher(location) async {
    final availableMaps = await launcher.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: "Seller Location is here",
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat("##,##,##0");
    var _productProvider = Provider.of<ProductProvider>(context);
    var _catProvider = Provider.of<CategoryProvider>(context);
    var data = _productProvider.productData;

    GeoPoint _location = _productProvider.sellerDetails['location'];
    return data1.isNotEmpty
        ? DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
                elevation: 0,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                title: const Text(
                  'Seller Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                bottom: const TabBar(
                  indicatorColor: Colors.black,
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorWeight: 6,
                  tabs: [
                    Tab(
                      child: Text(
                        'Seller Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Seller Products',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                            radius: 50,
                                            backgroundColor: Colors.black,
                                            backgroundImage:
                                                data1[0]['profile'] != null
                                                    ? NetworkImage(
                                                        data1[0]['profile'])
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
                                          //       child: const Icon(
                                          //         Icons.camera_enhance,
                                          //         color: Colors.black,
                                          //         size: 15,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${data1[0]['name'] ?? ""}',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${data1[0]['seller_type'] ?? ""}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 30, 20, 20),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // InkWell(
                                            //   onTap:(){
                                            //     showAlertDialog(context);
                                            //   },
                                            //   child: Container(
                                            //     width: 50,
                                            //     decoration: BoxDecoration(
                                            //         color: Colors.green,
                                            //         border: Border.all(
                                            //             color: Colors.green),
                                            //         borderRadius:
                                            //         BorderRadius.circular(
                                            //             15)),
                                            //     child: Padding(
                                            //       padding:
                                            //       const EdgeInsets.all(
                                            //           3.0),
                                            //       child: Row(
                                            //         mainAxisAlignment:
                                            //         MainAxisAlignment
                                            //             .spaceEvenly,
                                            //         children: [
                                            //           Text(
                                            //             "${getaverageRtings.toString() != 'NaN' ? getaverageRtings.toStringAsFixed(1) :'0'}",
                                            //             style: TextStyle(
                                            //                 color:
                                            //                 Colors.white),
                                            //           ),
                                            //           Icon(
                                            //             Icons.star,
                                            //             size: 17,
                                            //             color: Colors.white,
                                            //           )
                                            //         ],
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),

                                            Column(
                                              children: [
                                                Text(
                                                  "${getaverageRtings.toString() != 'NaN' ? getaverageRtings.toStringAsFixed(1) : '0'}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Rating',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  '${uploadedProduct.length.toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  'Uploads',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                              children: const [
                                                Text(
                                                  '10',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Favourites',
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
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 30),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${data1[0]['about'] ?? ""}',
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
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                        //   child: Row(
                        //     children: const [
                        //       Text(
                        //         'About',
                        //         style: TextStyle(
                        //             fontSize: 20, fontWeight: FontWeight.w900),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        const SizedBox(
                          height: 20,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                        //   child: Row(
                        //     children: const [
                        //       Text(
                        //         'Details',
                        //         style: TextStyle(
                        //             fontSize: 20, fontWeight: FontWeight.w900),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        Container(
                          padding: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':  ${data1[0]['contactDetails']['phone'] ?? ""}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':  ${data1[0]['shop_name'] ?? ""}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':  ${data1[0]['email'] ?? ""}',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // 'add',
                                            ':  ${data1[0]['address'] ?? ""}',
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

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(10.0),
                        //     ),
                        //
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //         left: 20, right: 20, top: 10, bottom: 20),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             const SizedBox(height: 30),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'Phone:',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 20),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'Shop Name:',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 20),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'Email:',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 20),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'Address:',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //         const SizedBox(width: 20),
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             const SizedBox(height: 30),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   '7838911825',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 20),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'LM Garments',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 20),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'lakshaymeena171@gmail.com',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 20),
                        //             Row(
                        //
                        //               children: const [
                        //                 Text(
                        //                   'South delhi ',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black,
                        //                       ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: FutureBuilder<QuerySnapshot>(
                      future: _service.products
                          .where('sellerUid', isEqualTo: data['sellerUid'])
                          .orderBy('postedAt')
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 140, right: 140),
                            child: Center(
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 2 / 3.8,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 0,
                                ),
                                itemCount: snapshot.data!.size,
                                itemBuilder: (BuildContext context, int i) {
                                  var data = snapshot.data!.docs[i];
                                  var _price = int.parse(data['price']);
                                  String _formattedPrice =
                                      '₹ ${_format.format(_price)}';

                                  return ProductCard(
                                      data: data,
                                      formattedPrice: _formattedPrice);
                                },
                              ),
                            ),
                            // Expanded(child: child)
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ));
  }

  showAlertDialog(BuildContext context) {
    var reviewCount;
    var reviewEditTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            content: Container(
              height: 30,
              child: RatingBar.builder(
                initialRating: 0.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Container(
                  width: 7,
                  child: const Icon(
                    Icons.star,
                    size: 7,
                    color: Colors.black,
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
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancle",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  print('reviewcount $reviewCount');
                  // _service.getUserData().then((value) => {
                  //   setState(() {
                  // ,sellereId :
                  _service.updateReviewForSeller(
                      sellerId: data1[0]['uid'],
                      userName: _service.user!.uid,
                      previous:
                          data1[0]['ratting'] != [] ? data1[0]['ratting'] : '',
                      ratingCount: reviewCount,
                      context: context);
                  // }),
                  // });
                  // data = _productProvider.productData;
                  Navigator.of(context).pop();
                },
                child: const Text(
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
}

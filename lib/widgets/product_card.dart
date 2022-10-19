import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/provider/product_provider.dart';
import 'package:haggle/screens/product_details_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:haggle/widgets/likedcounter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
    required String formattedPrice,
  })  : _formattedPrice = formattedPrice,
        super(key: key);

  final QueryDocumentSnapshot<Object?> data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _format = NumberFormat("##,##,##0");
  final FirebaseService _service = FirebaseService();
  String address = '';
  late DocumentSnapshot sellerDetails;
  List ratingList = [];
  // var ratingCount = 0;
  double size = 20;
  var count = 0;
  final animationDuration = const Duration(milliseconds: 200);
  bool isliked = false;
  var userIdList = [];
  // bool _isLiked = false;
  var likeCount1;

  @override
  void initState() {
    getSellerData();
    // print('datat: ${widget.data['likeCount'] == []}');
    // getFavourites();
    likeCount1 = widget.data['likeCount'][0]['totalLike'];
    isliked = widget.data['likeCount'][0]['isLike'];
    _service.users.get().then((value) => {
          value.docs.forEach((element) {
            userIdList.add(element.id);
            setState(() {});
          })
        });

    super.initState();
  }

  getSellerData() {
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'] ?? '';
          sellerDetails = value;
        });
      }
    });
  }

  // getFavourites() {
  //   _service.products.doc(widget.data.id).get().then((value) {
  //     if (mounted) {
  //       setState(() {
  //         ratingList = value['favourites'];
  //       });
  //     }
  //     if (ratingList.contains(_service.user!.uid)) {
  //       setState(() {
  //         _isLiked = true;
  //       });
  //     } else {
  //       if (mounted) {
  //         setState(() {
  //           _isLiked = false;
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider.getProductDetails(widget.data);
    print('ddddddd: ${widget.data['ratting']}');
    var excellent = 0;
    var veryGood = 0;
    var good = 0;
    var average = 0;
    var poor = 0;
    if (widget.data['ratting'] == [{}]) {
      for (var i = 0; i < widget.data['ratting'].length; i++) {
        // (5*252 + 4*124 + 3*40 + 2*29 + 1*33) / (252+124+40+29+33) = 4.11 and change
        if (widget.data['ratting'][i]['rating'] >= 4) {
          setState(() {
            excellent++;
          });
          print('excellentindex: $excellent');
        } else if (widget.data['ratting'][i]['rating'] <= 4 &&
            3 <= widget.data['ratting'][i]['rating']) {
          setState(() {
            veryGood++;
          });
          print('verygood: $veryGood');
        } else if (widget.data['ratting'][i]['rating'] <= 3 &&
            2 <= widget.data['ratting'][i]['rating']) {
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
    var getaverageRtings = multiRatings / addAllRtings;
    print('datat $reviewsPercentage $ratingList $getaverageRtings');
    // ratingCount = widget.data['ratingCount'];
    return InkWell(
        onTap: () {
          _provider.getProductDetails(widget.data);
          _provider.getSellerDetails(sellerDetails);
          // print('productdetails: $')
          // Navigator.pushNamed(context, ProductDetailsScreen.id);
          // _service.getProductDetails(widget.data['productId']);
          // print('product id: ${widget.data['productId']}');
          _service.getProductDetails(widget.data['productId']).then((value) => {
                print('datat product: ${value.data()}'),
                _provider.getProductDetails(widget.data),
                _provider.getSellerDetails(sellerDetails),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                            data: value.data(),
                          )),
                )
                // Navigator.pushNamed(context,  MaterialPageRoute(builder: (context) => ProductDetailsScreen()), ProductDetailsScreen.id)
              });
          // _provider.getProductDetails(widget.data);
          // _provider.getSellerDetails(sellerDetails);
          // Navigator.pushNamed(context, ProductDetailsScreen.id);
        },
        child: Container(
          decoration:  const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(
            //   10,
            // ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          height: 295,
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.network(
                                  widget.data['images'][0],
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                 Padding(
                   padding: const EdgeInsets.fromLTRB(12,0, 12, 10),
                   child: Column(
                    children: [
                       Row(
                      children: [
                        Text(
                          widget.data['productName'],
                          style: GoogleFonts.breeSerif(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                   
                    Row(
                      children: [
                        Text(
                          '${widget.data['type']}',
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 12,

                            // fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                     SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          widget._formattedPrice,
                          style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 5),
                    // Text(
                    //   widget.data['description'],
                    //   style: const TextStyle(
                    //     fontSize: 13,
                    //     color: Colors.black,
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // const Text(
                    //   'Tap here for more...',
                    //   style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.black38,
                    //       fontStyle: FontStyle.italic),
                    // ),
                    Row(
                      children: [
                        // onTap: (){
                        //   if(ratingList.length+ratingCount < 7) {
                        //     setState(() {
                        //       ratingCount++;
                        //       ratingList.add(ratingCount);
                        //     });
                        //     ratingCount = widget.data['rattingCount'].length;
                        //     var previousRating = widget.data['rattingCount'];
                        //     _service.updateRating(ratingList,previousRating, widget.data['productId'], context);
                        //   }else{
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text(
                        //           "Sorry you don't submit more than 7 Ratings !!",
                        //           style: TextStyle(color: Colors.white),
                        //         ),
                        //         behavior: SnackBarBehavior.floating,
                        //         backgroundColor: Colors.red,
                        //       ),
                        //     );
                        //   }
                        // },
                        Container(
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${getaverageRtings.toString() != 'NaN' ? getaverageRtings.toStringAsFixed(1) : '0'}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11,),
                                ),
                                // Text(widget.data['ratingCount'] != 0 ? '${(widget.data['ratingCount']/userIdList.length).toStringAsFixed(0)}':'0' ,style: TextStyle(color: Colors.white,fontSize: 16),),
                                const Icon(
                                  Icons.star,
                                  size: 8,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(width: 10,),
                        // IconButton(onPressed: (){
                        //   _service.products.doc(widget.data['productId']).delete();
                        // }, icon: Icon(Icons.delete)),
                      ],
                    ),
                    ],
                   ),
                 ),
                ],
              ),
              Positioned(
                right: 10.0,
                top: 15,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, bottom: 2, top: 2),
                      child: LikeButton(
                        onTap: (isLiked1) async {
                          _service
                              .getProductDetails(widget.data['productId'])
                              .then((value) => {
                                    if (isliked ||
                                        value['likeCount'][0]['isLike'] ==
                                            true)
                                      {
                                        setState(() {
                                          isliked = false;
                                          likeCount1--;
                                          _service.updateFavourite(
                                              likeCount1,
                                              isliked,
                                              value['productId'],
                                              context);
                                        }),
                                      }
                                    else if (value['likeCount'][0]
                                            ['isLike'] ==
                                        false)
                                      {
                                        setState(() {
                                          isliked = true;
                                          likeCount1++;
                                          _service.updateFavourite(
                                              likeCount1,
                                              isliked,
                                              value['productId'],
                                              context);
                                        }),
                                      }
                                  });
                        },
                        size: size,
                        isLiked: isliked,
                        likeCount: likeCount1,
                        likeBuilder: (isLiked1) {
                          final color = isliked || isLiked1
                              ? Colors.red
                              : Colors.grey;
                          return Icon(Icons.favorite,
                              color: color, size: size);
                        },
                        animationDuration: animationDuration,
                        likeCountPadding: const EdgeInsets.only(left: 5),
                        countBuilder: (likeCount, isLiked, text) {
                          final color = isliked || isLiked
                              ? Colors.black
                              : Colors.black38;
                          return Text(
                            "${isLiked ? likeCount1 : likeCount1}",
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   icon: Icon(
              //       _isLiked ? Icons.favorite : Icons.favorite_border),
              //   color: _isLiked
              //       ?  Colors.red
              //       : Colors.black45,
              //   onPressed: () {
              //     setState(() {
              //       _isLiked = !_isLiked;
              //     });
              //     _service.updateFavourite(
              //         _isLiked, widget.data.id, context);
              //   },
              // ),
            ],
          ),
        ));
  }
}

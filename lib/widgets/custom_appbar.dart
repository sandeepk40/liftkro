import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/provider/product_provider.dart';
import 'package:haggle/screens/home_screen.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:haggle/services/search_services.dart';
import 'package:provider/provider.dart';

import '../screens/location_screen.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final FirebaseService _service = FirebaseService();
  final SearchService _search = SearchService();
  static List<Products> products = [];
  RangeValues _currentRangeValues = const RangeValues(500, 10000);

  String address = '';
  double value = 0;
  DocumentSnapshot? sellerDetails;

  @override
  void initState() {
    super.initState();
  }

  getSellerAddress(sellerId) {
    _service.getSellerData(sellerId).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    FirebaseService _service = FirebaseService();
    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['address'] == null) {
            //then will check next data
            // GeoPoint latLong = data['location'];
            // _service
            //     .getAddress(latLong.latitude, latLong.longitude)
            //     .then((adres) {
            //   return appBar(adres, context, _provider, sellerDetails);
            // });
          } else {
            return appBar(data['address'], context, _provider, sellerDetails);
          }
        }
        return appBar('Fetching location', context, _provider, sellerDetails);
      },
    );
  }

  Widget appBar(address, context, _provider, sellerDetails) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 100, 40, 0)),
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'LiftKaro',
              style: GoogleFonts.michroma(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      // title: InkWell(
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => const LocationScreen(
      //           popScreen: MainScreen.id,
      //         ),
      //       ),
      //     );
      //   },
      //   child: Container(
      //     width: MediaQuery.of(context).size.width,
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 8, bottom: 8),
      //       child: Row(
      //         children: [
      //           const Icon(CupertinoIcons.location_solid,
      //               color: Colors.black, size: 18),
      //           Flexible(
      //             // address overflow from right
      //             child: Text(
      //               address,
      //               style: const TextStyle(
      //                 color: Colors.black,
      //                 fontSize: 12,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //           const Icon(
      //             Icons.keyboard_arrow_down_outlined,
      //             color: Colors.black,
      //             size: 18,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Color.fromRGBO(238, 242, 246, 170),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        readOnly: true,
                        autofocus: false,
                        onTap: () {
                          _service.users.get().then((value) =>
                              _service.products.get().then(
                                    (QuerySnapshot snapshot) {
                                  products = [];
                                  print('iniside: ${snapshot.docs.length}');
                                  for(var i=0 ;i<snapshot.docs.length;i++){
                                    setState(
                                          () {
                                        print("price123: ${int.parse(snapshot.docs[i]['price'])} ${_currentRangeValues.start.toInt() <= int.parse(snapshot.docs[i]['price'])  && int.parse(snapshot.docs[i]['price']) <= _currentRangeValues.end.toInt()}");
                                        // <= _currentRangeValues.start.toInt() || _currentRangeValues.end.toInt() <= int.parse(doc['price'])}");
                                        if(_currentRangeValues.start.toInt() <= int.parse(snapshot.docs[i]['price'])  && int.parse(snapshot.docs[i]['price']) <= _currentRangeValues.end.toInt()) {
                                        products.add(
                                          Products(
                                            document: snapshot.docs[i],
                                            type: snapshot.docs[i]['type'],
                                            description: snapshot.docs[i]['description'],
                                            category: snapshot.docs[i]['category'],
                                            // subCat: doc['subCat'],
                                            shopName: value.docs[0]['shop_name'],
                                            material: snapshot.docs[i]['material'],
                                            productName: snapshot.docs[i]['productName'],
                                            sellerType: value
                                                .docs[0]['seller_type'],
                                            postedDate: snapshot.docs[i]['postedAt'],
                                            price: snapshot.docs[i]['price'],
                                          ),
                                        );
                                        }
                                        getSellerAddress(snapshot.docs[i]['sellerUid']);
                                      },
                                    );
                                  }
                                  snapshot.docs.forEach(
                                        (doc) {

                                      print('product detailsdd ${products.length}');
                                        },
                                  );
                                },
                              ));
                          _search.search(
                            context: context,
                            productsList: products,
                            address: address,
                            provider: _provider,
                            sellerDetails: sellerDetails,
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black38),
                          hintText: 'Search Product/Shop/Brand/Category...',
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: .4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.black,width: .4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: .4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: .4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: (){
                      dilog(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        'assets/images/filter.png',
                        height: 8,
                        width: 8,
                        // fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  dilog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return Dialog(
              child: Container(
                  height: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_currentRangeValues.start.round().toString(),
                            ),
                            Text(_currentRangeValues.end.round().toString()),
                          ],
                        ),
                      ),

                      RangeSlider(
                        values: _currentRangeValues,
                        min: 500,
                        max: 10000,
                        divisions: 10,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),

                        onChanged: (RangeValues values) {
                          // setState(() {
                          innerSetState(() {
                            _currentRangeValues = values;
                          });
                          // });
                        },

                      ),
                      SizedBox(height: 30,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 140,),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.pink, fontSize: 16),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },

                            child: Text(
                              'Apply',
                              style: TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ),
                        ],
                      ),


                    ],
                  )
              ),

            );
          });
        });
    // actions: [
    //   TextButton(
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //     child: Text(
    //       'Cancel',
    //       style: TextStyle(color: Colors.pink, fontSize: 16),
    //     ),
    //   ),
    //   TextButton(
    //     onPressed: () {},
    //
    //     child: Text(
    //       'Apply',
    //       style: TextStyle(color: Colors.green, fontSize: 16),
    //     ),
    //   ),
    // ],
  }

}



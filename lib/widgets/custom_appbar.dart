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
  String address = '';
  DocumentSnapshot? sellerDetails;

  @override
  void initState() {
    _service.products.get().then(
      (QuerySnapshot snapshot) {
        products = [];
        snapshot.docs.forEach(
          (doc) {
            setState(
              () {
                products.add(
                  Products(
                    document: doc,
                    type: doc['type'],
                    description: doc['description'],
                    category: doc['category'],
                    // subCat: doc['subCat'],
                    // shopName: doc['shopName'],
                    // material: doc['material'],
                    productName: doc['productName'],
                    // sellerType: doc['sellerType'],
                    postedDate: doc['postedAt'],
                    price: doc['price'],
                  ),
                );
                getSellerAddress(doc['sellerUid']);
              },
            );
          },
        );
      },
    );
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
     
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LiftKaro',
            style: GoogleFonts.michroma(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 150,),
          const Icon(Icons.search_outlined,size: 30,color: Colors.black,),
          const SizedBox(width: 10,),
          const Icon(Icons.notifications,size: 28,color:Colors.black,),
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
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(56),
      //   child: InkWell(
      //     onTap: () {},
      //     child: Container(
      //       color: Color.fromRGBO(238, 242, 246, 170),
      //       child: Padding(
      //         padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: SizedBox(
      //                 height: 45,
      //                 child: TextField(
      //                   readOnly: true,
      //                   autofocus: false,
      //                   onTap: () {
      //                     _search.search(
      //                       context: context,
      //                       productsList: products,
      //                       address: address,
      //                       provider: _provider,
      //                       sellerDetails: sellerDetails,
      //                     );
      //                   },
      //                   decoration: InputDecoration(
      //                     prefixIcon:
      //                         const Icon(Icons.search, color: Colors.black38),
      //                     hintText: 'Search by Product/Shop/Brand/Category...',
      //                     hintStyle: TextStyle(fontSize: 14),
      //                     contentPadding:
      //                         const EdgeInsets.only(left: 10, right: 10),
      //                     border: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(
      //                         10,
      //                       ),
      //                     ),
      //                     enabledBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(12.0),
      //                       borderSide: const BorderSide(
      //                           color: Colors.black, width: .4),
      //                     ),
      //                     focusedBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(12.0),
      //                       borderSide: const BorderSide(
      //                           color: Colors.black,width: .4),
      //                     ),
      //                     errorBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(12.0),
      //                       borderSide: const BorderSide(
      //                           color: Colors.black, width: .4),
      //                     ),
      //                     focusedErrorBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(12.0),
      //                       borderSide: const BorderSide(
      //                           color: Colors.black, width: .4),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(
      //               width: 8,
      //             ),
      //             Container(
      //               decoration: const BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.all(Radius.circular(10)),
      //               ),
      //               height: 20,
      //               width: 20,
      //               child: Image.asset(
      //                 'assets/images/filter.png',
      //                 height: 8,
      //                 width: 8,
      //                 // fit: BoxFit.contain,
      //               ),
      //             ),
      //             // const SizedBox(
      //             //   width: 8,
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

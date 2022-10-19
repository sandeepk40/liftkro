import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haggle/screens/product_details_screen.dart';
import 'package:haggle/screens/product_list.dart';
import 'package:search_page/search_page.dart';
import 'package:intl/intl.dart';

class Products {
  final String description,
      category,
      // shopName,
      // material,
      productName,
      // sellerType,
      price,
      type;
  final num postedDate;
  final DocumentSnapshot document;
  Products(
      {required this.description,
      required this.category,
      // required this.material,
      required this.postedDate,
      required this.productName,
      // required this.sellerType,
      // required this.shopName,
      required this.price,
      required this.document,
      required this.type});
}

class SearchService {
  search({context, productsList, address, provider, sellerDetails}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
        barTheme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(238, 242, 246,170),
          
        )),
        onQueryUpdate: (s) => print(s),
        items: productsList,
        searchLabel: 'Search by Product/Shop/Brand/Category...',
        suggestion: const SingleChildScrollView(
          child: ProductList(
            proScreen: true,
          ),
        ),
        failure: const Center(
          child: Text('No products found :('),
        ),
        filter: (product) => [
          product.description,
          product.category,
          // product.material,
          // product.sellerType,
          product.productName,
          // product.shopName,
          product.price,
        ],
        builder: (product) {
          final _format = NumberFormat("##,##,##0");
          var _price = int.parse(product.price);
          String _formattedPrice = '₹ ${_format.format(_price)}';

          return InkWell(
            onTap: () {
              provider.getProductDetails(product.document);
              provider.getSellerDetails(sellerDetails);
              Navigator.pushNamed(context, ProductDetailsScreen.id);
            },
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 140,
                        height: 150,
                        child: Image.network(product.document['images'][0]),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                _formattedPrice,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              // Text(
                              //   product.material,
                              //   style: const TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 12,
                              //   ),
                              // ),
                              const SizedBox(
                                height: 5,
                              ),
                              // Text(
                              //   product.sellerType,
                              //   style: const TextStyle(
                              //     color: Colors.black,
                              //     fontSize: 12,
                              //   ),
                              // ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.store_mall_directory_outlined,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  // Text(
                                  //   product.shopName,
                                  //   maxLines: 3,
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontSize: 15,
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Row(
                              //   children: [
                              //     const Icon(
                              //       Icons.location_on,
                              //       size: 15,
                              //     ),
                              //     Flexible(
                              //       child: Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         child: Flexible(
                              //           child: Text(
                              //             address,
                              //             overflow: TextOverflow.ellipsis,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

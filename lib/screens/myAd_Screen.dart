import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/screens/sellItems/seller_category_list.dart';
import 'package:intl/intl.dart';

import '../services/firebase_services.dart';
import '../widgets/product_card.dart';

class MyAddScreen extends StatelessWidget {
  const MyAddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat("##,##,##0");
    print('datatat: ${_service.user!.uid}');
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(238, 242, 246, 170),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(238, 242, 246, 170),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Center(
            child: Text(
              'My Store',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
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
                  'My Store',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Bookmarks',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(238, 242, 246, 170),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: FutureBuilder<QuerySnapshot>(
                  future: _service.products
                      .where('sellerUid', isEqualTo: _service.user!.uid)
                      .orderBy('postedAt')
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No product uploaded yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, SellerCategory.id);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                              ),
                              child: const Text('Add Product',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   height: 56,
                        //   child: const Padding(
                        //     padding: EdgeInsets.all(8.0),
                        //     child: Center(
                        //       child: Text(
                        //         'My uploaded products',
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold, fontSize: 15),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 3.6,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int i) {
                              var data = snapshot.data!.docs[i];
                              var _price = int.parse(data['price']);
                              String _formattedPrice =
                                  '₹ ${_format.format(_price)}';

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
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(238, 242, 246, 170),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _service.products
                      .where('favourites', arrayContains: _service.user!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No bookmarks yet',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const MainScreen()));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                              ),
                              child: const Text(
                                'Add Bookmarks',
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   height: 56,
                        //   child: const Padding(
                        //     padding: EdgeInsets.all(8.0),
                        //     child: Text(
                        //       'Products added to favourites',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold, fontSize: 15),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 3.6,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int i) {
                              var data = snapshot.data!.docs[i];
                              var _price = int.parse(data['price']);
                              String _formattedPrice =
                                  '₹ ${_format.format(_price)}';

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
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:haggle/widgets/product_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key? key, required this.proScreen}) : super(key: key);
  final bool proScreen;

  @override
  Widget build(BuildContext context) {
    print('inside product  list');
    final _format = NumberFormat("##,##,##0");
    final FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Container(
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
                if (proScreen == false)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child:  Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 12, left: 8),
                      child: Text(
                        'New Trends',
                        style: GoogleFonts.lobsterTwo(
                            fontWeight: FontWeight.bold, fontSize: 25,color: Colors.black),
                      ),
                    ),
                  ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2/3.8 ,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                  ),
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
              ],
            );
          },
        ),
      ),
    );
  }
}

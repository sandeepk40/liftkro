import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haggle/forms/seller_Tshirt_form.dart';
import 'package:haggle/forms/seller_jeans_form.dart';
import 'package:haggle/forms/seller_shirt_form.dart';
import 'package:haggle/forms/seller_tracsho_form.dart';
import 'package:haggle/forms/seller_trousers_form.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/screens/sellItems/seller_sub_cat.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_services.dart';

class SellerCategory extends StatelessWidget {
  const SellerCategory({Key? key}) : super(key: key);
  static const String id = 'Seller-category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
        backgroundColor: const Color.fromRGBO(238, 242, 246,170),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Select Product Categories',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories
              .orderBy('sortId', descending: false)
              .get(), // 12th vid 30:32 ...categories.orderby('sortId',descending=false).get...
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var doc = snapshot.data?.docs[index];
                print('list datat: ${doc?['catName']}');
                return Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: ListTile(
                    onTap: () {
                      //sub categories
                      _catProvider.getCategory(doc?['catName']);
                      _catProvider.getCatSnapshot(doc);
                      if (doc?['catName'] == 'Jeans' &&
                          doc?['subCat'] == null) {
                        //doc?['subCat'] == null
                        Navigator.pushNamed(context, SellerJeansForm.id);
                      } else if (doc?['catName'] == 'Shirts' &&
                          doc?['subCat'] == null) {
                        //doc?['subCat'] == null
                        Navigator.pushNamed(context, SellerShirtForm.id);
                      } else if (doc?['catName'] == 'T-Shirts' &&
                          doc?['subCat'] == null) {
                        //doc?['subCat'] == null
                        Navigator.pushNamed(context, SellerTshirtForm.id);
                      } else if (doc?['catName'] == 'Trousers' &&
                          doc?['subCat'] == null) {
                        //doc?['subCat'] == null
                        Navigator.pushNamed(context, SellerTrousersForm.id);
                      } else if (doc?['catName'] == 'Tracksuit/Shorts' &&
                          doc?['subCat'] == null) {
                        //doc?['subCat'] == null
                        Navigator.pushNamed(context, SellerTrackshoForm.id);
                      } else if (doc?['subCat'] != null) {
                        Navigator.pushNamed(context, SellerSubCatList.id,
                            arguments: doc);
                      }
                    },
                    leading: Image.network(
                      doc?['image'],
                      width: 40,
                    ),
                    title: Text(
                      doc?['catName'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    trailing: doc?['subCat'] == null
                        ? null
                        : const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

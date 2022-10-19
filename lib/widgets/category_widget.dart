import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/screens/categories/category_list.dart';
import 'package:haggle/screens/sellItems/product_by_category_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../screens/categories/subCat_screen.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        color: const Color.fromRGBO(238, 242, 246, 170),
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories
              .orderBy('sortId', descending: false)
              .get(), //for custom zort add a sortId field in categories in firebase
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:17),
                          child: Text(
                            'Categories',
                            style:GoogleFonts.satisfy(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // show complete list of categories
                          Navigator.pushNamed(context, CategoryListScreen.id);
                        },
                        child: Row(
                          children: const [
                            Text(
                              'See all',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var doc = snapshot.data?.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          child: InkWell(
                            onTap: () {
                              _catProvider.getCategory(doc?['catName']);
                              _catProvider.getCatSnapshot(doc);
                              if (doc?['subCat'] == null) {
                                _catProvider.getSubCategory(null);
                                Navigator.pushNamed(
                                    context, ProductByCategory.id);
                              } else if (doc?['subCat'] != null) {
                                Navigator.pushNamed(context, SubCatList.id,
                                    arguments: doc);
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 180,
                                  width: 130,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      doc!['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  child: Text(
                                    doc['catName'].toUpperCase(),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

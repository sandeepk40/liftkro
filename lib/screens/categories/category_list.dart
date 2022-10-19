import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/screens/categories/subCat_screen.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_services.dart';
import '../sellItems/product_by_category_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);
  static const String id = 'category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Categories',
          style: GoogleFonts.satisfy(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future:
          _service.categories.orderBy('sortId', descending: false).get(),
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

            return Container(
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data?.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(
                      1.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        //sub categories
                        _catProvider.getCategory(doc?['catName']);
                        _catProvider.getCatSnapshot(doc);
                        if (doc?['subCat'] == null) {
                          _catProvider.getSubCategory(null);
                          Navigator.pushNamed(context, ProductByCategory.id);
                        } else {
                          Navigator.pushNamed(context, SubCatList.id,
                              arguments: doc);
                        }
                      },
                      child: Image.network(
                        doc?['catim'],
                        // width:MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

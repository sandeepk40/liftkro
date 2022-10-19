
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../../forms/forms_screen.dart';
import '../../provider/category_provider.dart';

class SellerSubCatList extends StatelessWidget {
  const SellerSubCatList({Key? key}) : super(key: key);
  static const String id = 'seller_subCat-screen';

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot args =
    ModalRoute.of(context)?.settings.arguments as DocumentSnapshot;
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
        backgroundColor: Color.fromRGBO(238, 242, 246,170),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          args['catName'],
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!['subCat'];
            return Container(
              child: ListView.builder(
                itemCount:_catProvider.doc['subCat'].length,
                itemBuilder: (BuildContext context, int index) {

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: ListTile(
                      onTap: () {
                        _catProvider.getSubCategory(data[index]);
                        Navigator.pushNamed(context, FormsScreen.id);
                      },
                      title: Text(
                        data[index],
                        style: const TextStyle(fontSize: 15),
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

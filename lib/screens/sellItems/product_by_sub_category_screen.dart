import 'package:flutter/material.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/screens/product_list.dart';
import 'package:provider/provider.dart';

class ProductBySubCategory extends StatelessWidget {
  const ProductBySubCategory({Key? key}) : super(key: key);
  static const String id = 'product-by-sub-category';

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(238, 242, 246, 170),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedSubCategory as String,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: const ProductList(proScreen: true),
    );
  }
}

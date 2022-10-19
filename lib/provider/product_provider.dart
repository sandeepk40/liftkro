import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  late DocumentSnapshot productData;
  late DocumentSnapshot sellerDetails;

  getProductDetails(details) {
    this.productData = details;
    notifyListeners();
  }

  getSellerDetails(details) {
    this.sellerDetails = details;
    notifyListeners();
  }
}

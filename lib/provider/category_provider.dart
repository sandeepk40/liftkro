import 'package:flutter/material.dart';
import 'package:haggle/forms/profile_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/services/firebase_services.dart';


class CategoryProvider with ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  late DocumentSnapshot doc;
  late DocumentSnapshot userDetails;
  String? selectedCategory;
  String? selectedSubCategory;
  List<String> urlList = []; //will add urls to this list
  Map<String, dynamic> dataToFirestore =
  {};//this is the data we are going to upload

  getCategory(selectedCat) {
    this.selectedCategory = selectedCat;
    notifyListeners();
  }
  bool isLoading =false;

  getSubCategory(selectedsubCat) {
    this.selectedSubCategory = selectedsubCat;
    notifyListeners();
  }

  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }
  loading(){
    isLoading =true;
    notifyListeners();
  }
  notLoading(){
    isLoading =true;
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore = data;
    notifyListeners();
  }

  getUserDetails(BuildContext context) {
    _service.getUserData().then((value) {
      print('inside user data ${value.data()} ${value.get('address')} ${value.get('shop_name')}');
      if(value.get('address') == '' || value.get('about') == '' || value.get('mobile') == '' || value.get('name')== '' || value.get('shop_name')==""){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileDetailsForm()));
      }
      notifyListeners();
    });
  }
  updateUserDetails({required BuildContext context,
    required String number,
    required shopName,
    required String sellerType,
    required String sellerName,
    required String about,
  }) {
    loading();
    _service.updateUser({
      'name': sellerName,
      'seller_type': sellerType,
      'shop_name': shopName,
      'mobile': number,
      'about': about,
    },context,MainScreen.id);
    notLoading();
  }

  clearData() {
    this.urlList = [];
    this.dataToFirestore = {};
    notifyListeners();
  }

  clearSelectedCat() {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:haggle/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../model/popup_menu_model.dart';
import '../model/product_model.dart';
import '../provider/product_provider.dart';

class FirebaseService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
  FirebaseFirestore.instance.collection('categories');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference messages =
  FirebaseFirestore.instance.collection('messages');

  User? user = FirebaseAuth.instance.currentUser;
  ProductProvider user1 = ProductProvider();

  Future<void> updateUser(Map<String, dynamic> data, context, screen) async {
    return users.doc(user?.uid).update(data).then((value) {
      Navigator.pushNamed(context, screen);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
        ),
      );
    });
  }

  // Future<String?> getAddress(lat, long) async {
  //   //string is used as return to return address
  //   final coordinates = Coordinates(lat, long);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;

  //   return first.addressLine;
  // }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getSellerData(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot> getProductDetails(id) async {
    DocumentSnapshot doc = await products.doc(id).get();
    return doc ;
  }

  // <-- Document ID

  createChatRoom({chatData}) {
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      print(e.toString());
    });
  }

  // final _firestore = FirebaseFirestore.instance;
  //
  // // A simple Future which will return the fetched Product in form of Object.
  // Future getProducts() async {
  //   CollectionReference user = _firestore.collection('products');
  //   print('indeddd: ${user}');
  //   final querySnapshot = await _firestore.collection('products').get();
  //   final datat = querySnapshot;
  //   final products = querySnapshot.docs.map((e) {
  //     // Now here is where the magic happens.
  //     // We transform the data in to Product object.
  //     final model = e.reference.id;
  //     // Setting the id value of the product object.
  //     // model = e.id;
  //     print('product id12: $model');
  //     return model;
  //   }).toList();
  //   print('datatt: ${products[products.length-1]}');
  //   return products;
  // }
  createChat(String chatRoomId, message) {
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e) {
      print(e.toString());
    });

    messages.doc(chatRoomId).update({
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'read': false,
    });
  }

  getChat(chatRoomId) async {
    return messages
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  deleteChat(chatRoomId) async {
    return messages.doc(chatRoomId).delete();
  }

  updateFavourite(likCount,_isliked, productId, context) {
    print('totalLike: $likCount $_isliked');
    var likeData = [{'totalLike': likCount, 'isLike' : _isliked,}];
    products.doc(productId).update({
      'likeCount':likeData
      // FieldValue.arrayUnion(_isliked)
    });
    // if(_isliked) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Add Favourites Successfully !!',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: Colors.green,
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Removed Favourites Successfully !!',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       behavior: SnackBarBehavior.floating,
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  updateRating(ratingCount, productId, context) {
    // var addedRating = List.from(ratingCount)
    //    ..addAll(previousRating);
    products.doc(productId).update({
      'ratingCount': ratingCount,
      // FieldValue.arrayUnion(_isliked)
    });
  }
  updateReview(review, productId, userName,previous, ratingCount,uid, context) {
    print('indied ratting');
    var reviewData = [{
      "review" : review,
      "userName": userName,
      'postedDate': DateTime.now().toIso8601String(),
      'rating': ratingCount,
      'uid' : uid
    }];
    var addedRating = List.from(reviewData)
      ..addAll(previous);
    products.doc(productId).update({
      'ratting': addedRating
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Review Submitted Successfully !!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  updateNewReview(review, productId, userName, ratingCount,uid, context) {
    print('indied ratting : }');
    var ddd = [];
    var reviewData = [{
      "review" : review,
      "userName": userName,
      'postedDate': DateTime.now().toIso8601String(),
      'rating': ratingCount,
      'uid' : uid
    }];
    var query = FirebaseFirestore.instance.collection('products').where('uid', isEqualTo: uid).get();
    print('dattttt: ${query.toString()}');

    // var query =  products.doc(productId).where
    //     .where(uid, isEqualTo: valueForWhere)
    //     .getDocuments();

    // products.doc(productId).update({
    //   'review' : FieldValue.arrayUnion([
    //     {}
    //   ])
    products.doc(productId).collection('ratting').doc(uid).get().then((value) => {
      print('ddajkljl ${value['ratting']}')

    });

    // products.doc(productId).collection('ratting').doc(uid).update({
    //   "review" : review,
    //   "userName": userName,
    //   'postedDate': DateTime.now().toIso8601String(),
    //   'rating': ratingCount,
    //   'uid' : uid
    // });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Review Submitted Successfully !!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  updateReviewForSeller({sellerId, userName, previous, ratingCount, context}) {
    print('insde: review: $sellerId $userName $ratingCount');
    var reviewData = [{
      "userName": userName,
      'postedDate': DateTime.now().toIso8601String(),
      'rating': ratingCount
    }];
    var addedRating = List.from(reviewData)
      ..addAll(previous);
    users.doc(sellerId).update({
      'ratting': addedRating
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Thank you for Submitting Rating !!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  updateProductReport(review, productId, userId,previous, context) {
    var reportData = [{
      "reportContent" : review,
      "userId": userId,
      'postedDate': DateTime.now().toIso8601String(),
    }];
    var addedRating = List.from(reportData)
      ..addAll(previous);
    products.doc(productId).update({
      'reportProduct': addedRating
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Report Submitted Successfully !!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  uploadProfile(image, uid, context) {
    print('insde: review: $image $uid');
    users.doc(uid).update({
      'profile': image,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile Image Uploaded Successfully !!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  rattingRemoe(index, productId, context) {
    print('insde: review: $index $productId');
    products.doc(productId).update({
      // 'ratting': FieldValue.arrayRemove(elements)[index])
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Review Deleted Successfully !!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  popUpMenue(chatData, context) {
    final CustomPopupMenuController _controller = CustomPopupMenuController();
    List<PopupMenuModel> menuItems = [
      PopupMenuModel('Delete', Icons.delete),

    ];
    return CustomPopupMenu(
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: const Color.fromRGBO(238, 242, 246,170),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (item.title == 'Delete') {
                      deleteChat(chatData['chatRoomId']);
                      _controller.hideMenu();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('Chat deleted'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 15,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding:
                            const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      controller: _controller,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: const Icon(
            Icons.more_vert,
            color: Colors.black
        ),
      ),
    );
  }
}

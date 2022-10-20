import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserReviewScreen extends StatefulWidget {
  const UserReviewScreen({Key? key}) : super(key: key);
  static const String id = 'user-review-screen';

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final FirebaseService _service = FirebaseService();

  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _shopnNameController = TextEditingController();

  Future<void> updateUser(provider, Map<String, dynamic> data, context) async {
    // var previousId = _service.users.doc(_service.user.)
    return _service.users.doc(_service.user!.uid).update(data).then((value) {
      _service.getUserData().then((value) => {
        print('datattt: ${value['productId']}'),
        saveProductsToDB(provider, value['productId'], context),
      });
    }).catchError((error) {
      print('errordata: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Future<void> saveProductsToDB(CategoryProvider provider,previousProductId, context) async {
    var document = FirebaseFirestore.instance
        .collection('products')
        .doc();
    var product = [document.id];
    var addedProductId = List.from(product)
      ..addAll(previousProductId);
    _service.users.doc(_service.user!.uid).update({
      'productId':addedProductId
    });
    document.set({
      'productId' : document.id,
      'category': provider.selectedCategory,
      'color': provider.dataToFirestore['color'],
      'description': provider.dataToFirestore['description'],
      'favourites':0,
      'images': provider.dataToFirestore['images'], //should be a list
      'likeCount':[{'totalLike': 0, 'isLike' : false,}],
      'material':provider.dataToFirestore['material'],
      'minQty': provider.dataToFirestore['minQty'],
      'postedAt': DateTime.now().microsecondsSinceEpoch,
      'price': provider.dataToFirestore['price'],
      'productName': provider.dataToFirestore['productName'],
      'ratting':[],
      'reportProduct': [],
      'sellerUid': _service.user?.uid,
      'size':provider.dataToFirestore['size'],
      'type':provider.dataToFirestore['type'],
      'ratingCount':0,
    });

    // print('reviewdata: ${document}');
    // _service.products.add(provider.dataToFirestore).then((value) {
    //   provider.clearData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'We have received your products and will be notified once you approved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MainScreen()),
    // );
    // .catchError((error) {
    // print('errr: $error');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Failed to update location'),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );
    // });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    print('provider data: ${_provider.dataToFirestore}');
    showConfirmDialog() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONFIRM YOUR PRODUCT DETAILS',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Are you sure, You want to save the product?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Image.network(_provider.dataToFirestore['images'].toString().replaceAll('[', '').toString().replaceAll(']', '')),
                    title: Text(
                      _provider.dataToFirestore['description'],
                      maxLines: 1,
                    ),
                    subtitle: Text('₹${_provider.dataToFirestore['price']}'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NeumorphicButton(
                        onPressed: () {
                          setState(() {
                            _loading = false;
                          });
                          Navigator.pop(context);
                        },
                        style: const NeumorphicStyle(
                          border: NeumorphicBorder(color: Colors.black),
                          color: Colors.transparent,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      NeumorphicButton(
                        style: NeumorphicStyle(
                          color: Color.fromRGBO(238, 242, 246, 170),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          updateUser(
                              _provider,
                              {
                                'contactDetails': {
                                  'phone': _phoneController.text,
                                  'email': _emailController.text,
                                },
                                'name': _nameController.text,
                                'mobile': _phoneController.text,
                                'shop_name': _shopnNameController.text,
                                'address':_addressController.text,
                                'email': _emailController.text,

                              },
                              context)
                              .then(
                                (value) {
                              setState(() {
                                _loading = false;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 242, 246, 170),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 100, 40, 0)),
        elevation: 0,
        title: const Text(
          'Review your details',
          style: TextStyle(color: Colors.black),
        ),
       
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.getUserData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Something went wrong",
              );
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            }
            _nameController.text = snapshot.data?['name'] ?? "";
            _phoneController.text = snapshot.data?['mobile'] ?? "";
            _emailController.text = snapshot.data?['email'] ?? "";
            _addressController.text = snapshot.data?['address'] ?? "";
            _shopnNameController.text = snapshot.data?['shop_name'] ?? "";

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black54,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.person_alt,
                              color: Colors.grey,
                              size: 60,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10, //10 to 12
                        ),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your Name',
                              labelStyle: const TextStyle(color: Colors.black),
                              helperStyle: const TextStyle(color: Colors.black),
                              errorStyle: const TextStyle(color: Colors.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Contact Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number*  ',
                        counter: const Offstage(),
                        labelStyle: const TextStyle(color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        errorStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                      ),
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Email*',
                        labelStyle: const TextStyle(color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        errorStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                      ),
                      validator: (value) {
                        final bool isValid =
                        EmailValidator.validate(_emailController.text);
                        if (value == null || value.isEmpty) {
                          return "Enter Email";
                        }
                        if (value.isNotEmpty && isValid == false) {
                          return 'Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _addressController,
                            cursorColor: Colors.black,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Address*',
                              labelStyle: const TextStyle(color: Colors.black),
                              helperStyle: const TextStyle(color: Colors.black),
                              errorStyle: const TextStyle(color: Colors.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .4),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please complete required field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _shopnNameController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Shop Name*',
                        labelStyle: const TextStyle(color: Colors.black),
                        helperStyle: const TextStyle(color: Colors.black),
                        errorStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          const BorderSide(color: Colors.black, width: .4),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style:
                NeumorphicStyle(color: Color.fromRGBO(238, 242, 246, 170)),
                child: const Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showConfirmDialog();
                  }
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text(
                  //       'Enter required fields',
                  //     ),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

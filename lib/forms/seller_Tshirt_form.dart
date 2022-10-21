import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:haggle/forms/user_review_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../provider/category_provider.dart';
import '../widgets/imagePicker_widget.dart';

class SellerTshirtForm extends StatefulWidget {
  const SellerTshirtForm({Key? key}) : super(key: key);
  static const String id = 'tshirt-form';

  @override
  State<SellerTshirtForm> createState() => _SellerTshirtFormState();
}

class _SellerTshirtFormState extends State<SellerTshirtForm> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseService _service = FirebaseService();

  final _sizeController = TextEditingController();
  final _materialController = TextEditingController();
  final _minQtyController = TextEditingController();
  final _colorController = TextEditingController();
  final _priceController = TextEditingController();
  final _desController = TextEditingController();
  final _brandController = TextEditingController();
  final _typeController = TextEditingController();
  var productID = "";
  List<File> previewImageVideo = [];
  late File imageFile;
  var productImageList = [];
  bool isLoading = false;
  var _index = 0;

  validate(CategoryProvider provider)async {
    // if (_formKey.currentState!.validate()) {
    //if all the fields are filled
    //and if
    //should have an image
    final _firestore = FirebaseFirestore.instance;
    // var document = FirebaseFirestore.instance
    //     .collection('products')
    //     .doc();
    // print('datasandeep: ${document.id}');
    // DocumentReference docref = await _firestore.collection('products').add(map)
    provider.dataToFirestore.addAll({
      'productId' : "",
      'category': provider.selectedCategory,
      'productName': _brandController.text,
      'size': _sizeController.text,
      'type':_typeController.text,
      'material': _materialController.text,
      'minQty': _minQtyController.text,
      'color': _colorController.text,
      'price': _priceController.text,
      'description': _desController.text,
      'sellerUid': _service.user?.uid,
      'images': productImageList, //should be a list
      'postedAt': DateTime.now().microsecondsSinceEpoch,
      'favourites':[],
    });
    //once saved all data to provider,we need to check user contact details again
    //to confirm all the details are there ,so we need to goo to profile screen
    // print("provider.dataToFirestore ${document}");
    // provider.dataToFirestore.addAll({
    // });
    setState(() {
      isLoading = false;
    });
    Navigator.pushNamed(context, UserReviewScreen.id);
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Image not uploaded'),
    //     ),
    //   );
    // }
  }

  final _firestore = FirebaseFirestore.instance;

  Future getProducts() async {
    print('indeddd:');
    // final doc_ref= await _firestore.collection("board").get();
    // var doc_id2 = doc_ref.;
    final querySnapshot = await _firestore.collection('products').get();
    // final datat = querySnapshot.;
    final products = querySnapshot.docs.map((e) {
      // Now here is where the magic happens.
      // We transform the data in to Product object.
      final model = e.reference.id;
      // Setting the id value of the product object.
      // model = e.id;
      print('product id12: $model');
      return model;
    }).toList();
    productID = products[products.length-1];
    print('datatt: ${products[products.length-1]}');
    return products;
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 242, 246,170),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: Text(
                  '${_catProvider.selectedCategory}',
                  style: const TextStyle(
                   
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
     
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Container(
              child: Column(
               
                children: [
                 
                  TextFormField(
                    controller: _typeController,
                    cursorColor: Colors.black,
                    decoration:  InputDecoration(
                      // labelText: 'Tap here to add jeans type'),
                      labelText: 'Type*',
                      helperText: 'Tshirt/Crew-Neck/Sleeveless/V-Neck/Y-Neck...',
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _brandController, //_brandController
                    cursorColor: Colors.black,
                    decoration:  InputDecoration(
                      //labelText: 'Tap here to add jeans type'),
                      labelText: 'Brand*',
                      helperText: 'Arrow/Jack & Jones/Nike/Pepe',
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),const SizedBox(height: 20),
                  TextFormField(
                    controller: _materialController, //_brandController
                    cursorColor: Colors.black,
                    //enabled: false,
                    decoration:  InputDecoration(
                      //labelText: 'Tap here to add jeans type'),
                      labelText: 'Material*',
                      helperText: 'Cotton/Polyeter/Poly-Cotton/Linn...',
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),const SizedBox(height: 20),
                  TextFormField(
                    controller: _colorController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Color*',
                      helperText: ('Blue/Red/Green...'),
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),const SizedBox(height: 20),
                  TextFormField(
                    controller: _sizeController,
                    cursorColor: Colors.black,
                    decoration:  InputDecoration(
                      labelText: 'Size*',
                      helperText: ('S/M/L/XL/XXL...'),
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),const SizedBox(height: 20),
                  TextFormField(
                    controller: _minQtyController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      labelText: 'Min Qty*',
                      helperText: ('One/Two/Three...'),
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      prefixText: 'Rs-',
                      labelText: 'Price*',
                      helperText: ('Rs-499/999/1999...'),
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _desController,
                    cursorColor: Colors.black,
                    maxLength: 4000,
                    minLines: 1,
                    maxLines: 30,
                    decoration:  InputDecoration(
                      labelText: 'Description*',
                      helperText: ('Color/Material/Shape/...'),
                      labelStyle: const TextStyle(color: Colors.black),
                      helperStyle: const TextStyle(color: Colors.black),
                      errorStyle: const TextStyle(color: Colors.red),
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
                        const BorderSide(color: Colors.red, width: .4),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                        const BorderSide(color: Colors.black, width: .4),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      if (value.length < 10) {
                        return 'Need atleast 10 characters';
                      }
                      return null;
                    },
                  ),
                  //address was here now in user review screen

                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     color: Colors.orange[50],
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: _catProvider.urlList.isEmpty
                  //       ? const Padding(
                  //           padding: EdgeInsets.all(10.0),
                  //           child: Text(
                  //             'No Image selected',
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         )
                  //       : GalleryImage(
                  //           imageUrls: _catProvider.urlList,
                  //           numOfShowImages: _catProvider.urlList.length,
                  //         ),
                  // ),
                  SizedBox(height: 10,),
                  previewImageVideo.isNotEmpty ? Container(
                    height: 600,
                    child: Stack(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                child: PhotoView(
                                  backgroundDecoration: const BoxDecoration(
                                    // color: Colors.white,
                                  ),
                                  imageProvider:
                                  FileImage(
                                      previewImageVideo[_index]),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        previewImageVideo
                                            .removeAt(_index);
                                      });
                                    },
                                    icon: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.white70,
                                          ),
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.black,
                                          ),
                                        ),),
                              ),

                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: previewImageVideo.length,
                                itemBuilder:
                                    (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _index = i;
                                      });
                                    },
                                    child: Container(
                                      height: 70,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black38,
                                          ),
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Image.file(previewImageVideo[i]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),
                 
                  const SizedBox(
                    height: 80,
                  ),
                  
                ], // Video 13 31:20 fuel controller
              ),
            ),
          ),
        ),
      ),
      // bottomSheet: Row(
      //   children: [
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: NeumorphicButton(
      //           style: const NeumorphicStyle(
      //             color: Color.fromRGBO(238, 242, 246,170),
      //           ),
      //           child: const Padding(
      //             padding: EdgeInsets.all(4.0),
      //             child: Text(
      //               'Next',
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 color: Colors.black,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //           onPressed: () {
      //             validate(_catProvider);
      //             print(_catProvider.dataToFirestore);
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
       bottomSheet: BottomAppBar(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                    style: const NeumorphicStyle(
                      color: Colors.white,
                      border: NeumorphicBorder(
                        isEnabled: true,
                        color: Colors.black,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Add Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      getImage(true, previewImageVideo.length);
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: NeumorphicButton(
                    style: const NeumorphicStyle(
                      color: Colors.white,
                      border: NeumorphicBorder(
                        isEnabled: true,
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Next',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() == true &&
                          previewImageVideo.isNotEmpty) {
                        uploadFile().then((value) => {
                              setState(
                                () {
                                  productImageList = value;
                                },
                              ),
                              validate(_catProvider),
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please complete required fields'),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }

                      // validate(_catProvider);
                      // print(_catProvider.dataToFirestore);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future getImage(bool isgallery, index) async {
    PickedFile? galleryFile;
    if (isgallery) {
      try {
        galleryFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
        );
        if (galleryFile != null && galleryFile.path.length > 0) {
          try {
            imageFile = new File(galleryFile.path);
            setState(() {
              previewImageVideo.add(imageFile);
              setState(() {});
            });
          } finally {}
        }
      } catch (e) {
        print(e);
      }
    }
  }
  Future uploadFile() async {
    var getImageList = [];
    for (var i = 0; i < previewImageVideo.length; i++) {
      File file = File(previewImageVideo[i].path);
      String imageName = 'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String? downloadUrl;
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
        await FirebaseStorage.instance.ref(imageName).getDownloadURL();
      } catch (e, s) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Failed to upload image',
            ),
          ),
        );
        print('Upload canceled error: $e\nStackTrace: $s');
      } finally {
      }
      setState(() {
        getImageList.add(downloadUrl);
      });
    }
    return getImageList;
  }
}

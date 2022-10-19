import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as imageLib;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart' as path;
import 'package:galleryimage/galleryimage.dart';
import 'package:haggle/forms/user_review_screen.dart';
import 'package:haggle/screens/home_screen.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../provider/product_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/imagePicker_widget.dart';

class EditProductDetails extends StatefulWidget {
  EditProductDetails({Key? key, this.productId}) : super(key: key);
  static const String id = 'edit-product';
  String? productId;

  @override
  State<EditProductDetails> createState() => _EditProductDetailsState();
}

class _EditProductDetailsState extends State<EditProductDetails> {
  final _form1Key = GlobalKey<FormState>();
  CategoryProvider? categoryProvider;
  final FirebaseService _service = FirebaseService();
  FirebaseStorage storage = FirebaseStorage.instance;
  final _format = NumberFormat("##,##,##0");
  final auth = FirebaseAuth.instance;
  List<File> previewImageVideo = [];
  var dataCat;
  late File imageFile;
  late File finalFile;
  var prouctImage = [];
  bool isLoading = false;
  var fileName;

  final _sizeController = TextEditingController();
  final _materialController = TextEditingController();
  final _minQtyController = TextEditingController();
  final _colorController = TextEditingController();
  final _priceController = TextEditingController();
  final _desController = TextEditingController();
  final _titleController = TextEditingController();
  final _sellerTypeController = TextEditingController();
  final _sellerNamecontroller = TextEditingController();
  final _typeController = TextEditingController();
  var productId = '';
  int _index1 = 0;
  int _index = 0;
  var _productProvider;
  var doc;
  var getImageData = [];
  var getLikeCount;
  var ratting;
  var reportProduct;
  var postedDate;

  validate(CategoryProvider provider, String id) {
    provider.dataToFirestore.addAll({
      'productId': productId,
      'category': _sellerTypeController.text,
      'color': _colorController.text,
      'description': _desController.text,
      'favourites': 0,
      'images': prouctImage, //should be a list
      'likeCount': getLikeCount,
      'material': _materialController.text,
      'minQty': _minQtyController.text,
      'postedAt': postedDate,
      'updatedDate': DateTime.now().microsecondsSinceEpoch,
      'price': _priceController.text,
      'productName': _titleController.text,
      'ratting': ratting,
      'reportProduct': reportProduct,
      'sellerUid': _service.user?.uid,
      'size': _sizeController.text,
      'type': _typeController.text,
    });
    print(
        "categoryProvider?.dataToFirestore ${categoryProvider?.dataToFirestore}");
    updateDetails(provider, context, id);
    // Navigator.pushNamed(context, MainScreen.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your product details has been updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {
      isLoading = false;
    });
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please complete required fields'),
    //     ),
    //   );
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<void> updateDetails(
      CategoryProvider provider, context, String id) async {
    return _service.products
        .doc(id)
        .update(provider.dataToFirestore)
        .then((value) {})
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  void initState() {
    getDatat(widget.productId);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    print('product id: ${widget.productId}');
    super.initState();
  }

  getDatat(var proId) {
    _service.getProductDetails(proId).then((value) => {
          if (value.data() != null)
            {
              setState(() {
                doc = value;
                print('va;idd: ${value.data()}');
                _sizeController.text = doc['size'];
                // _materialController.text = data['fabric'];
                _minQtyController.text = doc['minQty'];
                _colorController.text = doc['color'];
                _priceController.text = doc['price'];
                _desController.text = doc['description'];
                _titleController.text = doc['productName'];
                _typeController.text = doc['type'];
                _materialController.text = doc['material'];
                getImageData = doc['images'];
                productId = doc['productId'];
                getLikeCount = doc['likeCount'];
                ratting = doc['ratting'];
                reportProduct = doc['reportProduct'];
                postedDate = doc['postedAt'];
              }),
              print('getproductDetial: ${doc.data()}')
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    _productProvider = Provider.of<ProductProvider>(context);
    var data = _productProvider.productData;
    // var _price = int.parse(data['price']);
    var sallerName = _productProvider.sellerDetails['name'];
    _sellerTypeController.text = data['category'].toString();

    // String price = _format.format(_price);
    //should be a list
    _sellerNamecontroller.text = sallerName;
    return doc != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              elevation: 0.0,
              title: const Text(
                'Edit product details',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              shape: Border(
                bottom: BorderSide(color: Colors.orange.shade50),
              ),
            ),
            body: Form(
              key: _form1Key,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 100,
                    //   child: ListView.builder(
                    //       padding: const EdgeInsets.symmetric(horizontal: 8),
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: data['images'].length,
                    //       itemBuilder: (BuildContext context, index) {
                    //         var image = data['images'][index];
                    //         return Center(
                    //           child: Container(
                    //             height: double.maxFinite,
                    //             width: 80,
                    //             child: Stack(
                    //               children: [
                    //                 Image.network(
                    //                   image,
                    //                   height: 100,
                    //                   width: 80,
                    //                 ),
                    //                 InkWell(
                    //                   onTap: () async {
                    //                     String fileName = data['images'][index]
                    //                         .replaceAll("/o/", "*");
                    //                     fileName = fileName.replaceAll("?", "*");
                    //                     fileName = fileName.split("*")[1];
                    //                     FirebaseStorage.instance
                    //                         .refFromURL(image)
                    //                         .delete()
                    //                         .then((value) {
                    //                       ScaffoldMessenger.of(context)
                    //                           .showSnackBar(SnackBar(
                    //                         content: Text(
                    //                             'Successfully deleted $fileName storage item'),
                    //                         behavior: SnackBarBehavior.floating,
                    //                       ));
                    //                       setState(() {});
                    //                     });
                    //                     print('data inse: ${fileName}');
                    //
                    //                     // print('data ${data['images'][index]}');
                    //                     // String fileName = data['images'][index].replaceAll("/o/", "*");
                    //                     // fileName = fileName.replaceAll("?", "*");
                    //                     // fileName = fileName.split("*")[1];
                    //                     // print(fileName);
                    //                     // StorageReference storageReferance = FirebaseStorage.instance.ref();
                    //                     // storageReferance
                    //                     //     .child(fileName)
                    //                     //     .delete()
                    //                     //     .then((_) => print('Successfully deleted $fileName storage item'));
                    //                     //  FirebaseStorage.instance.ref().child(data['images'][index]).delete().then((_) => print('Successfully deleted storage item' ));
                    //                   },
                    //                   child: const Align(
                    //                       alignment: Alignment.topRight,
                    //                       child: Icon(
                    //                         Icons.cancel,
                    //                         color: Colors.black,
                    //                       )),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    // ),
                    Container(
                      height: 500,
                      child: Stack(
                        children: [
                          Center(
                            child: PhotoView(
                              backgroundDecoration: const BoxDecoration(
                                  // color: Colors.white,
                                  ),
                              imageProvider:
                                  NetworkImage(getImageData[_index1]),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 12),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: getImageData.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index1 = i;
                                        });
                                      },
                                      child: Container(
                                        height: 70,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Image.network(getImageData[i]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            // top: 2,
                            child: IconButton(
                              onPressed: () {
                                if (getImageData.length != 1 &&
                                    getImageData.last !=
                                        getImageData[_index1]) {
                                  setState(() {
                                    getImageData.removeAt(_index1);
                                  });
                                  // if(previewImageVideo.isNotEmpty) {
                                  //   showAlertDialog(data,context);
                                  //  }else{
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //       const SnackBar(
                                  //         content: Text(
                                  //           "Sorry please add at-least one image !!",
                                  //           style: TextStyle(color: Colors.white),
                                  //         ),
                                  //         behavior: SnackBarBehavior.floating,
                                  //         backgroundColor: Colors.red,
                                  //       ));
                                  // }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Sorry you can select all product image for delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white70,
                                ),
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 100,
                    //   width: double.infinity,
                    //   child: ListView.builder(
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: data['images'].length,
                    //       itemBuilder: (BuildContext context, index) {
                    //         return Center(
                    //           child: Container(
                    //             width: 80,
                    //             padding: EdgeInsets.only(left: 3, right: 3),
                    //             child: Stack(
                    //               children: [
                    //                 Image.network(
                    //                   data['images'][index],
                    //                   height: 80,
                    //                   width: 80,
                    //                   fit: BoxFit.fill,
                    //                 ),
                    //                 InkWell(
                    //                   onTap: () async {
                    //                     String fileName = data['images'][index]
                    //                         .replaceAll("/o/", "*");
                    //                     fileName = fileName.replaceAll("?", "*");
                    //                     fileName = fileName.split("*")[1];
                    //                     FirebaseStorage.instance
                    //                         .refFromURL(data['images'][index])
                    //                         .delete()
                    //                         .then((value) {
                    //                       ScaffoldMessenger.of(context)
                    //                           .showSnackBar(SnackBar(
                    //                         content: Text(
                    //                             'Successfully deleted $fileName storage item'),
                    //                         behavior: SnackBarBehavior.floating,
                    //                       ));
                    //                       setState(() {});
                    //                     });
                    //                     print('data inse: ${fileName}');
                    //                     },
                    //                   child: const Align(
                    //                       alignment: Alignment.topRight,
                    //                       child: Icon(
                    //                         Icons.cancel,
                    //                         color: Colors.black,
                    //                       )),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    // ),
                    // SizedBox(height: 10,),
                    // Container(
                    //   height: 150,
                    //   child: StaggeredGridView.countBuilder(
                    //     crossAxisCount: 2,
                    //     itemCount: previewImageVideo.length + 1,
                    //     itemBuilder: (BuildContext context, index) {
                    //       return index == previewImageVideo.length
                    //           ? GestureDetector(
                    //               onTap: () {
                    //                 getImage(true, previewImageVideo.length);
                    //               },
                    //               child: Container(
                    //                 child: DottedBorder(
                    //                   color: Colors.grey,
                    //                   strokeWidth: 1,
                    //                   radius: Radius.circular(8),
                    //                   dashPattern: [8, 10],
                    //                   child: ClipRRect(
                    //                     child: Container(
                    //                       width: double.infinity,
                    //                       height: double.infinity,
                    //                       child: Icon(
                    //                         Icons.add,
                    //                         color: Colors.grey,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //           : InkWell(
                    //               child: Stack(
                    //                 children: [
                    //                   Container(
                    //                     decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                         color: Colors.white,
                    //                         image: DecorationImage(
                    //                             image: FileImage(
                    //                                 previewImageVideo[index]),
                    //                             fit: BoxFit.fill)),
                    //                   ),
                    //                   Positioned(
                    //                       bottom: 35,
                    //                       left: 35,
                    //                       child: IconButton(
                    //                           onPressed: () {
                    //                             setState(() {
                    //                               previewImageVideo
                    //                                   .removeAt(index);
                    //                             });
                    //                           },
                    //                           icon: Icon(
                    //                             Icons.cancel,
                    //                             color: Colors.black,
                    //                           )))
                    //                 ],
                    //               ),
                    //             );
                    //     },
                    //     staggeredTileBuilder: (int index) =>
                    //         new StaggeredTile.count(1, 1),
                    //     mainAxisSpacing: 3,
                    //     crossAxisSpacing: 3,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     print('product image: $isLoading');
                    //     uploadFile().then((value) => setState(() {
                    //       var previewData = data['images'];
                    //       prouctImage = List.from(value)..addAll(previewData);
                    //           // prouctImage.add(value.toString().replaceAll('[', '').toString().replaceAll(']', ''));
                    //         }));
                    //     // upoad images would be done
                    //     // showDialog(
                    //     //     context: context,
                    //     //     builder: (BuildContext context) {
                    //     //       return const ImagePickerWidget();
                    //     //     });
                    //     print('add lsit: $prouctImage');
                    //     print('previous: ${data['images']}');
                    //   },
                    //   child: Neumorphic(
                    //     style: NeumorphicStyle(
                    //       color: Colors.green[50],
                    //       border: NeumorphicBorder(
                    //         color: Colors.purple[100],
                    //       ),
                    //     ),
                    //     child: Container(
                    //       height: 40,
                    //       child: Center(
                    //         child: Center(
                    //           child: isLoading
                    //               ? Center(
                    //                   child: CircularProgressIndicator(
                    //                     color: Colors.orange,
                    //                   ),
                    //                 )
                    //               : Text(
                    //                   // categoryProvider!.urlList.isNotEmpty
                    //                   //     ? 'Upload more Images'
                    //                   //     :
                    //                   'Upload Image ',
                    //                   style: const TextStyle(color: Colors.black),
                    //                 ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //
                    // Divider(
                    //   height: 10,
                    //   thickness: 1,
                    //   indent: 100,
                    //   endIndent: 100,
                    //   color: Colors.green[200],
                    // ),
                    // TextFormField(
                    //   controller: _sellerTypeController, //_brandController
                    //   enabled: true,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Seller Type',
                    //   ),
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please complete required field';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         data['category'] ?? "Category Name",
                    //         style:  TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 14,
                    //           color: Colors.grey[200],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(height: 30),
                    // Row(
                    //   children: [],
                    // ),
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Product Details',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.book_outlined,
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _typeController,
                              decoration: InputDecoration(
                                // labelText: 'Tap here to add jeans type'),
                                labelText: 'Type*',
                                helperText: 'Jeans/Slimfit/Narrow/Regular...',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller:
                                  _sellerNamecontroller, //_brandController
                              // enabled: false,

                              decoration: InputDecoration(
                                //labelText: 'Tap here to add jeans type'),
                                labelText: 'Seller Name*',
                                helperText: 'Your Name',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _titleController, //_brandController

                              decoration: InputDecoration(
                                //labelText: 'Tap here to add jeans type'),
                                labelText: 'Brand*',
                                helperText: 'Wrangler/Levis/Diesel...',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _materialController,
                              decoration: InputDecoration(
                                //labelText: 'Tap here to add jeans type'),
                                labelText: 'Material*',
                                helperText: 'Cotton/Denim/Linen,...',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _colorController,
                              decoration: InputDecoration(
                                labelText: 'Color*',
                                helperText: ('Blue/Black/Brown/Multicolor,...'),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _sizeController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Size*',
                                helperText: ('(22-33)'),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _minQtyController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min Qty*',
                                helperText: ('eg.12/24...'),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: 'Rs-',
                                labelText: 'Price*',
                                helperText: ('499/999/1999,...'),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _desController,
                              maxLength: 4000,
                              minLines: 1,
                              maxLines: 30,
                              decoration: InputDecoration(
                                labelText: 'Description*',
                                helperText: ('Brand/Fit/Style and details'),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                helperStyle:
                                    const TextStyle(color: Colors.black),
                                errorStyle: const TextStyle(color: Colors.red),
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
                                      color: Colors.red, width: .4),
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
                                if (value.length < 10) {
                                  return 'Need atleast 10 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    previewImageVideo.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(bottom: 30,),
                          child: Container(
                              height: 500,
                              child: Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        child: PhotoView(
                                          backgroundDecoration:
                                              const BoxDecoration(
                                                  // color: Colors.white,
                                                  ),
                                          imageProvider: FileImage(
                                              previewImageVideo[_index]),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              previewImageVideo.removeAt(_index);
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
                                          ),
                                        ),
                                      ),
                                    ],
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
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                ),
                                                child: Image.file(
                                                  previewImageVideo[i],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        )
                        : Container(),
                    const SizedBox(
                      height: 60,
                    ),
                  ], // Video 13 31:20 fuel controller
                ),
              ),
            ),
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
                              color: Colors.black45,
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
                            getImage(true);
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
                              color: Colors.black45,
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
                                    'Update product',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (_form1Key.currentState!.validate() == true) {
                              uploadFile().then((value) => {
                                    setState(() {
                                      // var previewData = data['images'];
                                      print('uploaded image: $getImageData');
                                      prouctImage = List.from(value)
                                        ..addAll(getImageData);
                                      print('image data: $prouctImage');
                                    }),
                                    validate(categoryProvider!, doc.id),
                                  });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please complete required fields'),
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )),
          );
  }

  Future getImage(bool isgallery) async {
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

  //upload to firebase
  Future uploadFile() async {
    var getImageList = [];
    for (var i = 0; i < previewImageVideo.length; i++) {
      File file = File(previewImageVideo[i].path);
      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String? downloadUrl;
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if (downloadUrl != null) {
          setState(() {});
        }
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
        setState(() {
          previewImageVideo.clear();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     behavior: SnackBarBehavior.floating,
          //     content: Text(
          //       'Image Uploaded Successfully !',
          //     ),
          //   ),
          // );
        });
      }
      print('datatt: $downloadUrl');
      setState(() {
        getImageList.add(downloadUrl);
        // isLoading = false;
      });
      // return downloadUrl;
    }
    print('filedat: $getImageList');
    return getImageList;
  }

  showAlertDialog(var data, BuildContext context) {
    print('datat: ${data['productId']}');
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget delete = TextButton(
      child: const Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content:
          const Text("You wish to delete all images of this current product"),
      actions: [
        okButton,
        delete,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

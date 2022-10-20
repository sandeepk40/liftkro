import 'dart:io';

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

class FormsScreen extends StatefulWidget {
  const FormsScreen({Key? key}) : super(key: key);
  static const String id = 'form-screen';

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
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
  List<File> previewImageVideo = [];
  late File imageFile;
  var productImageList = [];
  bool isLoading = false;
  var _index = 0;

  validate(CategoryProvider provider) {
    // if (_formKey.currentState!.validate()) {
    //if all the fields are filled
    //and if
    // if (provider.urlList.isNotEmpty) {
    //should have an image
    provider.dataToFirestore.addAll({
      'category': provider.selectedCategory,
      'productName': _brandController.text,
      'type': _typeController.text,
      'subCat': provider.selectedSubCategory,
      'size': _sizeController.text,
      'material': _materialController.text,
      'minQty': _minQtyController.text,
      'color': _colorController.text,
      'price': _priceController.text,
      'description': _desController.text,
      'sellerUid': _service.user?.uid,
      'images': productImageList, //should be a list
      'postedAt': DateTime.now().microsecondsSinceEpoch,
      'favourites': [],
    });
    //once saved all data to provider,we need to check user contact details again
    //to confirm all the details are there ,so we need to goo to profile screen
    // print(provider.dataToFirestore);
    setState(() {
      isLoading = false;
    });
    Navigator.pushNamed(context, UserReviewScreen.id);
  }
  //   else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please complete required fields'),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
                  '${_catProvider.selectedCategory} > ${_catProvider.selectedSubCategory}',
                  style: const TextStyle(
                    
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _typeController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          // labelText: 'Tap here to add jeans type'),
                          labelText: 'Type*',
                          helperText: 'Sweater/Hoodie/Jackets',
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.black, width: .4),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please complete the required field';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _brandController, //_brandController
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'Brand*',
                          helperText: 'Wrangler/Levis/Diesel...',
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: 0.4),
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
                        controller: _materialController, //_brandController
                        //enabled: false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          //labelText: 'Tap here to add jeans type'),
                          labelText: 'Material*',
                          helperText: 'Cotton/Denim/Linen...',
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
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
                        cursorColor: Colors.black,
                        controller: _colorController,
                        decoration: InputDecoration(
                          labelText: 'Color*',
                          helperText: ('Blue/Red/Green/Multicolored...'),
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
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
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'Size*',
                          helperText: ('S/M/L/XL/XXL...'),
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
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
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Min Qty*',
                          helperText: ('One/Two/Three...'),
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
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
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
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
                        cursorColor: Colors.black,
                        maxLength: 4000,
                        minLines: 1,
                        maxLines: 30,
                        decoration: InputDecoration(
                          labelText: 'Description*',
                          hintText: 'Minimum 10 Characters',
                          helperText: (' Blue color denim jeans...'),
                          labelStyle: const TextStyle(color: Colors.black),
                          helperStyle: const TextStyle(color: Colors.black),
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
                            borderSide:
                                const BorderSide(color: Colors.red, width: .4),
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
                  ? Container(
                      height: 500,
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
                                        FileImage(previewImageVideo[_index]),
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
                                  itemCount: previewImageVideo.length,
                                  itemBuilder: (BuildContext context, int i) {
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
                                          borderRadius: const BorderRadius.all(
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
                    )
                  : Container(),
              const SizedBox(
                height: 80,
              ),

              // Container(
              //   height: 150,
              //   child: StaggeredGridView.countBuilder(
              //     crossAxisCount: 4,
              //     itemCount: previewImageVideo.length + 1,
              //     itemBuilder: (BuildContext context, index) {
              //       return index == previewImageVideo.length
              //           ? GestureDetector(
              //         onTap: () {
              //           getImage(true, previewImageVideo.length);
              //         },
              //         child: Container(
              //           child: DottedBorder(
              //             color: Colors.grey,
              //             strokeWidth: 1,
              //             radius: Radius.circular(8),
              //             dashPattern: [8, 10],
              //             child: ClipRRect(
              //               child: Container(
              //                 width: double.infinity,
              //                 height: double.infinity,
              //                 child: Icon(
              //                   Icons.add,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //           : InkWell(
              //         child: Stack(
              //           children: [
              //             Container(
              //               decoration: BoxDecoration(
              //                   borderRadius:
              //                   BorderRadius.circular(8),
              //                   color: Colors.white,
              //                   image: DecorationImage(
              //                       image: FileImage(
              //                           previewImageVideo[index]),
              //                       fit: BoxFit.fill)),
              //             ),
              //             Positioned(
              //                 bottom: 35,
              //                 left: 35,
              //                 child: IconButton(
              //                     onPressed: () {
              //                       setState(() {
              //                         previewImageVideo
              //                             .removeAt(index);
              //                       });
              //                     },
              //                     icon: Icon(
              //                       Icons.cancel,
              //                       color: Colors.black,
              //                     )))
              //           ],
              //         ),
              //       );
              //     },
              //     staggeredTileBuilder: (int index) =>
              //     new StaggeredTile.count(1, 1),
              //     mainAxisSpacing: 3,
              //     crossAxisSpacing: 3,
              //   ),
              // ),

              //address was here now in user review screen

              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[300],
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   child: _provider.urlList.isEmpty
              //       ? const Padding(
              //           padding: EdgeInsets.all(10.0),
              //           child: Text(
              //             'No Image selected',
              //             textAlign: TextAlign.center,
              //           ),
              //         )
              //       : GalleryImage(
              //           imageUrls: _provider.urlList,
              //           numOfShowImages: _provider.urlList.length,
              //         ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {uploadFile().then((value) => setState(() {
              //       productImageList.add(value.toString().replaceAll('[', '').replaceAll(']', ''));
              //     }));
              //     // upoad images would be done
              //     // showDialog(
              //     //     context: context,
              //     //     builder: (BuildContext context) {
              //     //       return ImagePickerWidget();
              //     //     });
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
              //               ? const Center(
              //             child: CircularProgressIndicator(
              //               color: Colors.orange,
              //             ),
              //           ) :  Text('Upload Image ',),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 80,
              // ),
            ],
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
                                color: Colors.white,
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
              )
            ],
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
      //             color: Color.fromRGBO(238, 242, 246, 170),
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
      //             validate(_provider);
      //             // print(_provider.dataToFirestore);
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
        // setState(() {
        //   isLoading = false;
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       behavior: SnackBarBehavior.floating,
        //       content: Text(
        //         'Image Uploaded Successfully !',
        //       ),
        //     ),
        //   );
        // });
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
}

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

class SellerTrackshoForm extends StatefulWidget {
  const SellerTrackshoForm({Key? key}) : super(key: key);
  static const String id = 'trackshort-form';

  @override
  State<SellerTrackshoForm> createState() => _SellerTrackshoFormState();
}

class _SellerTrackshoFormState extends State<SellerTrackshoForm> {
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
    //and if
    // if (provider.urlList.isNotEmpty) {
    //should have an image
    provider.dataToFirestore.addAll({
      'category': provider.selectedCategory,
      'size': _sizeController.text,
      'type': _typeController.text,
      'productName': _brandController.text,
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
    Navigator.pushNamed(context, UserReviewScreen.id);
    setState(() {
      isLoading = false;
    });
  }
  // else {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Please complete required fields'),
  //     ),
  //   );
  // }
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
                    decoration: InputDecoration(
                      // labelText: 'Tap here to add jeans type'),
                      labelText: 'Type*',
                      helperText: 'Tracksuit/Lace-up/Drop-Shoulder...',
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
                    decoration: InputDecoration(
                      //labelText: 'Tap here to add jeans type'),
                      labelText: 'Brand*',
                      helperText: 'Nike/Adidas/Puma...',
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
                    controller: _materialController, //_brandController
                    cursorColor: Colors.black,
                    //enabled: false,
                    decoration: InputDecoration(
                      //labelText: 'Tap here to add jeans type'),
                      labelText: 'Material*',
                      helperText: 'Polyster/Micro-Fibre/Nylon...',
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
                    controller: _colorController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Color*',
                      helperText: ('eg. Blue/Red/Green...'),
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
                    decoration: InputDecoration(
                      labelText: 'Description*',
                      helperText: ('Comfort/flexibility...'),
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
                  const SizedBox(
                    height: 30,
                  ),
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
                                                        Radius.circular(10,),),),
                                            child: Image.file(
                                                previewImageVideo[i]),
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
                ], // Video 13 31:20 fuel controller
              ),
            ),
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
      } finally {}
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

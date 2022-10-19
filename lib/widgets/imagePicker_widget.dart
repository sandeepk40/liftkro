import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  //Image Picker
  bool _uploading = false;
  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    XFile? pickedFile =
        await picker.pickImage(source: source, imageQuality: 50);
    setState(() async {
      if (pickedFile != null) {
        CroppedFile? cropFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
          ],
          uiSettings: [
            AndroidUiSettings(
              backgroundColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
            )
          ],
        );

        _image = File(cropFile!.path);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    //upload to firebase
    Future<String?> uploadFile() async {
      File file = File(_image!.path);
      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String? downloadUrl;
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if (downloadUrl != null) {
          setState(() {
            _image = null;
            _provider.getImages(downloadUrl);
          });
        }
      } on FirebaseException catch (e, s) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Failed to upload image',
            ),
          ),
        );
        print('Upload canceled error: $e\nStackTrace: $s');
      }
      return downloadUrl;
    }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Upload Product Images',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (_image != null)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _image == null
                            ? Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: Colors.grey[300],
                              )
                            : Image.file(
                                // _only _image
                                File(
                                  _image!.path,
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_provider.urlList.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GalleryImage(
                      imageUrls: _provider.urlList,
                      numOfShowImages: _provider.urlList.length,
                    ), //Gallery Image
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (_image != null)
                  Row(
                    children: [
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.purple[200]),
                          onPressed: () {
                            setState(() {
                              _uploading = true;
                              uploadFile().then((url) {
                                if (url != null) {
                                  setState(() {
                                    _uploading = false;
                                  });
                                }
                              });
                            });
                          },
                          child: const Text(
                            'Save',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(color: Colors.orange[200]),
                          onPressed: () {},
                          child: const Text(
                            'Delete',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        style: const NeumorphicStyle(
                          color: Color.fromRGBO(238, 242, 246, 170),
                        ),
                        child: Text(
                          _provider.urlList.isNotEmpty
                              ? 'Upload more images'
                              : 'Upload from Gallery ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color.fromARGB(
                              255,
                              100,
                              40,
                              0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 8,),
                // Row(
                //   children: [
                //     Expanded(
                //       child: NeumorphicButton(
                //         onPressed: () {
                //           getImage(ImageSource.camera);
                //         },
                //         style: NeumorphicStyle(
                //           color: Color.fromRGBO(238, 242, 246,170),
                //         ),
                //         child: Text(
                //           _provider.urlList.length > 0
                //               ? 'Upload from Camera'
                //               : 'Upload from Camera',
                //           textAlign: TextAlign.center,
                //           style: const TextStyle(
                //             color: Color.fromARGB(
                //               255,
                //               100,
                //               40,
                //               0,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),
                if (_uploading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haggle/provider/category_provider.dart';
import 'package:haggle/screens/account_screen.dart';
import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/login_screen.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/services/firebase_services.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({Key? key}) : super(key: key);
  static const String id = 'account-details-screen';

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool isEnabled = false;

  final FirebaseService _service = FirebaseService();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  // final _autoaddressController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _aboutController = TextEditingController();
  String location = 'Null, Press Button';


  Future<void> updateUser(provider, Map<String, dynamic> data, context) async {
    print('update account detials data: $data');
    return _service.users.doc(_service.user!.uid).update(data).then((value) {
      saveProductsToDB(provider, context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Future<void> saveProductsToDB(CategoryProvider provider, context) async {
    _service.products.add(provider.dataToFirestore).then((value) {
      provider.clearData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account details have been updated'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update location'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

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
                    'Update my profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Text(
                  //   'Are you sure, You want to save the product?',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // ListTile(
                  //   leading:
                  //       Image.network(_provider.dataToFirestore['images'][0]),
                  //   title: Text(
                  //     _provider.dataToFirestore['description'],
                  //     maxLines: 1,
                  //   ),
                  //   subtitle: Text('₹${_provider.dataToFirestore['price']}'),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: NeumorphicButton(
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
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: NeumorphicButton(
                            style: const NeumorphicStyle(
                              color: Colors.black45,
                            ),
                            child: const Text(
                              'Confirm',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
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
                                    'shop_name': _shopNameController.text,
                                    'email':_emailController.text,
                                    'address': _addressController.text,
                                    'about': _aboutController.text,
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
                        ),
                      ],
                    ),
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
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
        elevation: 0,
        title: const Text(
          'Edit Account Details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
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
                      Theme
                          .of(context)
                          .primaryColor),
                ),
              );
            }
            _nameController.text = snapshot.data?['name'] ?? "";
            _phoneController.text = snapshot.data?['mobile'] ?? "";
            _emailController.text = snapshot.data?['email'] ?? "";
            _addressController.text = snapshot.data?['address'] ?? "";
            _shopNameController.text = snapshot.data?['shop_name'] ?? "";
            _aboutController.text = snapshot.data?['about'] ?? "";

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 69,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(
                                  CupertinoIcons.person_alt,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 5,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(
                                    Icons.camera_enhance,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Account details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        enabled: isEnabled,
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          labelText: 'Name',
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
                                color: Colors.black, width: 1),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _phoneController,
                        enabled: isEnabled,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counter: const Offstage(),
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
                            labelText: 'Mobile Number*  ',
                            hintText: 'Enter your mobile number'),
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _emailController,
                        enabled: isEnabled,
                        decoration: InputDecoration(
                          hintText: 'Enter contact email',
                          labelText: 'E-mail',
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
                      SizedBox(height: 15,),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextFormField(
                      //         controller: _autoaddressController,
                      //         enabled: isEnabled,
                      //         minLines: 1,
                      //         maxLines: 4,
                      //         decoration: InputDecoration(
                      //           labelText: 'Address* 1',
                      //           hintText: ('Contact address'),
                      //           labelStyle:
                      //           const TextStyle(color: Colors.black),
                      //           helperStyle:
                      //           const TextStyle(color: Colors.black),
                      //           errorStyle:
                      //           const TextStyle(color: Colors.black),
                      //           contentPadding: const EdgeInsets.symmetric(
                      //               vertical: 20.0, horizontal: 10.0),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.black, width: .4),
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.black, width: .4),
                      //           ),
                      //           errorBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.black, width: .4),
                      //           ),
                      //           focusedErrorBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12.0),
                      //             borderSide: const BorderSide(
                      //                 color: Colors.black, width: .4),
                      //           ),
                      //         ),
                      //         validator: (value) {
                      //           if (value!.isEmpty) {
                      //             return 'Please complete required field';
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ),
                      //     IconButton(onPressed: (){
                      //       _autoaddressController.text= "";
                      //     }, icon: Icon(Icons.cancel)),
                      //     IconButton(
                      //       onPressed: () async {
                      //         if(isEnabled == true){
                      //           Position position = await _determinePosition();
                      //           location =
                      //           'Lat: ${position.latitude}, Long: ${position.longitude}';
                      //           // print('loction: ${widget.address}');
                      //           getAddressFromLatiLong(position);
                      //           setState(() {});
                      //         }else{
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             const SnackBar(
                      //               content: Text('Location Disable'),
                      //               behavior: SnackBarBehavior.floating,
                      //             ),
                      //           );
                      //         }
                      //
                      //       },
                      //       icon:  Icon(
                      //         Icons.location_on,
                      //         size: 25,
                      //         color: isEnabled ? Colors.orange : Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _addressController,
                        enabled: isEnabled,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Address*',
                          hintText: ('Contact address'),
                          labelStyle:
                          const TextStyle(color: Colors.black),
                          helperStyle:
                          const TextStyle(color: Colors.black),
                          errorStyle:
                          const TextStyle(color: Colors.black),
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
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _shopNameController,
                        enabled: isEnabled,
                        decoration:  InputDecoration(
                          labelText: 'Shop Name*',
                          hintText: 'Enter your shopname',
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
                            return 'Enter your shop name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _aboutController,
                        enabled: isEnabled,
                        decoration:  InputDecoration(
                          labelText: 'About',
                          hintText: 'Speciality in selling',
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
                            return 'Tell about your speciality';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15,),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: NeumorphicButton(
                              style: const NeumorphicStyle(
                                  color: Color.fromRGBO(238, 242, 246, 170)),
                              child: const Text(
                                'Edit Details',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEnabled = !isEnabled;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: NeumorphicButton(
                              style: const NeumorphicStyle(
                                color: Color.fromRGBO(238, 242, 246, 170),),
                              child: const Text(
                                'Update Details',
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
                              },
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 50,
                      // )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // if (!serviceEnabled) {
    //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //   return Future.error('Location Services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatiLong(Position position) async {
    List<Placemark> placemark =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[1];
    // _autoaddressController.text = '${place.subLocality}, ${place.locality}';
    // Fluttertoast.showToast(msg: "${widget.address}");
  }

  SelectedItem(BuildContext context, value) {
    switch (value) {
      case 0:
        setState(() {
          isEnabled = !isEnabled;
        });
        break;
      case 1:
      // FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
            const LocationScreen(
              popScreen: MainScreen.id,
            ),
          ),
        );
        break;
    }
  }

}


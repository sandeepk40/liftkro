import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';

class ProfileDetailsForm extends StatefulWidget {
  const ProfileDetailsForm({Key? key}) : super(key: key);
  static const String id = 'profile-form';
  @override
  State<ProfileDetailsForm> createState() => _ProfileDetailsFormState();
}

class _ProfileDetailsFormState extends State<ProfileDetailsForm> {
  final _formKey3 = GlobalKey<FormState>();

  final _shopNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aboutController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  // final _autoaddressController = TextEditingController();
  String dropdownvalue = 'Wholesaler';
  String location = 'Null, Press Button';
  late CategoryProvider _categoryProvider ;

  @override
  void initState() {
    print('inside: main profile');
    _categoryProvider = Provider.of<CategoryProvider>(context,listen: false);
    super.initState();
  }
  // List of items in our dropdown menu
  var items = [
    'Wholesaler',
    'Retailer',
  ];
  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
            child: Form(
              key: _formKey3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Account details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                      TextFormField(
                        controller: _nameController, //_brandController
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          //labelText: 'Tap here to add jeans type'),
                          labelText: 'Seller Name*',
                          helperText: 'Seller Name',
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
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _phoneController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number*  ',
                          helperText: 'Enter your mobile number',
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
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter mobile number';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'Email*',
                          helperText: 'Enter email address',
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
                          final bool isValid = EmailValidator.validate(
                              _emailController.text);
                          if (value == null || value.isEmpty) {
                            return "Enter Email";
                          }
                          if (value.isNotEmpty && isValid == false) {
                            return 'Enter Valid Email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _aboutController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'About*  ',
                          helperText: 'Tell what you are famous for',
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
                        maxLines: 2,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter required field';
                          }
                          return null;
                        },
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextFormField(
                      //         controller: _autoaddressController,
                      //         // enabled: isEnabled,
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
                      //         // if(isEnabled == true){
                      //         Position position = await _determinePosition();
                      //         location =
                      //         'Lat: ${position.latitude}, Long: ${position.longitude}';
                      //         // print('loction: ${widget.address}');
                      //         getAddressFromLatiLong(position);
                      //         setState(() {});
                      //         // }else{
                      //         //   ScaffoldMessenger.of(context).showSnackBar(
                      //         //     const SnackBar(
                      //         //       content: Text('Location Disable'),
                      //         //       behavior: SnackBarBehavior.floating,
                      //         //     ),
                      //         //   );
                      //         // }
                      //
                      //       },
                      //       icon:  Icon(
                      //         Icons.location_on,
                      //         size: 25,
                      //         color: Colors.orange,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      TextFormField(
                        controller: _addressController,
                        cursorColor: Colors.black,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Address*',
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
                      if (dropdownvalue.toString() == 'Wholesaler')
                        TextFormField(
                          controller: _shopNameController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Shop Name*  ',
                            helperText: 'Enter your shop name',
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
                          maxLength: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter mobile number';
                            }
                            return null;
                          },
                        ),

                      // if (dropdownvalue == 'Wholesaler')
                      //   TextFormField(
                      //     controller:
                      //         _shopNameController, //_brandController

                      //     decoration: const InputDecoration(
                      //         //labelText: 'Tap here to add jeans type'),
                      //         labelText: 'Shop Name*',
                      //         helperText: 'Shop Name'),
                      //   ),
                      const SizedBox(
                        height: 80,
                      ),
                    ], // Video 13 31:20 fuel controller
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  // _categoryProvider.getUserDetails(context);
                  if (_formKey3.currentState!.validate()) {
                    _catProvider.updateUserDetails(
                      context: context,
                      number: _phoneController.text,
                      shopName: _shopNameController.text,
                      sellerType: dropdownvalue,
                      sellerName: _nameController.text,
                      about: _aboutController.text,
                    );
                  }
                  // print(_provider.dataToFirestore);
                },
              ),
            ),
          ),
        ],
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
}

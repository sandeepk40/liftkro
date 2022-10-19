import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/services/firebase_services.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';
  final String? popScreen;
  const LocationScreen({Key? key, this.popScreen}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final FirebaseService _service = FirebaseService();

  bool _loading = true;

  late bool _serviceEnabled; // added late modifier
  late PermissionStatus _permissionGranted; // added late modifier
  late LocationData _locationData; // added late modifier
  late String _address;
  Position? _currentPosition;
  String? _currentAddress;
  LatLng currentLatLong = LatLng(37.42796133580664, -122.085749655962);
  String? countryValue;
  String stateValue = "";
  String cityValue = "";
  late String manualAddress;

  // Future<LocationData?> getLocation() async {
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return null;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return null;
  //     }
  //   }

  //   _locationData = await location.getLocation();
  //   // final coordinates =
  //   //     Coordinates(_locationData.latitude, _locationData.longitude);
  //   // GeoData data = await Geocoder2.getDataFromCoordinates(
  //   //     latitude: 40.714224,
  //   //     longitude: -73.961452,
  //   //     googleMapApiKey: "AIzaSyDNf81qkxZ75wPCApeCaUPiOnMzDRXi0L8");
  //   // GBLatLng position = GBLatLng(lat: 38.8951,lng: -77.0364);
  //   // GBData data = await GeocoderBuddy.findDetails(position);
  //   // var addresses =
  //   //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   print(data);
  //   // _address = data.address;
  //   // countryValue = data.country;
  //   // cityValue = data.city;
  //   // print('$_address,$countryValue,$cityValue');

  //   setState(() {});

  //   return _locationData;
  // }

  //
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() async {
    // Position? position = await Geolocator.getLastKnownPosition();
    // setState(() {
    //   _currentPosition = position;
    //   currentLatLong = LatLng(position?.latitude??0.0, position?.longitude??0.0);
    //   _getAddressFromLatLng();
    // });

    Position? position = await _determinePosition();
    setState(() {
      _currentPosition = position;
      currentLatLong = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng();
    });

    // Geolocator.getCurrentPosition(
    //         desiredAccuracy: LocationAccuracy.best,
    //         forceAndroidLocationManager: true)
    //     .then((Position position) {
    //   setState(() {
    //     _currentPosition = position;
    //     currentLatLong = LatLng(position.latitude, position.longitude);
    //     _getAddressFromLatLng();
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
  }

  _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentPosition?.latitude ?? 0.0,
            _currentPosition?.longitude ?? 0.0);
        //latLongToAddress();
        Placemark place = placemarks[0];

        setState(() {
          _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
          // flatNoController.text = "${place.locality}";
          // landmarkController.text = "${place.subLocality}";
        });
        print('------->$_currentAddress');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //fetching location from firestore

    if (widget.popScreen == null) {
      _service.users
          .doc(_service.user?.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          //location has already updated
          if (document['address'] != null) {
            // problem: it is not working here i put this in uthentication also
            if (mounted) {
              setState(() {
                _loading = true;
              });
              return Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MainScreen())); //home to main video 12, time 11:15
            }
          } else {
            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          }
        }
      });
    } else {
      setState(() {
        _loading = false;
      });
    }

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
      textColor: Colors.black,
      loadingText: 'Fetching Location...',
      progressIndicatorColor: Colors.black,
    );

    // showBottomScreen(context) {
    //   getLocation().then((location) {
    //     if (location != null) {
    //       //only after fetch location bottom screen will appear
    //       progressDialog.dismiss();
    //       showModalBottomSheet(
    //           isScrollControlled: true,
    //           enableDrag: true,
    //           context: context,
    //           builder: (context) {
    //             return Column(
    //               children: [
    //                 const SizedBox(
    //                   height: 26,
    //                 ),
    //                 AppBar(
    //                   automaticallyImplyLeading: false,
    //                   iconTheme: const IconThemeData(color: Colors.black),
    //                   elevation: 0,
    //                   backgroundColor: const Color.fromRGBO(238, 242, 246, 170),
    //                   title: Row(
    //                     children: [
    //                       IconButton(
    //                         onPressed: () {
    //                           Navigator.pop(context);
    //                         },
    //                         icon: const Icon(Icons.clear),
    //                       ),
    //                       const SizedBox(
    //                         width: 10,
    //                       ),
    //                       const Text(
    //                         'Location',
    //                         style: TextStyle(color: Colors.black),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       border: Border.all(),
    //                       borderRadius: BorderRadius.circular(6),
    //                     ),
    //                     child: SizedBox(
    //                       height: 40,
    //                       child: TextFormField(
    //                         decoration: const InputDecoration(
    //                           hintText: 'Search City, Area or Neighbourhood',
    //                           hintStyle: TextStyle(
    //                             color: Colors.grey,
    //                           ),
    //                           icon: Padding(
    //                             padding: EdgeInsets.only(left: 10),
    //                             child: Icon(
    //                               Icons.search,
    //                               size: 30,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 ListTile(
    //                   onTap: () async {
    //                     progressDialog.show();
    //                     getLocation().then((value) {
    //                       if (value != null) {
    //                         _service.updateUser({
    //                           'location':
    //                               GeoPoint(value.latitude!, value.longitude!),
    //                           'address': _address,
    //                         }, context, widget.popScreen).then((value) {
    //                           progressDialog.dismiss();
    //                           //  return Navigator.pushNamed(
    //                           //    context, widget.popScreen as String);
    //                         });
    //                       }
    //                     });
    //                   },
    //                   horizontalTitleGap: 0.0,
    //                   leading: const Icon(
    //                     Icons.my_location,
    //                     color: Colors.blue,
    //                   ),
    //                   title: const Text(
    //                     'Use current location',
    //                     style: TextStyle(
    //                       color: Colors.blue,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   subtitle: Text(
    //                     _address,
    //                     style: const TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   color: Colors.grey[300],
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(
    //                       left: 10,
    //                       top: 4,
    //                       bottom: 4,
    //                     ),
    //                     child: Text(
    //                       'Select City ',
    //                       style: TextStyle(
    //                         color: Colors.blueGrey.shade900,
    //                         fontSize: 12,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 //used to add country state city
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //                   child: CSCPicker(
    //                     layout: Layout.vertical,
    //                     flagState: CountryFlag.DISABLE,
    //                     dropdownDecoration:
    //                         const BoxDecoration(shape: BoxShape.rectangle),
    //                     defaultCountry: DefaultCountry.India,
    //                     onCountryChanged: (value) {
    //                       setState(() {
    //                         countryValue = value;
    //                       });
    //                     },
    //                     onStateChanged: (value) {
    //                       setState(() {
    //                         stateValue = value ?? "";
    //                       });
    //                     },
    //                     onCityChanged: (value) {
    //                       setState(() {
    //                         cityValue = value ?? "";
    //                         manualAddress =
    //                             '$cityValue,$stateValue,$countryValue';
    //                       });
    //                       if (value != null) {
    //                         _service.updateUser({
    //                           'address': manualAddress,
    //                           'state': stateValue,
    //                           'city': cityValue,
    //                           'country': countryValue,
    //                         }, context, widget.popScreen);
    //                       }
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             );
    //           });
    //     } else {
    //       progressDialog.dismiss();
    //     }
    //   });
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 100,
                    right: 10,
                    left: 10,
                  ),
                  child: Image.asset(
                    'assets/images/store.png',
                    width: 200,
                    height: 200,
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Where do you want \nto buy/sell product',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'We need to know what you are looking for\nso that you take benefit from everything we have',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _loading
                ? Column(
              // at here it is used
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 8,
                ),
                Text(
                    'Finding location...'), //stuck here in continuous loop
              ],
            )
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _loading
                            ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                                Colors.black),
                          ),
                        )
                            : ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(28.0),
                                side: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(
                              Colors.black,
                            ),
                          ),
                          icon: const Icon(
                              CupertinoIcons.location_fill),
                          label: const Padding(
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15),
                            child: Text(
                              'Around me',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () {
                            // getLocation().then((value) {
                            //   if (value != null) {
                            //     _service.updateUser({
                            //       'address': _address,
                            //       'location': GeoPoint(
                            //           value.latitude!,
                            //           value.longitude!),
                            //     }, context, widget.popScreen);
                            //   }
                            // });
                            _getCurrentLocation();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    progressDialog.show(); // from phone auth screen
                    // showBottomScreen(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1),
                        ),
                      ),
                      child: const Text(
                        'Set location manually',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

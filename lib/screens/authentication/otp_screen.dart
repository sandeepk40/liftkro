import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:haggle/screens/authentication/phoneauth_screen.dart';
import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/main_screen.dart';

import 'package:haggle/services/phoneauth_services.dart';

class OTPScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const OTPScreen({this.number, this.verId});
  final String? number; //added ?
  final String? verId; //added ?

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _loading = false;
  String error = '';
  final PhoneAuthService _services = PhoneAuthService();
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();

  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();
  final _text4 = TextEditingController();
  final _text5 = TextEditingController();
  final _text6 = TextEditingController();

  Future<void> phoneCredential(
      BuildContext context,
      String otp,
      ) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verId!, smsCode: otp); // exclamation added
      final User? user =
          (await _auth.signInWithCredential(credential)).user; // Changed

      ///User

      if (user != null) {
        _services.addUser(context, user.uid);
      } else {
        print('Login Failed');
        if (mounted) {
          setState(() {
            error = 'Login Failed';
          });
        }
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          error = 'Invalid OTP';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/phone.png',
              ),
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   elevation: 3,
          //   backgroundColor: Color.fromRGBO(238, 242, 246,170),
          //   title: const Text(
          //     'Login',
          //     style: TextStyle(
          //       color: Colors.black
          //     ),
          //   ),
          //   automaticallyImplyLeading: false, //to remove back screen
          // ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.4, color: Colors.white),
                    color: Colors.white24,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const SizedBox(
                      //   height: 400,
                      // ),
                      // CircleAvatar(
                      //   radius: 30,
                      //   backgroundColor: Color.fromRGBO(238, 242, 246,170),
                      //   child: const Icon(
                      //     CupertinoIcons.person_alt_circle,
                      //     size: 60,
                      //     color: Color.fromARGB(255, 240, 167, 118),
                      //   ),
                      // ),

                      const Padding(
                        padding: EdgeInsets.only(top: 25, bottom: 10),
                        child: Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'We have send a 6-Digit code to ',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: widget.number,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const PhoneAuthScreen(),
                                  ),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         const PhoneAuthScreen(),
                                //   ),
                                // );
                              },
                              child: Container(
                                height: 18,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 0.4, color: Colors.white),
                                  color: Colors.white24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Edit',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              )
                            //  const Icon(
                            //   Icons.edit,
                            //   size: 18,
                            //   color: Colors.white,
                            // ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                cursorColor: Colors.white,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                controller: _text1,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  counter: const Offstage(),
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorStyle:
                                  const TextStyle(color: Colors.white),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    node.nextFocus();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                cursorColor: Colors.white,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                controller: _text2,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  counter: const Offstage(),
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorStyle:
                                  const TextStyle(color: Colors.white),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    node.nextFocus();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                cursorColor: Colors.white,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                controller: _text3,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  counter: const Offstage(),
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorStyle:
                                  const TextStyle(color: Colors.white),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    node.nextFocus();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                cursorColor: Colors.white,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                controller: _text4,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  counter: const Offstage(),
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorStyle:
                                  const TextStyle(color: Colors.white),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    node.nextFocus();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                cursorColor: Colors.white,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                controller: _text5,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  counter: const Offstage(),
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorStyle:
                                  const TextStyle(color: Colors.white),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    node.nextFocus();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                cursorColor: Colors.white,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                controller: _text6,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  counter: const Offstage(),
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorStyle:
                                  const TextStyle(color: Colors.white),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: .4),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    if (_text1.text.length == 1) {
                                      if (_text2.text.length == 1) {
                                        if (_text3.text.length == 1) {
                                          if (_text4.text.length == 1) {
                                            if (_text5.text.length == 1) {
                                              //This is the OTP we recieved
                                              String _otp =
                                                  '${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}${_text6.text}';
                                              setState(() {
                                                _loading = true;
                                              });
                                              phoneCredential(
                                                context,
                                                _otp,
                                              );
                                              Navigator.pushNamed(
                                                  context, MainScreen.id);
                                            }
                                          }
                                        }
                                      }
                                    } else {
                                      return setState(() {
                                        _loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Wait few minutes for the OTP,',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Do not refresh or close!,',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Row(
                          children: [
                            const Text(
                              'Didn\'t recieve the OTP?',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            TextButton(
                              onPressed: () {
                                // String number =
                                //     '${countryCodeController.text}${phoneNumberController.text}';

                                // _services.verifyPhoneNumber(context, number);
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text(
                                //       'We sent a new code to your mobile number',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //     behavior: SnackBarBehavior.floating,
                                //   ),
                                // );
                              },
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_loading)
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 50,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haggle/services/phoneauth_services.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);
  static const String id = 'phone-auth-screen';

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//variables
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();
  bool validate = false;
  bool _loading = false;

  PhoneAuthService _service = PhoneAuthService();

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.grey[100],
      textColor: Colors.black45,
      loadingText: 'Please Wait',
      progressIndicatorColor: Colors.black,
    );

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/phone.png',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   elevation: 1,
          //   backgroundColor: Color.fromRGBO(238, 242, 246,170),
          //   iconTheme: const IconThemeData(
          //     color: Colors.black
          //   ),
          //   title: const Text(
          //     'Login',
          //     style: TextStyle(
          //       color: Colors.black
          //     ),
          //   ),
          // ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 400,
                      // ),
                      // CircleAvatar(
                      //   radius: 30,
                      //   backgroundColor: Color.fromRGBO(238, 242, 246,170),
                      //   child: const Icon(
                      //     CupertinoIcons.person_alt_circle,
                      //     color: Color.fromARGB(255, 240, 167, 118),
                      //     size: 60,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Enter your Phone',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          ' We will send you confirmation code to your phone',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          // Expanded(
                          //   flex: 1,
                          //   child: TextFormField(

                          //     controller: countryCodeController,
                          //     enabled: false,
                          //     decoration: const InputDecoration(
                          //       counterText: '00',
                          //       labelText: 'Country',
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          Expanded(
                            // flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    setState(() {
                                      validate = true;
                                    });
                                  }
                                  if (value.length < 10) {
                                    setState(() {
                                      validate = false;
                                    });
                                  }
                                },
                                autofocus: false,
                                maxLength: 10, // only 10 digits for contact
                                keyboardType: TextInputType.phone,
                                controller: phoneNumberController,

                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  helperStyle:
                                      const TextStyle(color: Colors.white),
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
                                  hintText: 'Enter your phone number',
                                  hintStyle: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, bottom: 20),
                        child: AbsorbPointer(
                          absorbing: validate ? false : true,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              backgroundColor: validate
                                  ? MaterialStateProperty.all(
                                      Colors.white) // if validated
                                  : MaterialStateProperty.all(
                                      Colors.white60), // if not validated
                            ),
                            onPressed: () {
                              progressDialog.show();

                              String number =
                                  '${countryCodeController.text}${phoneNumberController.text}';

                              _service.verifyPhoneNumber(context, number);
                              progressDialog.dismiss();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: AbsorbPointer(
          //     absorbing: validate ? false : true,
          //     child: ElevatedButton(
          //       style: ButtonStyle(
          //         backgroundColor: validate
          //             ? MaterialStateProperty.all(Colors.white) // if validated
          //             : MaterialStateProperty.all(
          //                 Colors.grey[400]), // if not validated
          //       ),
          //       onPressed: () {
          //         progressDialog.show();

          //         String number =
          //             '${countryCodeController.text}${phoneNumberController.text}';

          //         _service.verifyPhoneNumber(context, number);
          //         progressDialog.dismiss();
          //       },
          //       child: const Padding(
          //         padding: EdgeInsets.all(12.0),
          //         child: Text(
          //           'Next',
          //           style: TextStyle(
          //             color: Colors.black,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }
}

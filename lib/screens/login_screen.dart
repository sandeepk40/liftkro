import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/backgrounds/widgets/background-image.dart';
import 'package:haggle/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id =
      'login-screen'; // for routes must remember its constant
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 300,
                      ),
                      // Image.asset(
                      //   'assets/images/hanger.png',
                      //   width: 150,
                      //   height: 150,
                      // ),
                      // const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   'LIFTKARO',
                          //   style: GoogleFonts.michroma(
                          //     color: Colors.white,
                          //     fontSize: 30,
                          //     fontStyle: FontStyle.italic,
                          //   ),
                          // ),
                          Text(
                            'LIFTKARO',
                            style: GoogleFonts.michroma(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                      // changed V1 20:36
                    ],
                  ),
                ),
              ),

              AuthUi(),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'If you continue,you are accepting \n Terms and Conditions and privacy and policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

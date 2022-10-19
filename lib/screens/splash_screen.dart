import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haggle/backgrounds/widgets/background-image.dart';
import 'package:haggle/backgrounds/widgets/email_login.dart';

import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/login_screen.dart';
import 'package:haggle/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 4,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          //Not Signedin
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          //signedIn
          Navigator.pushReplacementNamed(context, MainScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.black54,
      Colors.white,
      Colors.black54,
      Colors.white,
    ];

    const colorizeTextStyle = TextStyle(
        fontSize: 60.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold);
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/login.png',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(
                height: 300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/images/hanger1.png',
                  //   height: 200,
                  //   width: 200,

                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  // AnimatedTextKit(
                  //   animatedTexts: [
                  //     ColorizeAnimatedText(
                  //       'LiftKaro',
                  //       textStyle: colorizeTextStyle,
                  //       colors: colorizeColors,
                  //     ),
                  //   ],
                  //   isRepeatingAnimation: true,
                  //   onTap: () {
                  //     print("Tap Event");
                  //   },
                  // ),
                  // const Text(
                  //   'LIFTKARO',
                  //   style: TextStyle(
                  //     fontSize: 60,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),

                  // Text(
                  //       'Lift',
                  //       style: GoogleFonts.michroma(
                  //         color: Colors.white,
                  //         fontSize: 50.0,
                  //         fontStyle: FontStyle.italic,
                  //       ),

                  //     ),

                  Text(
                    'LIFTKARO',
                    style: GoogleFonts.michroma(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SpinKitCubeGrid(
                    size: 100,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

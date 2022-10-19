import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:haggle/screens/authentication/google_auth.dart';
import 'package:haggle/screens/authentication/phoneauth_screen.dart';
import 'package:haggle/services/phoneauth_services.dart';

import '../screens/authentication/email_auth_screen.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
              onPressed: () {
                Navigator.pushNamed(context, PhoneAuthScreen.id);
              },
              child: Row(
                children: const [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.phone_android_outlined,
                    color: Colors.black,
                    size: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Continue with phone',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
             onPressed: () async {
              User? user =
                  await GoogleAuthentication.signInWithGoogle(context: context);
              if (user != null) {
                //Login Success
                PhoneAuthService _authentication = PhoneAuthService();
                _authentication.addUser(context, user.uid);
              }
            },
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Image.asset('assets/images/google.png', height: 25,width: 25,),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SignInButton(
          //   Buttons.Google,
          //   text: ('Continue with Google'),
          //   onPressed: () async {
          //     User? user =
          //         await GoogleAuthentication.signInWithGoogle(context: context);
          //     if (user != null) {
          //       //Login Success
          //       PhoneAuthService _authentication = PhoneAuthService();
          //       _authentication.addUser(context, user.uid);
          //     }
          //   },
          // ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'OR',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EmailAuthScreen.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.white,
                  )),
                ),
                child: const Text(
                  'Login with Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

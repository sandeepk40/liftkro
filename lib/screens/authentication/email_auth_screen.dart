import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haggle/screens/authentication/reset_password_screen.dart';
import 'package:haggle/services/email_auth_services.dart';

class EmailAuthScreen extends StatefulWidget {
  static const String id = 'emailAuth-screen';
  const EmailAuthScreen({Key? key}) : super(key: key);

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool _login = false;
  bool _loading = false;
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final EmailAuthentication _service = EmailAuthentication();

  _validateEmail() {
    if (_formKey.currentState!.validate()) {
      // if email and password has entered
      setState(() {
        _validate = false;
        _loading = true;
      });
      _service
          .getAdminCredential(
          context: context,
          isLog: _login,
          password: _passwordController.text,
          email: _emailController.text)
          .then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/email.png',
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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 300,
                ),
                // Center(
                //   child: CircleAvatar(
                //     radius: 30,
                //     backgroundColor: Color.fromRGBO(238, 242, 246,170),
                //     child: const Icon(
                //       CupertinoIcons.person_alt_circle,
                //       color: Color.fromARGB(255, 240, 167, 118),
                //       size: 60,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 12,
                // ),
                Center(
                  child: Text(
                    //Login == true it will show as login else will show register
                    'Enter to ${_login ? 'Login' : 'Register'}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    ' Enter Email and Password to ${_login ? 'Login' : 'Register'}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // style: const TextStyle(height: 10),
                  cursorColor: Colors.black,
                  controller: _emailController,
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
                  decoration: InputDecoration(
                    // contentPadding: const EdgeInsets.only(left: 10),
                    errorStyle: const TextStyle(color: Colors.white),
                    hintText: 'Email',
                    icon: const Icon(Icons.email, color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 245, 230),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    // Border radius removed
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: _isObscure,
                  cursorColor: Colors.black,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    // contentPadding: const EdgeInsets.only(left: 10),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: 'Password',
                    icon: const Icon(
                      Icons.password,
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 245, 230),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    // Border radius removed
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                      const BorderSide(color: Colors.white, width: .4),
                    ),
                  ),
                  onChanged: (value) {
                    if (_emailController.text.isNotEmpty) {
                      if (value.length > 3) {
                        setState(() {
                          _validate = true;
                        });
                      } else {
                        setState(() {
                          _validate = false;
                        });
                      }
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, PasswordResetScreen.id);
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _login ? 'New account ?' : 'Already have an account?',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _login = !_login;
                        });
                      },
                      child: Text(
                        _login ? 'Register' : 'Login',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AbsorbPointer(
              absorbing: _validate ? false : true,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  backgroundColor: _validate
                      ? MaterialStateProperty.all(
                      Colors.orange[100]) // if validated
                      : MaterialStateProperty.all(const Color.fromARGB(
                      255, 202, 187, 175)), // if not validated
                ),
                onPressed: () {
                  _validateEmail();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _loading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                      : Text(
                    '${_login ? 'Login' : 'Register'}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

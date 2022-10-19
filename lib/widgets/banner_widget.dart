import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:haggle/screens/main_screen.dart';

import '../screens/sellItems/seller_category_list.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25, //height of banner
        color: Color.fromRGBO(238, 242, 246,170),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Garments',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  'Best Quality',
                                  textStyle: const TextStyle(
                                    color: Colors.black
                                  ),
                                  duration: const Duration(
                                    seconds: 3,
                                  ),
                                ),
                                FadeAnimatedText('Pure Material',
                                    textStyle: const TextStyle(
                                      color: Colors.black
                                    ),
                                    duration: const Duration(
                                      seconds: 3,
                                    )),
                                FadeAnimatedText(
                                  'Affordable in price',
                                  textStyle: const TextStyle(
                                    color: Colors.black
                                  ),
                                  duration: const Duration(
                                    seconds: 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Neumorphic(
                      style: const NeumorphicStyle(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/hanger-71739.appspot.com/o/Banner%2Fgarment.png?alt=media&token=e27cc7cf-f235-44ef-a08a-4ce38aff6a9f',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Expanded(
              //       child: NeumorphicButton(
              //         onPressed: () {
              //           Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const MainScreen()),
              //           );
              //         },
              //         style: const NeumorphicStyle(color: Colors.white),
              //         child: const Text(
              //           'Buy Clothes',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             color: Colors.black
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Expanded(
              //       child: NeumorphicButton(
              //         onPressed: () {
              //           Navigator.pushNamed(context, SellerCategory.id);
              //         },
              //         style: const NeumorphicStyle(color: Colors.white),
              //         child: const Text(
              //           'Sell Clothes',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             color: Colors.black
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

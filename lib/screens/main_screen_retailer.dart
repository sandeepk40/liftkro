import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:haggle/screens/account_form.dart';
import 'package:haggle/screens/account_screen.dart';
import 'package:haggle/screens/chat/chat_screen.dart';
import 'package:haggle/screens/bookmarks.dart';
import 'package:haggle/screens/home_screen.dart';

class MainScreenRetailer extends StatefulWidget {
  const MainScreenRetailer({Key? key}) : super(key: key);
  static const String id = 'retailer-main-screen';

  @override
  State<MainScreenRetailer> createState() => _MainScreenRetailerState();
}

class _MainScreenRetailerState extends State<MainScreenRetailer> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    Chatscreen(),
    BookMarks(),
    AccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: GNav(
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: Colors.black12,
              gap: 8,
              padding: const EdgeInsets.all(15),
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.chat_bubble_outline,
                  text: 'Chats',
                ),
                GButton(
                  icon: Icons.favorite_outline,
                  text: 'Favourites',
                ),
                GButton(
                  icon: Icons.person_outlined,
                  text: 'Account',
                ),
              ]),
        ),
      ),
    );
  }
}

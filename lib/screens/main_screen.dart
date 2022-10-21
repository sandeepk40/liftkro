import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haggle/screens/account_form.dart';
import 'package:haggle/screens/account_screen.dart';

import 'package:haggle/screens/chat/chat_screen.dart';
import 'package:haggle/screens/home_screen.dart';
import 'package:haggle/screens/my_store.dart';
import 'package:haggle/screens/sellItems/seller_category_list.dart';
import 'package:provider/provider.dart';

import '../provider/category_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String id = 'main-screen';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = const HomeScreen();

  int _index = 0; // the first screen that wil appear when app will open
  final PageStorageBucket _bucket = PageStorageBucket();
  late CategoryProvider _categoryProvider ;




  @override
  void initState() {
    _categoryProvider = Provider.of<CategoryProvider>(context,listen: false);
    _categoryProvider.getUserDetails(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen(),),);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          bucket: _bucket,
          child: _currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SellerCategory.id);
          },
          backgroundColor: Colors.black,
          child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: Text(
                'SELL',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(), //later
          notchMargin: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Left side of floating Button

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _index = 0;
                          _currentScreen = const HomeScreen();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 0 ? Icons.home : Icons.home_outlined,
                            color: Colors.black,
                            size: 28,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: _index == 0 ? Colors.black : Colors.black,
                              fontWeight: _index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _index = 1;
                          _currentScreen = const Chatscreen();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 1
                                ? CupertinoIcons.chat_bubble_fill
                                : CupertinoIcons.chat_bubble,
                            color: Colors.black,
                            size: 28,
                          ),
                          Text(
                            'Chats',
                            style: TextStyle(
                              color: _index == 1 ? Colors.black : Colors.black,
                              fontWeight: _index == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //Right Side of floating button
                Row(
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _index = 2;
                          _currentScreen = const MyAddScreen();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 2
                               ? Icons.store
                                : Icons.store_outlined,
                            color: Colors.black,
                            size: 28,
                          ),
                          Text(
                            'My Store',
                            style: TextStyle(
                              color: _index == 2 ? Colors.black : Colors.black,
                              fontWeight: _index == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _index = 3;
                          _currentScreen = const AccountScreen();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 3
                                ? CupertinoIcons.person_fill
                                : CupertinoIcons.person,
                            color: Colors.black,
                            size: 28,
                          ),
                          Text(
                            'Account',
                            style: TextStyle(
                              color: _index == 3 ? Colors.black : Colors.black,
                              fontWeight: _index == 3
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

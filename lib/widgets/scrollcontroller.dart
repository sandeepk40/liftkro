import 'package:flutter/material.dart';

Widget buildBTT(ScrollController _scrollController, bool goToTop) =>goToTop
    ? Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              _scrollController.animateTo(0,
                  duration: const Duration(seconds: 1), curve: Curves.linear);
            },
            label: const Text("Back to Top"),
          ),
        ),
      )
    : const SizedBox();

Widget buildText(bool isLastIndex) => isLastIndex
    ? const Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          "All caught up 🎉",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.00),
        ),
      )
    : const SizedBox();
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:like_button/like_button.dart';

class LikedButton extends StatefulWidget {
  const LikedButton({Key? key}) : super(key: key);

  @override
  State<LikedButton> createState() => _LikedButtonState();
}

class _LikedButtonState extends State<LikedButton> {
  bool isliked = false;
  int likeCount = 0;
  final key = GlobalKey<LikeButtonState>();
  @override
  Widget build(BuildContext context) {
    const double size = 20;
    const animationDuration = Duration(milliseconds: 200);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.white38,
          padding: EdgeInsets.zero),
      onPressed: () {
        key.currentState!.onTap();
      },
      child: LikeButton(
        key: key,
        size: size,
        isLiked: isliked,
        likeCount: likeCount,
        likeBuilder: (isLiked) {
          final color = isLiked ? Colors.red : Colors.black38;
          return Icon(
            Icons.favorite,
            color: color,
            size: size,
          );
        },
        animationDuration: animationDuration,
        likeCountPadding: const EdgeInsets.only(left: 5),
        countBuilder: (likeCount, isLiked, text) {
          final color = isLiked ? Colors.black : Colors.black38;
          return Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          );
        },
        onTap: (isLiked) async {
          isliked = !isliked;
          likeCount += isliked ? 1 : -1;
          Future.delayed(animationDuration).then((_) => setState(() {}));
          return !isliked;
        },
      ),
    );
  }
}

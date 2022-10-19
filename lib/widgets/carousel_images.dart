import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselImages extends StatefulWidget {
  const CarouselImages({Key? key}) : super(key: key);

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  int activeIndex = 0;
  final controller = CarouselController();
  final urlImages = [
    'https://firebasestorage.googleapis.com/v0/b/hanger-71739.appspot.com/o/carousel%2F0.png?alt=media&token=e54b6557-3cf6-42f4-b7e4-68ab66266b43',
    'https://firebasestorage.googleapis.com/v0/b/hanger-71739.appspot.com/o/carousel%2F1.png?alt=media&token=9b928df3-e6dd-4b78-b2ed-f74cf6cf0b47',
    'https://firebasestorage.googleapis.com/v0/b/hanger-71739.appspot.com/o/carousel%2F2.png?alt=media&token=64bf6eb0-710b-4efd-bb0d-4119214d22d8',
    'https://firebasestorage.googleapis.com/v0/b/hanger-71739.appspot.com/o/carousel%2F3.png?alt=media&token=cf8f6874-3f3e-44b4-9cd4-1a3b57580412',
    'https://firebasestorage.googleapis.com/v0/b/hanger-71739.appspot.com/o/carousel%2F4.png?alt=media&token=b536286c-c573-409e-bdbd-0a71b948d278',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color.fromRGBO(238, 242, 246, 170),
          height: 200,
          child: CarouselSlider.builder(
              carouselController: controller,
              itemCount: urlImages.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = urlImages[index];
                return buildImage(urlImage, index);
              },
              options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) =>
                      setState(() => activeIndex = index))),
        ),
        const SizedBox(height: 12),
        buildIndicator()
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const ExpandingDotsEffect(
            dotWidth: 15, activeDotColor: Colors.black,),
        activeIndex: activeIndex,
        count: urlImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String urlImage, int index) => Container(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        urlImage,
        height: 180,
      ),
    ));

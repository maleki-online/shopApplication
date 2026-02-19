import 'dart:async';

import 'package:digital_shop/models/AdsItem_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsSlider extends StatefulWidget {
  const AdsSlider({super.key});

  @override
  State<AdsSlider> createState() => _AdsSliderState();
}

class _AdsSliderState extends State<AdsSlider> {
  Timer? _timer;
  final List<AdModel> ads = [
    AdModel(
      imageUrl: "assets/images/3.png",
      routeName: "/productDetails",
    ),
    AdModel(
      imageUrl: "assets/images/1.jpg",
      externalUrl: "https://google.com",
    ),
  ];
  final PageController _controller = PageController();

  int currentPage = 0;
  @override
  void initState() {
    startAutoSlide();
    super.initState();
  }

  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage < ads.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 190,
          child: PageView.builder(
            controller: _controller,
            itemCount: ads.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final ad = ads[index];

              return GestureDetector(
                onTap: () async {
                  if (ad.routeName != null) {
                    Navigator.pushNamed(context, ad.routeName!);
                  } else if (ad.externalUrl != null) {
                    final Uri uri = Uri.parse(ad.externalUrl!);
                    await launchUrl(uri);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(ad.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _controller,
          count: ads.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.pink,
          ),
        ),
      ],
    );
  }
}

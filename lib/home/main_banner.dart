import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainBanner extends StatefulWidget {
  const MainBanner({Key? key}) : super(key: key);

  @override
  State<MainBanner> createState() => MainBannerState();
}

class MainBannerState extends State<MainBanner> {
  CarouselController carouselController = CarouselController();
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImages(),
        builder: (context, snapshot) {
          List<dynamic> images = [];
          List<String> linkUrls = [];
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              images.add(snapshot.data.docs[i]['imageUrl']);
              linkUrls.add(snapshot.data.docs[i]['linkUrl']);
            }
          } else {
            null;
          }
          return images.isEmpty
              ? const CircularProgressIndicator()
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2.5,
                      child: CarouselSlider.builder(
                        carouselController: carouselController,
                        itemCount: images.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () {
                              linkUrls[index].isNotEmpty
                                  ? launchUrl(
                                      Uri.parse(linkUrls[index]),
                                    )
                                  : null;
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.network(
                                images[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 6),
                          viewportFraction: 0.93,
                          onPageChanged: (index, reason) {
                            setState(() {
                              current = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => carouselController.animateToPage(entry.key),
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(current == entry.key ? 0.9 : 0.4),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                );
        });
  }
}

Future getImages() async {
  var result = await FirebaseFirestore.instance.collection("mainBanner").orderBy('bannerIndex', descending: true).get();
  return result;
}

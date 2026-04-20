/*import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCarouselCard extends StatelessWidget {
  final List<Map<String, String>> newsList = [
    {
      "title": "MARDI Paddy Research",
      "desc": "Explore Malaysia’s paddy research & innovation at MARDI.",
      "image": "assets/images/padi-705586_1280.jpg",
      "url": "https://www.mardi.gov.my/penyelidikan/padi-beras.html",
    },
    {
      "title": "Department of Agriculture",
      "desc": "Agri info & paddy farming by Jabatan Pertanian Malaysia.",
      "image": "assets/images/agro1.jpg",
      "url": "https://www.doa.gov.my/index.php/pages/view/348",
    },
    {
      "title": "Bernama - Agri News",
      "desc": "Latest agriculture and paddy news from Bernama.",
      "image": "assets/images/agro2.jpg",
      "url": "https://www.bernama.com/en/business/agri_food.php",
    },
    // Add more if you want!
  ];

  NewsCarouselCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 170,
        enlargeCenterPage: true,
        viewportFraction: 0.88,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
      ),
      items: newsList.map((news) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () async {
                final uri = Uri.parse(news["url"]!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: DecorationImage(
                    image: AssetImage(news["image"]!),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.13),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.46),
                        Colors.transparent
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          news["desc"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.82),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.open_in_new, size: 15, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "Read More",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
*/
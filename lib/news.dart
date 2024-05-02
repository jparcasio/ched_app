// import 'package:flutter/material.dart';

// class NewsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('News'),
//       ),
//       body: FutureBuilder<List<String>>(
//         future: fetchCarouselImages(), // Fetch carousel images from main_menu.dart
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Carousel(images: snapshot.data); // Display carousel with fetched images
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           return CircularProgressIndicator(); // Show loading indicator while fetching data
//         },
//       ),
//     );
//   }

//   Future<List<String>> fetchCarouselImages() async {
//     // Fetch carousel images from main_menu.dart
//     // Replace this with your actual implementation
//     await Future.delayed(Duration(seconds: 2)); // Simulating network delay
//     return ['image1.jpg', 'image2.jpg', 'image3.jpg'];
//   }
// }

// class Carousel extends StatelessWidget {
//   final List<String> images;

//   Carousel({required this.images});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: images.length,
//         itemBuilder: (context, index) {
//           return Image.asset(images[index]);
//         },
//       ),
//     );
//   }
// }
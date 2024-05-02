import 'package:chedapplication/article.dart';
import 'package:chedapplication/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  Future<List<RecordModel>> fetchNews() async {
    var result = await pb.collection('articles').getFullList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: FutureBuilder(
        future: fetchNews(), // Fetch carousel images from main_menu.dart
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var news = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleScreen(
                          articleId: news.id,
                        ),
                      ),
                    );
                  },
                  leading: 
                    news.data['image'] != null 
                      ? Image.network(
                          pb.getFileUrl(news, news.data['image'], thumb: '100x100').toString(),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ) 
                      : null,
                  title: Text(news.data['title']),
                  subtitle: Text(news.created),

                );
              },
            ); // Display carousel with fetched images
          }

          return Center(
            child: snapshot.hasError 
              ? Text('Error: ${snapshot.error}') 
              : const CircularProgressIndicator(),
          ); // Show loading indicator while fetching data
        },
      ),
    );
  }
}

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
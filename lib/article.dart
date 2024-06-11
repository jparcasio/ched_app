import 'package:chedapplication/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pocketbase/pocketbase.dart';

class ArticleScreen extends StatelessWidget {
  final String articleId;

  const ArticleScreen({
    super.key,
    required this.articleId
  });

  Future<RecordModel> fetchArticle(String articleId) async {
    var result = await pb.collection('articles').getOne(articleId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: fetchArticle(articleId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var article = snapshot.data!;
            return ListView(
              children: [
                if (article.data['image'] != null)
                  Image.network(
                    pb.getFileUrl(article, article.data['image']).toString(),
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    article.data['title'],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    article.data['content'],
                  ),
                ),
              ],
            );
          }

          return Center(
            child: snapshot.hasError
              ? Text('Error: ${snapshot.error}')
              : const CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
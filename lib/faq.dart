import 'package:chedapplication/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pocketbase/pocketbase.dart';

class FaqScreen extends StatefulWidget {
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int activeFaqIdx = -1;

  Future<List<RecordModel>> _loadFaqs() async {
    final faqs = await pb.collection('faqs').getFullList();
    return faqs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: Color(0xFF32A2EA), // Set the appBar color here
      ),
      body: FutureBuilder(
        future: _loadFaqs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? [];
            return ListView(
              children: [
                ExpansionPanelList(
                  children: [
                    for (var i = 0; i < data.length; i++)
                      ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(data[i].data['question']),
                          );
                        },
                        body: Container(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                          child: HtmlWidget(
                            data[i].data['answer'],
                          ),
                        ),
                        isExpanded: i == activeFaqIdx,
                      ),
                  ],
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      if (isExpanded) {
                        activeFaqIdx = -1;
                      } else {
                        activeFaqIdx = panelIndex;
                      }
                    });
                  },
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        })
    );
  }
}
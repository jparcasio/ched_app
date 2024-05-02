import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Social {
  final IconData icon;
  final String name;
  final String url;

  Social({required this.icon, required this.name, required this.url});
}

class SocialsPage extends StatefulWidget {
  SocialsPage({Key? key}) : super(key: key);

  @override
  SocialsPageState createState() => SocialsPageState();
}


class SocialsPageState extends State<SocialsPage> {
  List<Social> socials = [
    Social(
      icon: Icons.facebook,
      name: 'Facebook',
      url: 'https://www.facebook.com',
    ),
    Social(
      icon: FontAwesomeIcons.twitter,
      name: 'Twitter',
      url: 'https://www.twitter.com',
    ),
    Social(
      icon: FontAwesomeIcons.instagram,
      name: 'Instagram',
      url: 'https://www.instagram.com',
    ),
    Social(
      icon: FontAwesomeIcons.linkedin,
      name: 'LinkedIn',
      url: 'https://www.linkedin.com',
    ),
    Social(
      icon: FontAwesomeIcons.youtube,
      name: 'YouTube',
      url: 'https://www.youtube.com',
    ),
    Social(
      icon: FontAwesomeIcons.yahoo,
      name: 'Yahoo',
      url: 'https://www.yahoo.com',
    ),
    Social(
      icon: FontAwesomeIcons.envelope,
      name: 'Gmail',
      url: 'https://www.gmail.com',
    ),
    // Add more socials as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      backgroundColor: Colors.white, // Replace with the background color of main_menu.dart
      body: ListView.builder(
        itemCount: socials.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              socials[index].icon,
              color: Color(0xFF32A2EA), // Set the icon color to blue
            ),
            title: Text(socials[index].name),
            onTap: () {
              // Redirect the user to the social URL
              // Replace 'redirectFunction' with the appropriate function to redirect the user
              void redirectFunction(String url) {
                // Implement the logic to redirect the user to the provided URL
              }

              redirectFunction(socials[index].url);
            },
          );
        },
      ),
    );
  }
}
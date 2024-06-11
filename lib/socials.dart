import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher package

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
      icon: FontAwesomeIcons.globe,
      name: 'Official Website',
      url: 'https://ro11.ched.gov.ph/',
    ),
    Social(
      icon: Icons.facebook,
      name: 'Facebook',
      url: 'https://www.facebook.com',
    ),
    Social(
      icon: FontAwesomeIcons.twitter,
      name: 'Twitter',
      url: 'https://twitter.com/chedroxi',
    ),
    Social(
      icon: FontAwesomeIcons.instagram,
      name: 'Instagram',
      url: 'https://www.instagram.com',
    ),
    Social(
      icon: FontAwesomeIcons.youtube,
      name: 'YouTube',
      url: 'https://www.youtube.com/c/CHEDRegionalOfficeXI',
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

  // Method to launch URLs
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

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
              _launchURL(socials[index].url);
            },
          );
        },
      ),
    );
  }
}

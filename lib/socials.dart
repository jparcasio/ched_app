import 'package:chedapplication/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:chedapplication/map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './socials.dart';

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
       bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF32A2EA),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'FAQs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Socials',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        currentIndex: 4,
        onTap: (idx) {
          if (idx == 0) {
           Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MainScreen();
              }));
            // Check if already in main_menu.dart        
          } else if (idx == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MapScreen();
            }));
          } else if (idx == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SocialsPage();
            }));
          }
        },
      ),
    );
  }
}
class BgPainter extends CustomPainter {
  final Color color;

  const BgPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = color;
    path = Path();
    path.lineTo(size.width, 0);
    path.cubicTo(size.width, 0, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, size.height, 0, size.height);
    path.cubicTo(size.width * 0.11, size.height * 0.65, size.width * 0.29,
        size.height * 0.42, size.width / 2, size.height * 0.42);
    path.cubicTo(size.width * 0.71, size.height * 0.42, size.width * 0.89,
        size.height * 0.65, size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, 0, size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

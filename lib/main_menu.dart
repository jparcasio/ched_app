import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chedapplication/article.dart';
import 'package:chedapplication/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chedapplication/map.dart';

class CarouselItem {
  final String title;
  final String body;

  const CarouselItem({required this.title, required this.body});

}

class MenuItem {
  final String title;
  final IconData icon;
  final String description;
  final String? url;
  final void Function(BuildContext context)? onTap;

  const MenuItem(
      {required this.title,
      required this.icon,
      required this.description,
      this.url,
      this.onTap});
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  final List<CarouselItem> carouselItems = [
    CarouselItem(
      title: 'Title 1',
      // long text to test the "see more" feature
      body: 'Body 1' * 100,
    ),
    CarouselItem(
      title: 'Title 2',
      body: 'Body 2',
    ),
    CarouselItem(
      title: 'Title 3',
      body: 'Body 3',
    ),
  ];
  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Map',
      icon: Icons.map,
      description: 'View the map',
      onTap: (context) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MapScreen();
        }));
      },
    ),
    MenuItem(
      title: 'Favorites',
      icon: Icons.favorite,
      description: 'View your favorites',
      url: '/favorites',
    ),
    MenuItem(
      title: 'Settings',
      icon: Icons.settings,
      description: 'Adjust app settings',
      url: '/settings',
    ),
    MenuItem(
      title: 'Notifications',
      icon: Icons.notifications,
      description: 'View notifications',
      url: '/notifications',
    ),
    MenuItem(
      title: 'Profile',
      icon: Icons.person,
      description: 'View your profile',
      url: '/profile',
    ),
    MenuItem(
      title: 'Search',
      icon: Icons.search,
      description: 'Search for items',
      url: '/search',
    ),
    MenuItem(
      title: 'Help',
      icon: Icons.help,
      description: 'Get help with the app',
      url: '/help',
    ),
    MenuItem(
      title: 'Info',
      icon: Icons.info,
      description: 'View app information',
      url: '/info',
    ),
  ];

  String _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('CHED REGION XI'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFF252872),
          child: ListView(
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      FontAwesomeIcons.youtube,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      FontAwesomeIcons.yahoo,
                      color: Colors.white,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              for (var i = 0; i < menuItems.length; i++)
                ListTile(
                  title: Text(
                    menuItems[i].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    menuItems[i].icon,
                    color: Color(0xFF252872),
                  ),
                  onTap: () {
                    if (menuItems[i].onTap != null) {
                      menuItems[i].onTap!(context);
                    } else {
                      // launch the URL
                    }

                    Navigator.pop(context);

                    if (i == 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MapScreen();
                      }));
                    }
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            items: carouselItems.map(
              (item) => Container(
                height: 200, // Set the height of the container
                width: 500,
                margin: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Color(0xFF252872),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ArticleScreen();
                    }));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        item.body.substring(0, min(100, item.body.length)) + ( item.body.length > 100 ? '... See more' : '' ),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  )
                ),
              ),
            ).toList(),
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                if (index < menuItems.length) {
                  return InkWell(
                    onLongPress: () {
                      _showIconDetails(context, menuItems[index]);
                    },
                    onTap: () {
                      if (menuItems[index].onTap != null) {
                        menuItems[index].onTap!(context);
                      } else {
                        // launch the URL
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(menuItems[index].icon,
                            size: 50, color: Color(0xFF252872)),
                        SizedBox(height: 10),
                        Text(
                          menuItems[index].title,
                          style: TextStyle(color: Color(0xFF252872)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showIconDetails(BuildContext context, MenuItem menuItem) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(menuItem.icon, size: 50, color: Color(0xFF252872)),
                SizedBox(height: 10),
                Text(
                  menuItem.title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252872)),
                ),
                SizedBox(height: 10),
                Text(
                  menuItem.description,
                  style: TextStyle(fontSize: 16, color: Color(0xFF252872)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

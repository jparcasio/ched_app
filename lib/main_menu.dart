import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chedapplication/article.dart';
import 'package:chedapplication/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chedapplication/map.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:chedapplication/article.dart';
import 'package:chedapplication/socials.dart';

class LatestFAQItem extends StatefulWidget {
  const LatestFAQItem();

  @override
  State<LatestFAQItem> createState() => _LatestFAQItemState();
}

class _LatestFAQItemState extends State<LatestFAQItem> {
  Future<RecordModel> _loadData() async {
    final result = await pb.collection('faqs').getList(perPage: 1, skipTotal: false, sort: 'created');
    if (result.items.isEmpty) {
      throw Exception('No FAQs found.');
    }
    return result.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _loadData(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }

      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'FAQs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252872),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              snapshot.hasData ? 'Q: ${snapshot.data?.data['question']}' : snapshot.error.toString(),                     
                style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF252872),
              ),
            ),
            SizedBox(height: 1),
            TextButton(
              onPressed: () {
                // TODO: Handle FAQ button tap
              },
              child: const Text(
                'More FAQs',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CarouselItem {
  final String title;
  final String body;

  const CarouselItem({required this.title, required this.body});
}

class MenuItem {
  final String title;
  final IconData? icon;
  final Widget? widget;
  final String description;
  final String? url;
  final void Function(BuildContext context)? onTap;

  const MenuItem(
      {required this.title,
      required this.description,
      this.icon,
      this.widget,
      this.url,
      this.onTap});
}

class PrimaryMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const PrimaryMenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onTap,
    this.color = const Color.fromARGB(255, 41, 181, 255),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: color,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: SizedBox.fromSize(
                size: const Size(double.infinity, 200),
                child: child
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      )
                    ],
                  ),
                )
              ),
            )
          ],
        )
      )
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  final List<CarouselItem> carouselItems = [
    CarouselItem(
      title: 'Sample Title 1',
      // long text to test the "see more" feature
      body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet metus vel justo porttitor finibus ac et dui. Maecenas sit amet metus auctor, dictum mauris ac, sodales mi. Cras pretium velit eu nunc lacinia, nec mattis nulla dapibus. Nulla facilisi. Sed sit amet purus velit. Vivamus ut mi nec dui pharetra tincidunt eget vitae libero.',
    ),
    CarouselItem(
      title: 'Sample Title 2',
      body: 'Integer non bibendum mi. Fusce vel felis vitae mi dictum tempus non vitae ligula. Nam congue arcu at velit blandit, sit amet vestibulum magna eleifend. Vivamus dictum odio sit amet sapien pulvinar, non consectetur libero faucibus. Ut sit amet feugiat turpis. Phasellus at velit eu odio convallis laoreet.',
    ),
    CarouselItem(
      title: 'Sample Title 3',
      body: 'Curabitur nec ipsum vel ipsum congue varius. Nam maximus, justo non posuere consectetur, purus arcu suscipit nunc, nec gravida sem nulla id risus. Proin vel elit a turpis malesuada fermentum. Sed non arcu aliquet, aliquam nulla nec, suscipit leo. Sed tincidunt blandit odio, vitae cursus sem posuere a. Sed quis ligula nec leo ullamcorper ultricies nec id ipsum.',
    ),
  ];
    final List<MenuItem> menuItems = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Expanded(child: Image.asset('images/bg.fluts.png', fit: BoxFit.cover)),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 100),
            painter: BgPainter(color: Color(0xFF32A2EA)),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 150),
                CarouselSlider(
                  items: carouselItems.map(
                    (item) =>Container(
                      height: 100,
                      width: 600,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Color(0xFF32A2EA), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), 
                          ),
                        ],
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
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF252872)),
                            ),
                            SizedBox(height: 10),
                            Text(
                              item.body.substring(0, min(50, item.body.length)) + ( item.body.length > 50 ? '... See more' : '' ),
                              style: TextStyle(fontSize: 18, color: Color(0xFF252872)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ).toList(),
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      // maps
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: PrimaryMenuItem(
                            title: 'Map',
                            subtitle: 'View the map',
                            child: Image.asset('images/map.jpg', fit: BoxFit.fill),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return MapScreen();
                              }));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: PrimaryMenuItem(
                            title: 'Special Orders',
                            subtitle: 'View special orders',
                            color: Color.fromARGB(255, 239, 204, 78),
                            textColor: Colors.black,
                            child: Image.asset('images/map.jpg', fit: BoxFit.fill),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return MapScreen();
                              }));
                            },
                          ),
                        ),
                      ),
                    ],
                  )),

                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index];

                    return InkWell(
                      onLongPress: () {
                        _showIconDetails(context, menuItem);
                      },
                      onTap: () {
                        if (menuItem.onTap != null) {
                          menuItem.onTap!(context);
                        } else {
                          // launch the URL
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          menuItem.icon != null 
                            ? Icon(menuItem.icon,
                              size: 70, color: Color(0xFF32A2EA)
                            ) : menuItem.widget != null 
                            ? menuItem.widget! : Container(),
                          SizedBox(height: 10),
                          Text(
                            menuItem.title,
                            style: TextStyle(color: Color(0xFF252872)),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          LatestFAQItem()
        ],
      )),
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
                Icon(menuItem.icon, size: 50, color: Color(0xFF32A2EA)),
                SizedBox(height: 10),
                Text(
                  menuItem.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF32A2EA),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  menuItem.description,
                  style: TextStyle(fontSize: 16, color: Color(0xFF32A2EA)),
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

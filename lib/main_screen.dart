import 'package:chedapplication/faq.dart';
import 'package:chedapplication/main_menu.dart';
import 'package:chedapplication/map.dart';
import 'package:chedapplication/socials.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreenItem {
  final String title;
  final IconData icon;
  final Widget widget;

  const MainScreenItem({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MainScreenItem> menuItems = [
    MainScreenItem(
      title: 'Home',
      icon: Icons.home,
      widget: HomeScreen(),
    ),
    const MainScreenItem(
      title: 'Map',
      icon: Icons.map,
      widget: MapScreen(),
    ),
    MainScreenItem(
      title: 'News',
      icon: Icons.article,
      widget: Container(),
    ),
    MainScreenItem(
      title: 'FAQs',
      icon: Icons.question_answer,
      widget: FaqScreen(),
    ),
    MainScreenItem(
      title: 'Socials',
      icon: Icons.group,
      widget: SocialsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: menuItems.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: menuItems.map((e) => e.widget).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF32A2EA),
        items: menuItems.map((e) {
          return BottomNavigationBarItem(
            icon: Icon(e.icon),
            label: e.title,
          );
        }).toList(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        currentIndex: _tabController.index,
        onTap: (value) {
          setState(() {
            _tabController.animateTo(value);
          });
        },
      ),
    );
  }
}


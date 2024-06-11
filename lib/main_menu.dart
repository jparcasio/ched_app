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
import 'package:chedapplication/faq.dart';
import 'package:url_launcher/url_launcher.dart';


class LatestFAQItem extends StatefulWidget {
  const LatestFAQItem();

  @override
  State<LatestFAQItem> createState() => _LatestFAQItemState();
}

class _LatestFAQItemState extends State<LatestFAQItem> {
  Future<RecordModel> _loadData() async {
    final result = await pb
        .collection('faqs')
        .getList(perPage: 1, skipTotal: false, sort: 'created');
    if (result.items.isEmpty) {
      throw Exception('No FAQs found.');
    }
    return result.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                snapshot.hasData
                    ? 'Q: ${snapshot.data?.data['question']}'
                    : snapshot.error.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF252872),
                ),
              ),
              SizedBox(height: 1),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FaqScreen();
                  }));
                },
                child: const Text(
                  'More FAQs',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
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

  const MenuItem({
    required this.title,
    required this.description,
    this.icon,
    this.widget,
    this.url,
    this.onTap,
  });
}

class PrimaryMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback onLongPress; // Add this line
  final Color color;
  final Color textColor;

  const PrimaryMenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onTap,
    required this.onLongPress, // Add this line
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
                child: child,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress, // Add this line
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
      title: 'Vision',
      body:
          'National: Philippine higher education system that is equitable and producing locally responsive, innovative, and globally competitive graduates and lifelong learners. \n\n'
          'Regional Office XI: A Regional Office that leads with innovative solutions toward the welfare of the stakeholders and the operational sustainability, resiliency and competitiveness of higher education institutions.',
    ),
    CarouselItem(
      title: 'Mission',
      body:
          'National: To promote equitable access and ensure quality and relevance of higher education institutions and their programs. \n\n'
          'Regional Office XI: As an innovative solution-driven Regional Office, commits to: foster inclusive innovation; promote local and global excellence and competitiveness; develop and implement accessible, equitable, relevant and responsive programs and services; engage in strategic alliances; and strengthen transparency and good governance.',
    ),
    CarouselItem(
      title: 'Core Values',
      body: 'Competence \n\n'
          'Holistic \n\n'
          'Enabling \n\n'
          'Diligence \n\n'
          'Resilience \n\n'
          'Objectivity \n\n'
          'eXcellence \n\n'
          'Integrity',
    ),
    CarouselItem(
      title: 'Mandate',
      body:
          'Given the national government’s commitment to transformational leadership that puts education as the central strategy for investing in the Filipino people, reducing poverty, and building national competitiveness and pursuant to Republic Act 7722, CHED shall: \n\n'
          ' A. Promote relevant and quality higher education (i.e. higher education institutions and programs are at par with international standards and graduates and professionals are highly competent and recognized in the international arena);\n\n'
          ' B. Ensure that quality higher education is accessible to all who seek it particularly those who may not be able to afford it; \n\n'
          ' C. Guarantee and protect academic freedom for continuing intellectual growth, advancement of learning and research, development of responsible and effective leadership, education of high-level professionals, and enrichment of historical and cultural heritages; and;\n\n'
          ' D. Commit to moral ascendancy that eradicates corrupt practices, institutionalizes transparency and accountability and encourages participatory governance in the Commission and the sub-sector.\n\n',    
    ),
  ];

  // final List<MenuItem> menuItems = [
  //   MenuItem(
  //     title: 'Favorites',
  //     icon: Icons.star,
  //     description: 'View your favorites',
  //     url: 'https://www.facebook.com',
  //   ),
  //   MenuItem(
  //     title: 'Settings',
  //     icon: Icons.settings,
  //     description: 'Adjust app settings',
  //     url: '/settings',
  //   ),
  //   MenuItem(
  //     title: 'Notifications',
  //     icon: Icons.notifications,
  //     description: 'View notifications',
  //     url: '/notifications',
  //   ),
  //   MenuItem(
  //     title: 'Profile',
  //     icon: Icons.person,
  //     description: 'View your profile',
  //     url: '/profile',
  //   ),
  //   MenuItem(
  //     title: 'Search',
  //     icon: Icons.search,
  //     description: 'Search for items',
  //     url: '/search',
  //   ),
  //   MenuItem(
  //     title: 'Help',
  //     icon: Icons.help,
  //     description: 'Get help with the app',
  //     url: '/help',
  //   ),
  //   MenuItem(
  //     title: 'Info',
  //     icon: Icons.info,
  //     description: 'View app information',
  //     url: '/info',
  //   ),
  // ];
void _showPrimaryMenuItemDetails(String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showCarouselItemDetails(CarouselItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.title),
          content: SingleChildScrollView(
            child: Text(item.body),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 100),
              painter: BgPainter(color: Color(0xFF32A2EA)),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  CarouselSlider(
                    items: carouselItems.map((item) {
                      return Container(
                        height: 50,
                        width: 600,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xFF32A2EA), width: 1.0),
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
                            _showCarouselItemDetails(item);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF252872),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Text(
                              //   item.body.substring(0, min(50, item.body.length)) + (item.body.length > 50 ? '... See more' : ''),
                              //   style: TextStyle(
                              //     fontSize: 18,
                              //     color: Color(0xFF252872),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 80.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252872),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: GridView.count(
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 20, // spacing between columns
                      mainAxisSpacing: 20, // spacing between rows
                      shrinkWrap: true, // Shrink to fit the content
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling if inside a ScrollView
                      children: [
                        // Map item
                        PrimaryMenuItem(
                          title: "HEIs' Map",
                          subtitle: 'View the map',
                          child:
                              Image.asset('images/map.jpg', fit: BoxFit.fill),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MapScreen();
                            }));
                          },
                          onLongPress: () {
                            _showPrimaryMenuItemDetails('Map', 'View the Map of the Region XI Schools and their offered programs');
                          },
                        ),
                        // HEI Portal item
                        PrimaryMenuItem(
                          title: 'HEI Portal',
                          subtitle: 'View HEI Portal',
                          color: Color.fromARGB(255, 240, 40, 66),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child:
                              Image.asset('images/hei_portal.jpg', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://scholarship.chedroxi.com');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('HEI Portal', 'View the Higher Education Institution Portal');
                          },
                        ),  
                      ],
                    ),
                  ),                    
                        Text(
                    '\nOnline Services, Scholarships, and Grants\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252872),
                    ),
                  ),

                        Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: GridView.count(
                      crossAxisCount: 3, // 2 columns
                      crossAxisSpacing: 20, // spacing between columns
                      mainAxisSpacing: 20, // spacing between rows
                      shrinkWrap: true, // Shrink to fit the content
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling if inside a ScrollView
                      children: [
                        // Special Orders Application item
                        PrimaryMenuItem(
                          title: 'SO Application',
                          subtitle:
                              'View SO Applcation',
                          color: Color.fromARGB(255, 235, 205, 99),
                          textColor: Colors.black,
                          child:
                              Image.asset('images/so3.png', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://so.chedroxi.com');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('Special Order Application', 'View the Special Order Application for the Higher Education Institutions');
                          },
                        ),
                        // StuFAPs item
                        PrimaryMenuItem(
                          title: 'StuFAPs',
                          subtitle:
                              'View StuFAPs',
                          color: Color.fromARGB(255, 235, 205, 99),
                          textColor: Colors.black,
                          child:
                              Image.asset('images/stufaps.jpg', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://stufaps.chedroxi.com');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('StuFAPs', 'View the CHED Scholarship Student Financial Assistance Programs (StuFAPS). A CHED Scholarship can help cover your tuition, books, or connectivity expenses. The Commission of Higher Education Merit Scholarship Program helps academically talented students afford higher education. ');
                          },
                        ),
                        // UniFAST item
                        PrimaryMenuItem(
                          title: 'UniFAST',
                          subtitle:
                              'View UniFAST',
                          color: Color.fromARGB(255, 130, 174, 240),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child:
                              Image.asset('images/unifast.png', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL(
                                'https://scholarship2.chedroxi.com');
                          },
                          onLongPress: () {
                            _showPrimaryMenuItemDetails('UniFAST', 'View the Unified Student Financial Assistance System for Tertiary Education. UniFAST is an attached agency of CHED and the primary implementer of Free Higher Education (FHE) and the Tertiary Education Subsidy (TES) program under Republic Act 10931 or the Universal Access to Quality Tertiary Education law.');
                          },
                        ),
                        // SIKAP item
                        PrimaryMenuItem(
                          title: 'SIKAP',
                          subtitle:
                              'View SIKAP',
                          color: Color.fromARGB(255, 143, 197, 180),
                          textColor: Colors.black,
                          child:
                              Image.asset('images/sikap.jpg', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL(
                                'https://scholarship2.chedroxi.com');
                          },
                          onLongPress: () {
                            _showPrimaryMenuItemDetails('SIKAP', 'Scholarships for Instructors Knowledge Advancement Program (SIKAP) provides opportunities for Higher Education Institution (HEI) teaching and non-teaching personnel, or former HEI teaching or non-teaching personnel seeking advanced studies in identified universities and colleges in the Philippines.');
                          },
                        ),
                        // CAV Application item
                        PrimaryMenuItem(
                          title: 'CAV Application',
                          subtitle:
                              'View CAV Application',
                          color: Color.fromARGB(255, 203, 152, 199),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child:
                              Image.asset('images/cav.jpg', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://cav.chedroxi.com');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('CAV Application', 'Certification, Authentication, and Verification (CAV) is the official and formal processes and acts of checking, reviewing, and certifying the genuineness and veracity of available academic records of a learner duly performed by the Commission on Higher Education and the Department of Foreign Affairs.');
                          },
                        ),
                        // CSM Application item
                        PrimaryMenuItem(
                          title: 'CSM Application',
                          subtitle: 'Client Satisfaction \n    Measurement',
                          color: Color.fromARGB(255, 66, 83, 178),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child:
                              Image.asset('images/csm.jpg', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://csm.chedroxi.com');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('CSM Application', 'The CHED Merit Scholarship Program (CMSP) is a government-funded scholarship aimed at supporting academically talented students, especially those who belong to the following special groups: \n Underprivileged and homeless citizens (RA 7279) \n Persons with Disability (RA 7277) and \n Solo parents and/or their dependents (RA 8371)');
                          },
                        ),
                        // Queueing Application item
                        PrimaryMenuItem(
                          title: 'Queueing \nApplication',
                          subtitle: 'Clientele Queueing',
                          color: Color.fromARGB(255, 241, 150, 107),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child:
                              Image.asset('images/queueing.jpg', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://cqs.chedroxi.com');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('Queueing Application', 'This service refers to the processing of applications for issuance of Government Authorization suc as Permit/Recognition and COPC to HEIs with intention to operate Graduate programs, Medicine Dentistry, Nursing Engineering and programs without PSGs.');
                          },
                        ),
                        PrimaryMenuItem(
                          title: 'Citizens Charter',
                          subtitle: 'View Citizens Charter',
                          color: Color.fromARGB(255, 33, 167, 60),
                          textColor: Color.fromARGB(255, 255, 255, 255),
                          child:
                              Image.asset('images/czc.png', fit: BoxFit.fill),
                          onTap: () async {
                            await _launchURL('https://ro11.ched.gov.ph/citizens-charter/#citizens-charter/1/');
                          },
                           onLongPress: () {
                            _showPrimaryMenuItemDetails('Citizens Chapter', 'View the Citizens Charter of the Commission on Higher Education Regional Office XI');
                          },
                        ),
                      ],
                    ),
                    
                  ),
                  
                  // Text(
                  //   'Other Services',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xFF252872),
                  //   ),
                  // ),
                  // GridView.builder(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3,
                  //   ),
                  //   itemCount: menuItems.length,
                  //   itemBuilder: (context, index) {
                  //     final menuItem = menuItems[index];

                  //     return InkWell(
                  //       onLongPress: () {
                  //         _showIconDetails(context, menuItem);
                  //       },
                  //       onTap: () async {
                  //         if (menuItem.onTap != null) {
                  //           menuItem.onTap!(context);
                  //         } else if (menuItem.url != null) {
                  //           await _launchURL(menuItem.url!);
                  //         }
                  //       },
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           menuItem.icon != null
                  //               ? Icon(
                  //                   menuItem.icon,
                  //                   size: 70,
                  //                   color: Color(0xFF32A2EA),
                  //                 )
                  //               : menuItem.widget != null
                  //                   ? menuItem.widget!
                  //                   : Container(),
                  //           SizedBox(height: 10),
                  //           Text(
                  //             menuItem.title,
                  //             style: TextStyle(color: Color(0xFF252872)),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            LatestFAQItem(),
          ],
        ),
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

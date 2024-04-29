import 'package:chedapplication/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketbase/pocketbase.dart';

class SchoolLocation {
  final String name;
  final LatLng location;
  final String offeredPrograms;

  const SchoolLocation({
    required this.name,
    required this.location,
    required this.offeredPrograms,
  });

  factory SchoolLocation.fromRecord(RecordModel record) {
    return SchoolLocation(
      name: record.getStringValue('name'),
      location:
          LatLng(record.getDoubleValue('lat'), record.getDoubleValue('long')),
      offeredPrograms: record.getStringValue('offered_programs'),
    );
  }
}

class SchoolInformationSheet extends StatefulWidget {
  final SchoolLocation? school;

  const SchoolInformationSheet({required this.school, super.key});

  @override
  State<SchoolInformationSheet> createState() => _SchoolInformationSheetState();
}

class _SchoolInformationSheetState extends State<SchoolInformationSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);

    if (widget.school != null) {
      _expand();
    } else {
      _hide();
    }
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => DraggableScrollableSheet(
              key: _sheet,
              initialChildSize: 0.5,
              minChildSize: 0,
              maxChildSize: 1,
              expand: true,
              snap: true,
              snapSizes: [
                0,
                60 / constraints.maxHeight,
                0.5,
              ],
              controller: _controller,
              builder: (context, scrollController) {
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(0, -5))
                    ]
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.drag_handle),
                          ],
                        ),
                      ),
                      if (widget.school != null) SliverToBoxAdapter(
                        child: Text(
                          widget.school?.name ?? '',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ),
                      // SliverToBoxAdapter(
                      //   child: ListView(
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     children: [
                            // horizontal grid with 1 picture and 4 picture remaining
                            // StaggeredGrid.count(
                            //   axisDirection: AxisDirection.right,
                            //   crossAxisCount: 4,
                            //   mainAxisSpacing: 4,
                            //   crossAxisSpacing: 4,
                            //   children: [
                            //     StaggeredGridTile.count(
                            //       crossAxisCellCount: 2,
                            //       mainAxisCellCount: 2,
                            //       child: Container(
                            //         color: Colors.green,
                            //       ),
                            //     ),
                            //     StaggeredGridTile.count(
                            //       crossAxisCellCount: 2,
                            //       mainAxisCellCount: 1,
                            //       child: Container(
                            //         color: Colors.green,
                            //       ),
                            //     ),
                            //     StaggeredGridTile.count(
                            //       crossAxisCellCount: 1,
                            //       mainAxisCellCount: 1,
                            //       child: Container(
                            //         color: Colors.green,
                            //       ),
                            //     ),
                            //     StaggeredGridTile.count(
                            //       crossAxisCellCount: 1,
                            //       mainAxisCellCount: 1,
                            //       child: Container(
                            //         color: Colors.green,
                            //       ),
                            //     ),
                            //     StaggeredGridTile.count(
                            //       crossAxisCellCount: 4,
                            //       mainAxisCellCount: 2,
                            //       child: Container(
                            //         color: Colors.green,
                            //       ),
                            //     ),
                            //     StaggeredGridTile.count(
                            //       crossAxisCellCount: 4,
                            //       mainAxisCellCount: 2,
                            //       child: Container(
                            //         color: Colors.green,
                            //       ),
                            //     )
                            //   ],
                            // ),
                      //       Container(
                      //         height: 100,
                      //         width: 100,
                      //         color: Colors.green,
                      //         child: Image.asset('images/pin.png'),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      if (widget.school != null) SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text("Offered Programs",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                 widget.school!.offeredPrograms.isNotEmpty
                                    ? HtmlWidget(
                                        widget.school!.offeredPrograms,
                                      )
                                    : const Text('No programs offered'),
                              ],
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                );
              },
            ));
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  List<SchoolLocation> schools = [];

  final mapController = MapController();

  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  // https://github.com/fleaflet/flutter_map/blob/f558e43b2611046a533a0bf035bbf86a44c2f3bf/example/lib/pages/animated_map_controller.dart
  void _animatedMapMove(LatLng destLocation, double destZoom,
      {double? rotation}) {
    // use the value from the map controller if the value is not provided
    rotation ??= mapController.rotation;

    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    final rotationTween =
        Tween<double>(begin: mapController.rotation, end: rotation);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.moveAndRotate(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        rotationTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  void initState() {
    super.initState();

    pb.collection('schools').getFullList().then((results) {
      setState(() {
        schools = results.map(SchoolLocation.fromRecord).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      FlutterMap(
        mapController: mapController,
        options: MapOptions(
            center: LatLng(7.0699375, 125.59998569691578),
            zoom: 14,
            onTap: (tapPosition, point) {
              _animatedMapMove(mapController.center, 14);
            }),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          for (final school in schools)
            MarkerLayer(
              markers: [
                Marker(
                  point: school.location,
                  width: 40,
                  height: 40,
                  builder: (context) {
                    return GestureDetector(
                      child: Image.asset('images/pin.png'),
                      onTap: () async {
                        final loc = school.location;
                        final center =
                            LatLng(loc.latitude - 0.001, loc.longitude);
                        _animatedMapMove(center, 18.0, rotation: 0.0);

                        // show bottom sheet

                        _animatedMapMove(loc, 18.0, rotation: 0);
                      },
                    );
                  },
                ),
              ],
            ),
          // RichAttributionWidget(
          //   attributions: [
          //     TextSourceAttribution(
          //       'OpenStreetMap contributors',
          //       onTap: () {},
          //     ),
          //   ],
          // ),
        ],
      ),
      
      // SchoolInformationSheet(school: schools.isNotEmpty ? schools.first : null),
    ]));
  }
}

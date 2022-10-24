import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import '../../config/base.dart';
import '../../config/constants.dart';
import 'home/home.dart';
import 'home/incidentreport.dart';
import 'notifications.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends Base<BottomNav> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const IncidentReport(
      type: "Other",
    ),
    const IncidentReport(
      type: "Pothole",
    ),
    const IncidentReport(
      type: "Accident",
    ),
    const IncidentReport(
      type: "Traffic",
    ),
    const NotificationsPage(),
  ];
  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();
  bool? feedData = false;
  late StreamSubscription<bool> keyboardSubscription;
  bool isvisible = false;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      setState(() {
        isvisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(child: _children[_currentIndex]),
            feedData!
                ? Positioned.fill(
                    child: GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      borderRadius: 20,
                      blur: .5,
                      alignment: Alignment.bottomCenter,
                      border: .5,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFffffff).withOpacity(0.7),
                            const Color(0xFFFFFFFF).withOpacity(0.4),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(0.5),
                          const Color((0xFFFFFFFF)).withOpacity(0.5),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        floatingActionButton: isvisible
            ? Container()
            : CircularMenu(
                // menu alignment
                alignment: Alignment.bottomCenter,
                // menu radius
                radius: 100,
                // widget in the background holds actual page content
                backgroundWidget: Container(),
                // global key to control the animation anywhere in the code.
                key: key,
                // animation duration
                animationDuration: Duration(milliseconds: 500),
                // animation curve in forward
                curve: Curves.bounceOut,
                toggleButtonAnimatedIconData: AnimatedIcons.add_event,
                // animation curve in reverse
                reverseCurve: Curves.fastOutSlowIn,
                // first item angle
                startingAngleInRadian: 1.1 * pi,
                // last item angle
                endingAngleInRadian: 1.9 * pi,
                // toggle button callback
                toggleButtonOnPressed: () {
                  setState(() {
                    feedData = !feedData!;
                  });
                },
                // toggle button appearance properties
                toggleButtonColor: const Color.fromRGBO(34, 112, 59, 1),
                toggleButtonBoxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                  ),
                ],
                toggleButtonIconColor: Colors.white,
                toggleButtonMargin: 10.0,
                toggleButtonPadding: 10.0,
                toggleButtonSize: 40.0,
                items: [
                  CircularMenuItem(
                    // menu item callback
                    onTap: () {
                      setState(() {
                        _currentIndex = 4;
                        feedData = !feedData!;
                      });
                      key.currentState!.reverseAnimation();
                    },
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                    // menu item appearance properties
                    icon: Icons.traffic,
                    color: Colors.white,
                    iconColor: const Color.fromRGBO(34, 112, 59, 1),
                    iconSize: 30.0,
                    margin: 10.0,
                    padding: 10.0,
                    enableBadge: true,
                    badgeLabel: '`  Traffic  `',
                    badgeTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      backgroundColor: Colors.black,
                    ),
                    badgeRadius: 30,
                    badgeBottomOffet: -30,
                    badgeColor: Colors.transparent,
                    // when 'animatedIcon' is passed,above 'icon' will be ignored
                  ),
                  CircularMenuItem(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                        ),
                      ],
                      color: Colors.white,
                      enableBadge: true,
                      badgeLabel: '`  Accident  `',
                      badgeTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        backgroundColor: Color.fromRGBO(34, 112, 59, 1),
                      ),
                      badgeRadius: 30,
                      badgeBottomOffet: -30,
                      badgeColor: Colors.transparent,
                      icon: Icons.car_repair_sharp,
                      iconColor: const Color.fromRGBO(34, 112, 59, 1),
                      onTap: () {
                        setState(() {
                          _currentIndex = 3;
                          feedData = !feedData!;
                        });
                        key.currentState!.reverseAnimation();
                      }),
                  CircularMenuItem(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                        ),
                      ],
                      color: Colors.white,
                      enableBadge: true,
                      badgeLabel: '`  Pothole  `',
                      badgeTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        backgroundColor: Color.fromRGBO(34, 112, 59, 1),
                      ),
                      badgeRadius: 30,
                      badgeBottomOffet: -30,
                      badgeColor: Colors.transparent,
                      icon: Icons.edit_road,
                      iconColor: const Color.fromRGBO(34, 112, 59, 1),
                      onTap: () {
                        setState(() {
                          _currentIndex = 2;
                          feedData = !feedData!;
                        });
                        key.currentState!.reverseAnimation();
                      }),
                  CircularMenuItem(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                        ),
                      ],
                      color: Colors.white,
                      enableBadge: true,
                      badgeLabel: '`  Other  `',
                      badgeTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        backgroundColor: Colors.black,
                      ),
                      badgeRadius: 30,
                      badgeBottomOffet: -30,
                      badgeColor: Colors.transparent,
                      icon: Icons.escalator,
                      iconColor: const Color.fromRGBO(34, 112, 59, 1),
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                          feedData = !feedData!;
                        });
                        key.currentState!.reverseAnimation();
                      }),
                ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * .9,
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 5),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(34, 112, 59, 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: _currentIndex == 0 ? Colors.white : Colors.white60,
                    ),
                    ReuseText(
                      text: 'HOME',
                      fWeight: FontWeight.w400,
                      size: 8,
                      color: _currentIndex == 0 ? Colors.white : Colors.white60,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 5;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      color: _currentIndex == 1 ? Colors.white : Colors.white60,
                    ),
                    ReuseText(
                      text: 'NOTIFICATIONS',
                      fWeight: FontWeight.w400,
                      size: 8,
                      color: _currentIndex == 1 ? Colors.white : Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

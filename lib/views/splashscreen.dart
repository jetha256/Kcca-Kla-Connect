import 'package:flutter/material.dart';
import 'package:kcca_kla_connect/views/botomnav.dart';
import 'package:kcca_kla_connect/views/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    opacity = Tween<double>(begin: 0.8, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    //set status to new user if null
    if (prefs.getBool('firstimeuser') == null) {
      prefs.setBool('firstimeuser', true);
    }
    // Get user ID
    String? checkUserName = prefs.getString('username');
    String? checkUserId = prefs.getString('userid');

    print(
        "+++++++ THE USERNAME & USERID IS $checkUserName & $checkUserId ++++++++++++++++++");
    if ((checkUserName != null && checkUserName != '')
        //  &&        _fireBaseSignedIn
        ) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNav()));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => WelcomePage()));
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage(
          //       'assets/images/bg.jpg',
          //     ),
          //     fit: BoxFit.cover)
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 220,
                    height: 220,
                    alignment: Alignment.center,
                    child: Opacity(
                        opacity: opacity.value,
                        child: Image.asset('assets/images/kcclogo.png')),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          child: const Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   // decoration: BoxDecoration(
                      //   //     border: Border.all(
                      //   //         color: Colors
                      //   //             .transparent), //color is transparent so that it does not blend with the actual color specified
                      //   //     borderRadius:
                      //   //         const BorderRadius.all(Radius.circular(10.0)),
                      //   //     color: Colors.black.withOpacity(
                      //   //         0.3) // Specifies the background color and the opacity
                      //   //     ),
                      //   width: 150,
                      //   height: 30,
                      //   alignment: Alignment.center,
                      //   child: Opacity(
                      //       opacity: opacity.value,
                      //       child: Image.asset('assets/images/logo_dark.jpeg')),
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

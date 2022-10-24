import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:kcca_kla_connect/views/auth/register.dart';
import 'package:kcca_kla_connect/views/auth/signin.dart';
import 'package:kcca_kla_connect/views/divisions.dart';
import 'package:kcca_kla_connect/views/links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../reusables/headedinputpic.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends Base<WelcomePage> {
  bool? isRegister;
  TextEditingController? frequent;
  get2() async {
    const url = 'https://play.google.com/store/search?q=weyonje&c=apps';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  get1() async {
    const url = 'https://play.google.com/store/apps/details?id=com.kcca.gis';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  get3() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.manecommunityapp';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  get4() async {
    const url = 'https://play.google.com/store/search?q=kcca+fc+app&c=apps';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    isRegister = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/kampalaroad.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .85,
                borderRadius: 20,
                blur: .3,
                alignment: Alignment.bottomCenter,
                border: 2,
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
                    const Color(0xFFffffff),
                    const Color((0xFFFFFFFF)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/kcclogo.png',
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            get1();
                          },
                          child: HeadedInputCard(
                            imageString: 'assets/images/KCCA.png',
                            iconcolor: Colors.black,
                            text: 'KCCA GCIS',
                            size: 9,
                            fWeight: FontWeight.w400,
                            controller: frequent,
                            color: Colors.black,
                            textt: 'City Maps and Navigation',
                            textInputType: TextInputType.text,
                            action: TextInputAction.next,
                            hintcolor: Colors.grey[500],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            get2();
                          },
                          child: HeadedInputCard(
                            imageString: 'assets/images/Weyonje.png',
                            iconcolor: Colors.black,
                            text: 'Pit latrines emptying services',
                            size: 9,
                            fWeight: FontWeight.w400,
                            controller: frequent,
                            color: Colors.black,
                            textt: '',
                            textInputType: TextInputType.text,
                            action: TextInputAction.next,
                            hintcolor: Colors.grey[500],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            get3();
                          },
                          child: HeadedInputCard(
                            imageString: 'assets/images/ambulance.png',
                            iconcolor: Colors.black,
                            text: 'Kampala Ambulance Service',
                            size: 8,
                            fWeight: FontWeight.w400,
                            controller: frequent,
                            color: Colors.black,
                            textt: 'Get the nearest available ambulance',
                            textInputType: TextInputType.text,
                            action: TextInputAction.next,
                            hintcolor: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            get4();
                            // await launchUrl(Uri.parse(
                            //     'https://play.google.com/store/search?q=kcca+fc+app&c=apps'));
                          },
                          child: HeadedInputCard(
                            imageString: 'assets/images/kccafc.png',
                            iconcolor: Colors.black,
                            text: 'The official app of KCCA FC',
                            size: 9,
                            fWeight: FontWeight.w400,
                            controller: frequent,
                            color: Colors.black,
                            textt: '',
                            textInputType: TextInputType.text,
                            action: TextInputAction.next,
                            hintcolor: Colors.grey[500],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // get4();
                            // await launchUrl(Uri.parse(
                            //     'https://play.google.com/store/search?q=kcca+fc+app&c=apps'));
                            push(const AccountLinks());
                          },
                          child: HeadedInputCard(
                            imageString: 'assets/images/Vector1.png',
                            iconcolor: Colors.black,
                            text: 'Contact us',
                            size: 9,
                            fWeight: FontWeight.w400,
                            controller: frequent,
                            color: Colors.black,
                            textt: 'Various ways to contact us',
                            textInputType: TextInputType.text,
                            action: TextInputAction.next,
                            hintcolor: Colors.grey[500],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                          
                            push(DivisionOffice());
                            // get4();
                            // await launchUrl(Uri.parse(
                            //     'https://play.google.com/store/search?q=kcca+fc+app&c=apps'));
                          },
                          child: HeadedInputCard(
                            imageString: 'assets/images/Vector2.png',
                            iconcolor: Colors.black,
                            text: 'Divisions',
                            size: 9,
                            fWeight: FontWeight.w400,
                            controller: frequent,
                            color: Colors.black,
                            textt: 'Find your division office',
                            textInputType: TextInputType.text,
                            action: TextInputAction.next,
                            hintcolor: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Material(
                      elevation: 9,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegister = !isRegister!;
                                });

                                push(const RegisterPage());
                              },
                              child: Container(
                                height: 50,
                                width: isRegister! ? 130 : 120,
                                decoration: BoxDecoration(
                                  borderRadius: isRegister!
                                      ? BorderRadius.circular(5)
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                  color: isRegister!
                                      ? const Color.fromRGBO(34, 112, 59, 1)
                                      : Colors.white,
                                ),
                                child: Center(
                                    child: ReuseText(
                                  text: 'Register',
                                  size: 14,
                                  color:
                                      isRegister! ? Colors.white : Colors.black,
                                  fWeight: FontWeight.w400,
                                )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegister = !isRegister!;
                                });

                                push(const SignInPage());
                              },
                              child: Container(
                                height: 50,
                                width: !isRegister! ? 130 : 120,
                                decoration: BoxDecoration(
                                  borderRadius: !isRegister!
                                      ? BorderRadius.circular(5)
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                  color: !isRegister!
                                      ? const Color.fromRGBO(34, 112, 59, 1)
                                      : Colors.white,
                                ),
                                child: Center(
                                    child: ReuseText(
                                  text: 'Sign in',
                                  size: 14,
                                  color: !isRegister!
                                      ? Colors.white
                                      : Colors.black,
                                  fWeight: FontWeight.w400,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Image.asset(
                      'assets/images/ASToNlogo.png',
                      height: MediaQuery.of(context).size.height * .1,
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

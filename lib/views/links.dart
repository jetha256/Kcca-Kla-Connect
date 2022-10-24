import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountLinks extends StatefulWidget {
  const AccountLinks({Key? key}) : super(key: key);

  @override
  State<AccountLinks> createState() => _AccountLinksState();
}

class _AccountLinksState extends State<AccountLinks> {
  List<String> emails = [' info@kcca.go.ug'];
  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[

            ///changed to material button

            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      Image.asset(
                        'assets/images/kcclogo.png',
                        height: 60,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    // Android: Will open mail app or show native picker.
                    // iOS: Will open mail app if single mail app found.
                    var result = await OpenMailApp.openMailApp();

                    // If no mail apps found, show error
                    if (!result.didOpen && !result.canOpen) {
                      showNoMailAppsDialog(context);

                      // iOS: if multiple mail apps found, show dialog to select.
                      // There is no native intent/default app system in iOS so
                      // you have to do it yourself.
                    } else if (!result.didOpen && result.canOpen) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return MailAppPickerDialog(
                            mailApps: result.options,
                            emailContent: EmailContent(to: emails),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: Color.fromRGBO(164, 54, 210, 1),
                      ),
                      title: ReuseText(
                        text: ' Send Email',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    _launchCaller();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone_android,
                        color: Color.fromRGBO(0, 110, 248, 1),
                      ),
                      title: ReuseText(
                        text: 'Toll Free: 0800299000',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    facebook();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.facebookF,
                        color: Color.fromRGBO(0, 128, 255, 1),
                      ),
                      title: ReuseText(
                        text: 'KCCAUG',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    twitter();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.twitter,
                        color: Color.fromRGBO(0, 204, 255, 1),
                      ),
                      title: ReuseText(
                        text: 'KCCAUG',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    instagram();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Color.fromRGBO(116, 71, 229, 1),
                      ),
                      title: ReuseText(
                        text: 'KCCAUG',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    youtube();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.youtube,
                        color: Color.fromRGBO(255, 0, 0, 1),
                      ),
                      title: ReuseText(
                        text: 'KCCAUG',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    get1();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.public,
                        color: Color.fromRGBO(0, 204, 255, 1),
                      ),
                      title: ReuseText(
                        text: 'www.kcca.go.ug',
                        size: 14,
                        fWeight: FontWeight.w400,
                      ),
                      trailing: SizedBox(
                        width: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  get1() async {
    const url = 'https://www.kcca.go.ug/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  youtube() async {
    const url = 'https://www.youtube.com/KCCAUG/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  instagram() async {
    const url = 'https://www.instagram.com/KCCAUG/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  twitter() async {
    const url = 'https://www.twitter.com/KCCAUG/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  facebook() async {
    const url = 'https://www.facebook.com/KCCAUG/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication); //forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchCaller() async {
    const url = "tel:0800299000";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

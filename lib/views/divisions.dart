import 'package:flutter/material.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_place/google_place.dart' as googleplace;
import 'package:kcca_kla_connect/views/todestination.dart';

import '../reusables/constants.dart';

class DivisionOffice extends StatefulWidget {
  const DivisionOffice({Key? key}) : super(key: key);

  @override
  State<DivisionOffice> createState() => _DivisionOfficeState();
}

class _DivisionOfficeState extends Base<DivisionOffice> {
  double? longt;
  double? lati;
  // String? address;

  Future<void> getLonLat(addres) async {
    locations = await geocoding.locationFromAddress(addres!);
    setState(() {
      longt = locations!.first.longitude;
      lati = locations!.first.latitude;
    });

    print(longt);
    print(lati);
    push(ToDestination(
      long: longt,
      lati: lati,
      location: addres,
    ));
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
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      child: ReuseText(
                        text: 'Divisions',
                        size: 18,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    getLonLat('4 Kimathi Avenue');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: ReuseText(
                        text: 'City Hall',
                        size: 13,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      title: ReuseText(
                        text: 'Civic Centre',
                        size: 12,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      subtitle: ReuseText(
                        text: 'Christ The King',
                        size: 9,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReuseText(
                              text: '4 Kimathi Avenue',
                              size: 10,
                              color: Colors.black,
                              fWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getLonLat('2 KCCA Lane');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: ReuseText(
                        text: 'Nakawa',
                        size: 13,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      title: ReuseText(
                        text: 'Naguru I',
                        size: 12,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      subtitle: ReuseText(
                        text: 'Naguru I',
                        size: 9,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReuseText(
                              text: '2 KCCA Lane',
                              size: 10,
                              color: Colors.black,
                              fWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getLonLat('114 Mobutu Road');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: ReuseText(
                        text: 'Makindye',
                        size: 13,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      title: ReuseText(
                        text: 'Makindye II',
                        size: 12,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      subtitle: ReuseText(
                        text: 'Makindye',
                        size: 9,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReuseText(
                              text: '114 Mobutu Road',
                              size: 10,
                              color: Colors.black,
                              fWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getLonLat('Kawempe Division Offices, Kampala');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: ReuseText(
                        text: 'Kawempe',
                        size: 13,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      title: ReuseText(
                        text: 'Bwaise II',
                        size: 12,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      subtitle: ReuseText(
                        text: 'Lufula',
                        size: 9,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReuseText(
                              text: '13 Sheikh Muzaata Road',
                              size: 10,
                              color: Colors.black,
                              fWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getLonLat('29 Kabaka Anjagala Road');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: ReuseText(
                        text: 'Rubaga',
                        size: 13,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      title: ReuseText(
                        text: 'Mengo',
                        size: 12,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      subtitle: ReuseText(
                        text: 'Social Center',
                        size: 9,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReuseText(
                              text: '29 Kabaka Anjagala Road',
                              size: 10,
                              color: Colors.black,
                              fWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getLonLat('66 William Street, Kampala');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      leading: ReuseText(
                        text: 'Central',
                        size: 13,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      title: ReuseText(
                        text: 'Nakasero IV',
                        size: 12,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      subtitle: ReuseText(
                        text: 'William Street',
                        size: 9,
                        color: Colors.black,
                        fWeight: FontWeight.w700,
                      ),
                      trailing: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReuseText(
                              text: '66 William Street',
                              size: 10,
                              color: Colors.black,
                              fWeight: FontWeight.w700,
                            ),
                            Icon(
                              Icons.forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      )),
    );
  }
}

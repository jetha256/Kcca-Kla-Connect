import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/reusables/button.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kcca_kla_connect/views/home/home.dart';
import 'package:kcca_kla_connect/views/todestination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../reusables/text.dart';
import '../botomnav.dart';

class SaveLocation extends StatefulWidget {
  final String locationType;
  const SaveLocation({Key? key, required this.locationType}) : super(key: key);

  @override
  State<SaveLocation> createState() => _SaveLocationState();
}

class _SaveLocationState extends Base<SaveLocation> {
  TextEditingController? search;
  List<AutocompletePrediction> predictionsTo = [];
  List<AutocompletePrediction> predictionsDeparturePoint = [];
  TextEditingController _travellingToController = TextEditingController();
  GooglePlace? googlePlace;
  final desrinationAddressFocusNode = FocusNode();
  String _destinationAddress = '';
  String _travellingToName = "";
  double? longt;
  double? lati;
  String? address;
  bool? isSaved = false;

  Future<void> getLonLat() async {
    locations = await locationFromAddress(address!);
    setState(() {
      longt = locations!.first.longitude;
      lati = locations!.first.latitude;
    });
  }

  Future<void> saveLonLat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    locations = await locationFromAddress(address!);
    setState(() {
      longt = locations!.first.longitude;
      lati = locations!.first.latitude;
    });
    prefs.setString(
        widget.locationType.toLowerCase() + "long", longt.toString());
    prefs.setString(widget.locationType.toLowerCase() + "lat", lati.toString());
    prefs.setString(widget.locationType.toLowerCase() + "address", address!);
    print("+++++ LAT: $lati +++++ LONG: $longt");

    pushAndRemoveUntil(const BottomNav());
  }

  void autoCompleteSearch(String value, String caseSwitcher) async {
    var result = await googlePlace!.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      switch (caseSwitcher) {
        case "Travelling From":
          {
            // setState(() {
            //   predictionsTo = result.predictions;
            // });
          }
          break;

        case "Where to?":
          {
            setState(() {
              predictionsTo = result.predictions!;
              address = _travellingToController.text;
            });

            getLonLat();
          }
          break;

        default:
          {
            setState(() {
              predictionsDeparturePoint = result.predictions!;
            });
          }
          break;
      }
    }
  }

  Widget _textField({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? hint,
    double? width,
    Icon? prefixIcon,
    Widget? suffixIcon,
    Function(String)? locationCallback,
  }) {
    return Container(
      width: width! * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback!(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.grey[350],
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[350]!,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace("AIzaSyAdhUesROehQ0accS8FuBXYqnrMsd0IuCM");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: decorateIt,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(140, 139, 138, 0.8),
                              ],
                            )),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  !isSaved!
                      ? Container(
                          height: predictionsTo.length > 0 ? 200 : 60,
                          width: MediaQuery.of(context).size.width * .7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              _textField(
                                  label: '',
                                  hint: 'Search Home Location',
                                  // prefixIcon:
                                  // const Icon(Icons.location_city_rounded),
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: const CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(237, 30, 36, 1),
                                      radius: 15,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  controller: _travellingToController,
                                  focusNode: desrinationAddressFocusNode,
                                  width: MediaQuery.of(context).size.width * 6,
                                  locationCallback: (String value) {
                                    if (value.isNotEmpty) {
                                      autoCompleteSearch(value, "Where to?");
                                    } else {
                                      if (predictionsTo.length > 0 && mounted) {
                                        setState(() {
                                          predictionsTo = [];
                                        });
                                      }
                                    }
                                    setState(() {
                                      _destinationAddress =
                                          _travellingToController.text;
                                    });
                                  }),
                              SizedBox(height: 10),
                              if (predictionsTo.length > 0)
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    height: 150,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width:
                                        MediaQuery.of(context).size.width * 7,
                                    color: Colors.white70,
                                    child: ListView.builder(
                                      itemCount: predictionsTo.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.pin_drop,
                                              color: Colors.white,
                                            ),
                                          ),
                                          title: Text(predictionsTo[index]
                                              .description!),
                                          onTap: () {
                                            debugPrint(predictionsTo[index]
                                                .description);
                                            setState(() {
                                              _travellingToName =
                                                  predictionsTo[index]
                                                      .description!;
                                              _travellingToController.text =
                                                  predictionsTo[index]
                                                      .description!;
                                              _destinationAddress =
                                                  predictionsTo[index]
                                                      .description!;
                                              predictionsTo = [];
                                            });
                                            saveLonLat();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ))
                      : const ReuseText(
                          text: 'Saved places',
                          size: 20,
                          fWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                  !isSaved!
                      ? Container()
                      : const SizedBox(
                          width: 80,
                        )
                ],
              ),
            ),
            !isSaved!
                ? SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.star_border,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSaved = !isSaved!;
                                });
                              },
                              child: const ReuseText(
                                text: 'Saved places ',
                                color: Colors.black,
                                size: 14,
                                fWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              color: Colors.black,
                              height: 1,
                              width: MediaQuery.of(context).size.width * .8,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            !isSaved!
                ? SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.timelapse,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ReuseText(
                              text: 'History',
                              color: Colors.black,
                              size: 14,
                              fWeight: FontWeight.w700,
                            ),
                            Container(
                              color: Colors.black,
                              height: 1,
                              width: MediaQuery.of(context).size.width * .8,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            !isSaved!
                ? Container()
                : Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .8,
                    color: Colors.white,
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(34, 112, 59, 1),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ReuseText(
                          text: 'Saved places ',
                          color: Colors.black,
                          size: 20,
                          fWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            !isSaved!
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSaved = !isSaved!;
                          });
                        },
                        child: ReuseText(
                          text: '  Done  ',
                          color: Colors.red,
                          size: 14,
                          fWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    ));
  }
}

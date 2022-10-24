import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_place/google_place.dart' as googleplace;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kcca_kla_connect/models/news.dart';
import 'package:kcca_kla_connect/models/savedlocations.dart';
import 'package:kcca_kla_connect/models/incident.dart';
import 'package:kcca_kla_connect/views/home/incidentpage.dart';
import 'package:kcca_kla_connect/views/home/savelocation.dart';
import 'package:kcca_kla_connect/views/searchdestination.dart';
import 'package:kcca_kla_connect/views/todestination.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../config/functions.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../reusables/constants.dart';
import '../../reusables/headedinputpic.dart';
import '../divisions.dart';
import '../links.dart';
import '../profilesettings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends Base<HomePage> {
  TextEditingController? search;
  List<googleplace.AutocompletePrediction> predictionsTo = [];
  List<googleplace.AutocompletePrediction> predictionsDeparturePoint = [];
  googleplace.GooglePlace? googlePlace;
  double? longt;
  double? lati;
  String? address;
  bool? isSaved = false;
  TextEditingController? frequent;

  Completer<GoogleMapController> _controller = Completer();
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  Future<List<Incident>>? _incidents;
  Future<List<NewsHistory>>? _newshistory;
  Future<List<SavedLocations>>? _savedLocations;
  List<Incident> _incidentsNearMe = [];
  List<NewsHistory> _newsNearMe = [];
  TextEditingController _travellingToController = TextEditingController();
  final desrinationAddressFocusNode = FocusNode();
  String workAddress = "";
  String homeAddress = "";
  String _destinationAddress = "";
  String savedPlaceAddress = "";
  LatLng? homeCoords;
  LatLng? workCoords;
  LatLng? savedPlaceCoords;
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(0.347596, 32.582520),
    zoom: 14.4746,
  );
  PanelController topSlider = PanelController();
  PanelController bottomSlider = PanelController();
  ValueNotifier<double> bottomheight = ValueNotifier<double>(0);
  ValueNotifier<double> topheight = ValueNotifier<double>(0);

  void getLocation() async {
    final GoogleMapController controller = await _controller.future;
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      // print(loc.latitude);
      // print(loc.longitude);
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
    });
  }

  //get incidents and filter those near me
  Future<List<Incident>> getIncidents() async {
    List<Incident> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl + "incidents/approved");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );

    print("++++++" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<Incident> incidentsmodel =
          (items as List).map((data) => Incident.fromJson(data)).toList();
      var incidents = incidentsmodel;
      returnValue = incidentsmodel;
      setState(() {
        _incidentsNearMe = incidentsmodel;
      });
      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  //get incidents and filter those near me
  Future<List<NewsHistory>> getNews() async {
    print('me');
    List<NewsHistory> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl + "reports");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;
    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );

    print("++++++" + response.body.toString() + "+++++++");

    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<NewsHistory> newsmodel =
          (items as List).map((data) => NewsHistory.fromJson(data)).toList();
      var newshistory = newsmodel;
      returnValue = newsmodel;
      setState(() {
        _newsNearMe = newsmodel;
      });
      print(_newsNearMe.length);
      print('_newsNearMe.length');
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

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

  //get saved locations
  Future<List<SavedLocations>> getSavedLocations() async {
    List<SavedLocations> returnValue = [];
    var url = Uri.parse(AppConstants.baseUrl + "savedlocations");
    String _authToken = "";
    String _username = "";
    String _password = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        'Authorization': 'Bearer $_authToken',
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      List<SavedLocations> locationsmodel =
          (items as List).map((data) => SavedLocations.fromJson(data)).toList();
      var incidents = locationsmodel;
      returnValue = locationsmodel;
      setState(() {});
      // Navigator.pushNamed(context, AppRouter.home);
    } else {
      returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
    return returnValue;
  }

  checkSavedAddresses() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("workaddress") != null &&
        preferences.getString("workaddress") != "") {
      setState(() {
        workAddress = preferences.getString("workaddress")!;
        workCoords = LatLng(double.tryParse(preferences.getString("worklat")!)!,
            double.tryParse(preferences.getString("worklong")!)!);
      });
    }
    if (preferences.getString("homeaddress") != null &&
        preferences.getString("homeaddress") != "") {
      setState(() {
        homeAddress = preferences.getString("homeaddress")!;
        homeCoords = LatLng(double.tryParse(preferences.getString("homelat")!)!,
            double.tryParse(preferences.getString("homelong")!)!);
      });
    }
  }

  Future<void> getLonLat() async {
    locations = await geocoding.locationFromAddress(address!);
    setState(() {
      longt = locations!.first.longitude;
      lati = locations!.first.latitude;
    });
    push(ToDestination(
      long: longt,
      lati: lati,
      location: _destinationAddress,
    ));
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

  late StreamSubscription<bool> keyboardSubscription;
  @override
  void initState() {
    super.initState();
    _incidents = getIncidents();

    _newshistory = getNews();
    googlePlace =
        googleplace.GooglePlace("AIzaSyAdhUesROehQ0accS8FuBXYqnrMsd0IuCM");
    getLocation();

    _savedLocations = getSavedLocations();
    checkSavedAddresses();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible == true) {
        bottomSlider.close();
      }
    });

    bottomheight.addListener(() => bottomheight.value);

    // print value on change
    //  bottomheight.addListener(() {print(bottomheight.value);});

    // do stuff
    bottomheight.addListener(closeup);
    topheight.addListener(() => topheight.value);

    // print value on change
    //  topheight.addListener(() {print(topheight.value);});

    // do stuff
    topheight.addListener(closedown);
  }

  void closeup() async {
    if (bottomheight.value >= 0.3) {
      topSlider.close();
    }
  }

  void closedown() async {
    if (topheight.value >= 0.4) {
      bottomSlider.close();
    }
  }

  @override
  void dispose() {
    topheight.dispose();
    bottomheight.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            ),
            SlidingUpPanel(
              defaultPanelState: PanelState.CLOSED,
              onPanelSlide: (double pos) {
                setState(() {
                  topheight.value = pos;
                });
              },
              collapsed: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(34, 112, 59, 0.8),
                          Color.fromRGBO(105, 160, 123, 0.4),
                        ],
                      )),
                  margin: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Material(
                              elevation: 9,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: GestureDetector(
                                onTap: (() {
                                  push(ProfileSettings());
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
                                      Icons.person_outline,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/images/kcclogo.png')),
                          const SizedBox(
                            width: 60,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                "KLA KONNECT",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(248, 221, 7, 1),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: Container(
                          height: 85,
                          child: FutureBuilder<List<dynamic>>(
                            future: _incidents,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length > 0) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            push(IncidentPage(
                                                incident:
                                                    snapshot.data![index]));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 15, 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient:
                                                      const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color.fromRGBO(
                                                          237, 30, 36, 1),
                                                      Color.fromRGBO(
                                                          248, 221, 7, 1),
                                                    ],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: CircleAvatar(
                                                    radius: 28,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Center(
                                                      child: snapshot
                                                                      .data![
                                                                          index]
                                                                      .file1 !=
                                                                  null &&
                                                              snapshot
                                                                      .data![
                                                                          index]
                                                                      .file1 !=
                                                                  ''
                                                          ? CircleAvatar(
                                                              radius: 26,
                                                              backgroundImage:
                                                                  MemoryImage(
                                                                Base64Decoder()
                                                                    .convert(snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1
                                                                        .split(
                                                                            ',')
                                                                        .last
                                                                        .trim()),
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 26,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                'assets/images/kampalaroad.png',
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    snapshot.data![index].name
                                                        .toString()
                                                        .toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Container(
                                    child: Text("No nearby incidents"),
                                  );
                                }
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppConstants.primaryColor),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            push(const SearchDestination());
                          },
                          child: _textField(
                              label: desrinationAddressFocusNode.hasFocus
                                  ? ''
                                  : 'Where to?',
                              hint: 'Where to?',
                              // prefixIcon:
                              // const Icon(Icons.location_city_rounded),
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  bottomSlider.close();
                                  push(const SearchDestination());
                                },
                                child: Container(
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
                        ),
                      ),
                      if (predictionsTo.length > 0) SizedBox(height: 10),
                      if (predictionsTo.length > 0)
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width * 7,
                          color: Colors.white70,
                          child: ListView.builder(
                            itemCount: predictionsTo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(predictionsTo[index].description!),
                                onTap: () {
                                  debugPrint(predictionsTo[index].description);
                                  setState(() {
                                    _travellingToController.text =
                                        predictionsTo[index].description!;
                                    _destinationAddress =
                                        predictionsTo[index].description!;
                                    predictionsTo = [];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              homeAddress == ""
                                  ? push(
                                      const SaveLocation(locationType: "Home"))
                                  : push(ToDestination(
                                      long: homeCoords!.longitude,
                                      lati: homeCoords!.latitude,
                                    ));
                            },
                            dense: true,
                            title: const Text(
                              "Home",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: homeAddress == ""
                                ? Text("Set once and go")
                                : Text(homeAddress),
                            trailing: ClipOval(
                              child: Material(
                                color: AppConstants.primaryColor,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * .3,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              maxHeight: MediaQuery.of(context).size.height * .62,
              minHeight: MediaQuery.of(context).size.height * .43,
              slideDirection: SlideDirection.DOWN,
              controller: topSlider,
              parallaxEnabled: true,
              parallaxOffset: 1,
              borderRadius: BorderRadius.circular(20),
              panel: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(34, 112, 59, 0.8),
                          Color.fromRGBO(105, 160, 123, 0.4),
                        ],
                      )),
                  margin: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Material(
                              elevation: 9,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: GestureDetector(
                                onTap: (() {
                                  push(ProfileSettings());
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
                                      Icons.person_outline,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/images/kcclogo.png')),
                          const SizedBox(
                            width: 60,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                "KLA KONNECT",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(248, 221, 7, 1),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: Container(
                          height: 85,
                          child: FutureBuilder<List<dynamic>>(
                            future: _incidents,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.length > 0) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            push(IncidentPage(
                                                incident:
                                                    snapshot.data![index]));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 15, 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient:
                                                      const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color.fromRGBO(
                                                          237, 30, 36, 1),
                                                      Color.fromRGBO(
                                                          248, 221, 7, 1),
                                                    ],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: CircleAvatar(
                                                    radius: 28,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Center(
                                                      child: snapshot
                                                                      .data![
                                                                          index]
                                                                      .file1 !=
                                                                  null &&
                                                              snapshot
                                                                      .data![
                                                                          index]
                                                                      .file1 !=
                                                                  ''
                                                          ? CircleAvatar(
                                                              radius: 26,
                                                              backgroundImage:
                                                                  MemoryImage(
                                                                Base64Decoder()
                                                                    .convert(snapshot
                                                                        .data![
                                                                            index]
                                                                        .file1
                                                                        .split(
                                                                            ',')
                                                                        .last
                                                                        .trim()),
                                                              ),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 26,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                'assets/images/kampalaroad.png',
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    snapshot.data![index].name
                                                        .toString()
                                                        .toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Container(
                                    child: Text("No nearby incidents"),
                                  );
                                }
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppConstants.primaryColor),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            push(const SearchDestination());
                          },
                          child: _textField(
                              label: desrinationAddressFocusNode.hasFocus
                                  ? ''
                                  : 'Where to?',
                              hint: 'Where to?',
                              // prefixIcon:
                              // const Icon(Icons.location_city_rounded),
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  push(const SearchDestination());
                                },
                                child: Container(
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
                        ),
                      ),
                      if (predictionsTo.length > 0) SizedBox(height: 10),
                      if (predictionsTo.length > 0)
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width * 7,
                          color: Colors.white70,
                          child: ListView.builder(
                            itemCount: predictionsTo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(predictionsTo[index].description!),
                                onTap: () {
                                  debugPrint(predictionsTo[index].description);
                                  setState(() {
                                    _travellingToController.text =
                                        predictionsTo[index].description!;
                                    _destinationAddress =
                                        predictionsTo[index].description!;
                                    predictionsTo = [];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              homeAddress == ""
                                  ? push(
                                      const SaveLocation(locationType: "Home"))
                                  : push(ToDestination(
                                      long: homeCoords!.longitude,
                                      lati: homeCoords!.latitude,
                                    ));
                            },
                            dense: true,
                            title: const Text(
                              "Home",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: homeAddress == ""
                                ? Text("Set once and go")
                                : Text(homeAddress),
                            trailing: ClipOval(
                              child: Material(
                                color: AppConstants.primaryColor,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              workAddress == ""
                                  ? push(
                                      const SaveLocation(locationType: "Work"))
                                  : push(ToDestination(
                                      long: workCoords!.longitude,
                                      lati: workCoords!.latitude,
                                    ));
                            },
                            dense: true,
                            title: const Text(
                              "Work",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: workAddress == ""
                                ? Text("Set once and go")
                                : Text(workAddress),
                            trailing: ClipOval(
                              child: Material(
                                color: AppConstants.primaryColor,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            dense: true,
                            title: const Text(
                              "Favorite",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text("Set once and go"),
                            trailing: ClipOval(
                              child: Material(
                                color: AppConstants.primaryColor,
                                child: InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width * .3,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SlidingUpPanel(
              defaultPanelState: PanelState.OPEN,
              onPanelSlide: (double post) async {
                setState(() {
                  bottomheight.value = post;
                });
              },
              controller: bottomSlider,
              maxHeight: MediaQuery.of(context).size.height * .45,
              minHeight: MediaQuery.of(context).size.height * .1,
              slideDirection: SlideDirection.UP,
              parallaxEnabled: true,
              parallaxOffset: 1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              panel: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Column(
                        children: [
//
//
//
//
//
//
//
//
                          Container(
                            height: 5,
                            width: MediaQuery.of(context).size.width * .3,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black45,
                            ),
                          ),
                          SizedBox(
                            height: 90,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Swiper(
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    containerHeight: 90,
                                    containerWidth:
                                        MediaQuery.of(context).size.width * .9,
                                    scrollDirection: Axis.horizontal,
                                    layout: SwiperLayout.DEFAULT,
                                    itemWidth:
                                        MediaQuery.of(context).size.width * .9,
                                    itemHeight: 90,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(
                                              Base64Decoder().convert(
                                                  _newsNearMe[index]
                                                      .attachment
                                                      .split(',')
                                                      .last
                                                      .trim()),
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      );
                                    },
                                    itemCount: _newsNearMe.length,
                                    autoplay: true,
                                    autoplayDelay: 8000,
                                    duration: 5,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  push(const AccountLinks());
                                  // get4();
                                  // await launchUrl(Uri.parse(
                                  //     'https://play.google.com/store/search?q=kcca+fc+app&c=apps'));
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
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? hint,
    double? width,
    Widget? prefixIcon,
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
          fillColor: Colors.white70,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
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
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/models/incident.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../config/functions.dart';

class IncidentPage extends StatefulWidget {
  final Incident incident;
  const IncidentPage({Key? key, required this.incident}) : super(key: key);

  @override
  State<IncidentPage> createState() => _IncidentPageState();
}

class _IncidentPageState extends Base<IncidentPage> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  late double? latitude;
  late double? longitude;
  late CameraPosition _kGooglePlex;
  bool? isEngineer;
  bool responseStatus = false;

  Future<void> _archiveIncident(String id) async {
    String _authToken = "";
    String userId = "";
    String idInc = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/archive");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseStatus = true;
    });
    var bodyString = {
      "id": id,
      "updatedby": userId,
    };

    var body = jsonEncode(bodyString);

    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(id);
    print(userId);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      Incident ncident = Incident.fromJson(item);
      idInc = ncident.id;

      setState(() {
        context.loaderOverlay.hide();
      });
    } else if (response.statusCode == 409) {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  Future<void> _approveeIncident(String id) async {
    String _authToken = "";
    String userId = "";
    String idInc = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userid")!;
    _authToken = prefs.getString("authToken")!;
    var url = Uri.parse(AppConstants.baseUrl + "incidents/restore");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    String _username = prefs.getString("email")!;
    String _password = prefs.getString("password")!;

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;
    print("++++++" + "Approve FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseStatus = true;
    });
    var bodyString = {
      "id": id,
      "updatedby": userId,
    };

    var body = jsonEncode(bodyString);

    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print(id);
    print(userId);
    print(body.toString());
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      Incident ncident = Incident.fromJson(item);
      idInc = ncident.id;

      setState(() {
        context.loaderOverlay.hide();
      });
    } else if (response.statusCode == 409) {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        context.loaderOverlay.hide();
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  _checkIfEnge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isEngineer = prefs.getBool("isengineer");
    });
  }

  void getLocation() async {
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId('Home'),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)));
      });
    });
  }

  void setLocation(LatLng loc) async {
    var location = await currentLocation.getLocation();
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(loc.latitude, loc.longitude),
      zoom: 16.0,
    )));
    print(loc.latitude);
    print(loc.longitude);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('Incident'),
          position: LatLng(loc.latitude, loc.longitude),
          // onTap: () {
          //   _customInfoWindowController.addInfoWindow!(
          //     Column(
          //       children: [
          //         Expanded(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Row(
          //                     children: [
          //                       Expanded(
          //                         child: Text(
          //                           widget.incident.name,
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .headline6!
          //                               .copyWith(
          //                                 color: Colors.black,
          //                               ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   const SizedBox(
          //                     height: 8.0,
          //                   ),
          //                   Row(
          //                     children: [
          //                       Expanded(
          //                         child: Image.asset(
          //                           'assets/images/kampalaroad.png',
          //                           fit: BoxFit.fill,
          //                           height: 80,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   const SizedBox(
          //                     height: 8.0,
          //                   ),
          //                   Row(
          //                     children: [
          //                       Expanded(
          //                         // width: 150,
          //                         child: Text(
          //                           widget.incident.description,
          //                           overflow: TextOverflow.visible,
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .bodyMedium!
          //                               .copyWith(
          //                                 color: Colors.black,
          //                               ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   const SizedBox(
          //                     height: 8.0,
          //                   ),
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text(
          //                         widget.incident.incidentcategory,
          //                         overflow: TextOverflow.ellipsis,
          //                         style: const TextStyle(
          //                           fontSize: 14,
          //                           color: Colors.black,
          //                           fontWeight: FontWeight.w400,
          //                         ),
          //                       ),
          //                       Text(
          //                         timeago.format(widget.incident.datecreated,
          //                             locale: 'en_short'),
          //                         overflow: TextOverflow.ellipsis,
          //                         style: const TextStyle(
          //                           fontSize: 14,
          //                           color: Colors.black,
          //                           fontWeight: FontWeight.w400,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             width: double.infinity,
          //             height: double.infinity,
          //           ),
          //         ),
          //         Triangle.isosceles(
          //           edge: Edge.BOTTOM,
          //           child: Container(
          //             color: Colors.blue,
          //             width: 20.0,
          //             height: 10.0,
          //           ),
          //         ),
          //       ],
          //     ),
          //     loc,
          //   );
          // },
        ),
      );
      _customInfoWindowController.addInfoWindow!(
        Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.incident.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: widget.incident.file1 != null &&
                                    widget.incident.file1 != ''
                                ? Image.memory(
                                    Base64Decoder().convert(widget
                                        .incident.file1
                                        .split(',')
                                        .last
                                        .trim()),
                                    fit: BoxFit.fill,
                                    height: 80,
                                  )
                                : Image.asset(
                                    'assets/images/kampalaroad.png',
                                    fit: BoxFit.fill,
                                    height: 80,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            // width: 150,
                            child: Text(
                              widget.incident.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.incident.status == '0'
                              ? Text(
                                  'Pending',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : widget.incident.status == '1'
                                  ? Text(
                                      'Approved',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      'Resolved',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                          Text(
                            timeago.format(widget.incident.datecreated,
                                locale: 'en_short'),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      isEngineer!
                          ? Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.loaderOverlay.show();
                                          _approveeIncident(widget.incident.id);
                                        },
                                        child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.check,
                                                color: Colors.black)),
                                      )),
                                  CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.loaderOverlay.show();
                                          _archiveIncident(widget.incident.id);
                                        },
                                        child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.close,
                                                color: Colors.black)),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Triangle.isosceles(
              edge: Edge.BOTTOM,
              child: Container(
                color: Colors.blue,
                width: 20.0,
                height: 10.0,
              ),
            ),
          ],
        ),
        loc,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      latitude = double.tryParse(widget.incident.addresslat.toString());
      longitude = double.tryParse(widget.incident.addresslong.toString());
      _checkIfEnge();
      _kGooglePlex = CameraPosition(
        target: LatLng(latitude!, longitude!),
        zoom: 12,
      );
      setLocation(LatLng(latitude!, longitude!));
    });
    print(widget.incident.file1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Material(
          elevation: 9,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: ClipOval(
              child: Container(
                height: 30,
                width: 30,
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
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _customInfoWindowController.googleMapController = controller;
              // controller.showMarkerInfoWindow(MarkerId("Incident"));
            },
            markers: _markers,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 235,
            width: MediaQuery.of(context).size.width * 0.7,
            offset: 50,
          ),
        ],
      ),
    );
  }
}

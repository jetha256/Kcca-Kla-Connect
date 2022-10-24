import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:kcca_kla_connect/views/home/home.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';
import '../../services/sImage/image_picker_handler.dart';
import '../botomnav.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({Key? key, this.type}) : super(key: key);
  final String? type;

  @override
  State<IncidentReport> createState() => _IncidentReportState();
}

class _IncidentReportState extends Base<IncidentReport> {
  bool? isEmergency = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _responseLoading = false;
  File? image;
  bool isCheck = true;
  String typeDisplay = "";
  double latitude = 0.0;
  double longitude = 0.0;
  Uint8List? bytes;
  String base64Image = "";
  String locationAddress = "";

  loc.Location currentLocation = loc.Location();

  //get current location
  void getLocation() async {
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((loc.LocationData loc) {
      setState(() {
        latitude = loc.latitude!;
        longitude = loc.longitude!;
        getAddressFromLatLong(latitude, longitude);
      });
    });
  }

  void getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    String addr = "";
    Placemark place = placemarks[0];
    addr =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      locationAddress = place.street!;
    });
  }

  @override
  void dispose() {
    // currentLocation.onLocationChanged.dispose();
    super.dispose();
  }

  //report incident function
  reportIncident(String title, String description) async {
    var url = Uri.parse(AppConstants.baseUrl + "incidents/register");
    String _authToken = "";
    String _username = "";
    String _password = "";
    String _userId = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Get username and password from shared prefs
    _username = prefs.getString("email")!;
    _password = prefs.getString("password")!;
    _userId = prefs.getString("userid")!;
    setState(() {
      _responseLoading = true;
    });

    var bodyString = {
      "id": "829af89e-f39a-11ec-a3a0-80e82c1b7d5b",
      "name": title,
      "description": description,
      "isemergency": false,
      "incidentcategoryid": widget.type,
      "address": "Kampala",
      "addresslat": latitude,
      "addresslong": longitude,
      "file1": base64Image,
      "file2": "",
      "file3": "",
      "file4": "",
      "file5": "",
      "createdby": _userId,
      "datecreated": "2022-06-24T11:49:08.337017",
      "dateupdated": "2022-06-24T08:43:50.661000+00:00",
      "updatedby": "",
      "status": "0"
    };

    var body = jsonEncode(bodyString);
    print(body.toString());

    await AppFunctions.authenticate(_username, _password);
    _authToken = prefs.getString("authToken")!;

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          'Authorization': 'Bearer $_authToken',
        },
        body: body);
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final items = json.decode(response.body);

      showsnack().then((value) {
        Future.delayed(const Duration(seconds: 5), () {
          pushAndRemoveUntil(BottomNav());
        });
      });
      setState(() {
        _responseLoading = false;
      });
    } else {
      setState(() {
        _responseLoading = false;
      });
      // returnValue = [];
      // showSnackBar("Network Failure: Failed to retrieve transactions");
    }
  }

  changePic() async {
    await Utils.pickImageFromGallery().then((pickedFile) async {
      // Step #2: Check if we actually picked an image. Otherwise -> stop;
      if (pickedFile == null) return;

      // Step #3: Crop earlier selected image
      await Utils.cropSelectedImage(pickedFile.path).then((croppedFile) {
        // Step #4: Check if we actually cropped an image. Otherwise -> stop;
        if (croppedFile == null) return;

        // Step #5: Display image on screen
        setState(() {
          image = File(croppedFile.path);
          List<int> imageBytes = image!.readAsBytesSync();
          print(imageBytes);
          base64Image = base64Encode(imageBytes);
        });
      });
    });
  }

  Future<void> showsnack() async {
    await showSnackBar('Incident is reported');
  }

  changePict() async {
    await Utils.pickImageFromCamera().then((pickedFile) async {
      // Step #2: Check if we actually picked an image. Otherwise -> stop;
      if (pickedFile == null) return;

      // Step #3: Crop earlier selected image
      await Utils.cropSelectedImage(pickedFile.path).then((croppedFile) {
        // Step #4: Check if we actually cropped an image. Otherwise -> stop;
        if (croppedFile == null) return;

        // Step #5: Display image on screen
        setState(() {
          image = File(croppedFile.path);
          List<int> imageBytes = image!.readAsBytesSync();
          print(imageBytes);
          base64Image = base64Encode(imageBytes);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    if (widget.type! == 'Traffic') {
      typeDisplay = "82ea10e4-f38e-11ec-8a9e-9347d7b06f35";
    } else if (widget.type! == 'Accident') {
      typeDisplay = "975e00bc-f38e-11ec-8a9e-9347d7b06f35";
    } else if (widget.type! == 'Potholes') {
      typeDisplay = "a06b707c-f38e-11ec-8a9e-9347d7b06f35";
    } else {
      typeDisplay = "ac42c878-f38e-11ec-8a9e-9347d7b06f35";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          padding: EdgeInsets.only(right: 15, left: 15, top: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ReuseText(
                      text: widget.type! == 'Traffic'
                          ? 'Report Traffic'
                          : widget.type! == 'Accident'
                              ? 'Report an Accident'
                              : widget.type! == 'Pothole'
                                  ? 'Report a Pothole'
                                  : 'Report Other Incident',
                      color: Colors.black,
                      fWeight: FontWeight.w700,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Material(
                  elevation: 9,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(5)),
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEmergency = !isEmergency!;
                            });
                          },
                          child: Container(
                            height: 35,
                            width: isEmergency! ? 130 : 120,
                            decoration: BoxDecoration(
                              borderRadius: isEmergency!
                                  ? BorderRadius.circular(5)
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                              color: isEmergency!
                                  ? const Color.fromRGBO(34, 112, 59, 1)
                                  : Colors.grey[500],
                            ),
                            child: const Center(
                                child: ReuseText(
                              text: 'Emergency',
                              size: 12,
                              color: Colors.white,
                              fWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEmergency = !isEmergency!;
                            });
                          },
                          child: Container(
                            height: 35,
                            width: !isEmergency! ? 130 : 120,
                            decoration: BoxDecoration(
                              borderRadius: !isEmergency!
                                  ? BorderRadius.circular(5)
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                              color: !isEmergency!
                                  ? const Color.fromRGBO(34, 112, 59, 1)
                                  : Colors.grey[500],
                            ),
                            child: const Center(
                                child: ReuseText(
                              text: 'Not an emergency',
                              size: 12,
                              color: Colors.white,
                              fWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const ReuseText(
                  text: 'Title',
                  size: 14,
                  color: Colors.black,
                  fWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 45,
                  // width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(245, 245, 245, 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(245, 245, 245, 1)),
                            ),
                            hintText: '', // pass the hint text parameter here
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const ReuseText(
                  text: 'Description',
                  size: 14,
                  color: Colors.black,
                  fWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 120,
                  // width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(245, 245, 245, 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(245, 245, 245, 1)),
                            ),
                            hintText: '', // pass the hint text parameter here
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                image != null
                    ? const SizedBox(
                        height: 15,
                      )
                    : Container(),
                image != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                  height: 300,
                                  child: Image.file(
                                    image!,
                                  )),
                              Positioned(
                                right: 20,
                                top: 20,
                                child: Material(
                                  elevation: 9,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        image = null;
                                        base64Image = "";
                                      });
                                    }),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromRGBO(255, 255, 255, 1),
                                              Color.fromRGBO(
                                                  140, 139, 138, 0.8),
                                            ],
                                          )),
                                      child: const Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        changePic();
                      },
                      child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(132, 169, 144, 1),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_camera_back_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        changePict();
                      },
                      child: Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(132, 169, 144, 1),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const ReuseText(
                      text: 'Add picture',
                      size: 14,
                      color: Colors.black,
                      fWeight: FontWeight.w400,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: isCheck,
                        checkColor: Colors.black, // change color here
                        activeColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            isCheck = value!;
                          });
                        }),
                    const ReuseText(
                      text: 'I am currently at the scene of this report.',
                      size: 14,
                      color: Colors.black,
                      fWeight: FontWeight.w400,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _responseLoading
                        ? SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstants.primaryColor),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              print('YEssssss');
                              reportIncident(titleController.text,
                                  descriptionController.text);
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .3,
                              child: ReuseButton(
                                radius: 20,
                                height:
                                    MediaQuery.of(context).size.height * .04,
                                width: MediaQuery.of(context).size.width * .3,
                                color: const Color.fromRGBO(34, 112, 59, 1),
                                child: const ReuseText(
                                  text: 'Report',
                                  color: Colors.white,
                                  size: 14,
                                  fWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

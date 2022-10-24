import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../services/sImage/image_picker_handler.dart';
import '../user/user_data.dart';
import '../widgets/appbar_widget.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends Base<EditImagePage> {
  var user = UserData.myUser;
  File? image;
  bool isCheck = true;
  Uint8List? bytes;
  String base64Image = "";
  String locationAddress = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              width: 330,
              child: const Text(
                "Upload a photo of yourself:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                    onTap: () async {
                      await Utils.pickImageFromGallery()
                          .then((pickedFile) async {
                        // Step #2: Check if we actually picked an image. Otherwise -> stop;
                        if (pickedFile == null) return;

                        // Step #3: Crop earlier selected image
                        await Utils.cropSelectedImage(pickedFile.path)
                            .then((croppedFile) {
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
                    },
                    child: base64Image != ''
                        ? Image.memory(
                            base64Decode(base64Image.split(',').last))
                        : Image.network(user.image),
                  ))),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.hide();
                        String _authToken = "";
                        String userId = "";
                        String idInc = "";

                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        userId = prefs.getString("userid")!;
                        _authToken = prefs.getString("authToken")!;
                        var url = Uri.parse(
                            AppConstants.baseUrl + "users/updatephoto");

                        // final SharedPreferences prefs = await SharedPreferences.getInstance();
                        //Get username and password from shared prefs
                        String _username = prefs.getString("email")!;
                        String _password = prefs.getString("password")!;

                        await AppFunctions.authenticate(_username, _password);
                        _authToken = prefs.getString("authToken")!;
                        print("++++++" + "Approve FUNCTION" + "+++++++");
                        // Navigator.pushNamed(context, AppRouter.home);
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // setState(() {
                        //   responseStatus = true;
                        // });
                        var bodyString = {
                          "userid": userId,
                          "photo": base64Image,
                        };

                        var body = jsonEncode(bodyString);

                        // remove this on code edit
                        prefs.setString('photo', base64Image);
                        Navigator.pop(context, true);

                        var response = await http.put(url,
                            headers: {
                              "Content-Type": "Application/json",
                              'Authorization': 'Bearer $_authToken',
                            },
                            body: body);
                        print(userId);
                        print(body.toString());
                        print("++++++" +
                            response.statusCode.toString() +
                            "+++++++");
                        if (response.statusCode == 200) {
                          prefs.setString('photo', base64Image);
                          showSnackBar('Changed profile picture');

                          setState(() {
                            context.loaderOverlay.hide();
                          });
                          Navigator.pop(context);
                        } else if (response.statusCode == 409) {
                          setState(() {
                            context.loaderOverlay.hide();
                          });
                          showSnackBar("User account not activated.");
                        } else {
                          setState(() {
                            context.loaderOverlay.hide();
                          });
                          showSnackBar(
                              "Authentication Failure: Invalid credentials.");
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}

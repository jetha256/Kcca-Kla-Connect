import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/models/otpverify.dart';
import 'package:kcca_kla_connect/models/user.dart';
import 'package:kcca_kla_connect/reusables/button.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:kcca_kla_connect/reusables/textinput.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:kcca_kla_connect/views/auth/signin.dart';
import 'package:kcca_kla_connect/views/botomnav.dart';
import 'package:kcca_kla_connect/views/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/signup.dart';

class OtpPage extends StatefulWidget {
  final SignUpModel user;
  const OtpPage({Key? key, required this.user}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends Base<OtpPage> {
  bool _responseLoading = false;
  String userId = "";
  String otp = "";

  @override
  void initState() {
    super.initState();
    _generateOtp();
    setState(() {
      userId = widget.user.id;
    });
  }

  _generateOtp() async {
    var url = Uri.parse(AppConstants.getOtpUrl);
    bool responseStatus = false;
    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _responseLoading = true;
    });
    var bodyString = {
      "api_id": "API27709903398",
      "api_password": "Kcc@2022",
      "brand": "KLA CONNECT",
      "phonenumber": widget.user.phone.toString().replaceAll("+", ""),
      "sender_id": "KCCA",
    };

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      VeirfyOtp otpObj = VeirfyOtp.fromJson(item);
      if (otpObj.status == "S") {
        showSnackBar("OTP sent via SMS");
        prefs.setInt("verificationid", otpObj.verficationId);
      } else {
        showSnackBar("OTP Failure: Failed to send OTP.");
      }
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Verification Failure: Failed to send OTP.");
    }
  }

  _update() async {
    var url = Uri.parse(AppConstants.baseUrl + "users/activate/{userid}");
    bool responseStatus = false;

    setState(() {
      _responseLoading = true;
      // print("++++++ VALIDATED PHONE NUMBER ++++" + _validatedphoneNumber);
    });
    var bodyString = {
      "id": widget.user.id,
      "firstname": widget.user.firstname,
      "lastname": widget.user.lastname,
      "username": widget.user.username,
      "email": widget.user.email,
      "password": widget.user.password,
      "gender": widget.user.gender,
      "address": widget.user.address,
      "addresslat": widget.user.addresslat,
      "addresslong": widget.user.addresslong,
      "phone": widget.user.phone,
      "mobile": widget.user.mobile,
      "photo": widget.user.photo,
      "nin": widget.user.nin,
      "dateofbirth": widget.user.dateofbirth,
      "iscitizen": widget.user.iscitizen,
      "isclerk": widget.user.isclerk,
      "isengineer": widget.user.isengineer,
      "isadmin": widget.user.isadmin,
      "issuperadmin": widget.user.issuperadmin,
      "status": "1"
    };

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    print("THE STATUS CODE IS ++++++" +
        response.statusCode.toString() +
        "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _responseLoading = false;
      });
      final item = json.decode(response.body);
      SignUpModel userModel = SignUpModel.fromJson(item);
      print("++++THE USER IS +++" + item["id"].toString());
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Registration Failure: Invalid data.(" +
          response.statusCode.toString() +
          ")");
    }
  }

  _verifyOtp(String otpCode) async {
    var url = Uri.parse(AppConstants.verifyOtpUrl);
    bool responseStatus = false;
    String _authToken = "";
    int verificationCode = 0;
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _responseLoading = true;
      if (prefs.getInt("verificationid") != null) {
        verificationCode = prefs.getInt("verificationid")!;
      }
    });

    var bodyString = {
      "verfication_id": verificationCode,
      "verfication_code": otpCode,
    };

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      VeirfyOtp otpObj = VeirfyOtp.fromJson(item);
      if (otpObj.status == "V") {
        _update();
        Future.delayed(const Duration(seconds: 5), () {
          pushAndRemoveUntil(const SignInPage());
        });
        showSnackBar("Verification Successful: Activating User ...");
        _activateUser();
      } else {
        showSnackBar("Verification Failure: Invalid OTP.");
      }
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Verification Failure: Invalid OTP.");
    }
  }

  _activateUser() async {
    bool responseStatus = false;
    String _authToken = "";
    // String userId = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
    var url = Uri.parse(AppConstants.baseUrl + "users/activate/$userId");

    var response = await http.get(
      url,
      // headers: {
      //   "Content-Type": "Application/json",
      // },
    );
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      pushAndRemoveUntil(const SignInPage());
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Verification Failure: Invalid OTP.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xffF5F5F5),
          ),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  const ReuseText(
                    text: 'Verify your phone number',
                    color: Colors.black,
                    fWeight: FontWeight.w700,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.width * .8,
                child: RichText(
                  text: TextSpan(
                    text: 'We have sent a verification code to ' +
                        widget.user.phone +
                        '.',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: "",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(34, 112, 59, 1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'Enter Code',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              Center(
                child: OtpTextField(
                  numberOfFields: 4,
                  borderColor: const Color.fromRGBO(34, 112, 59, 1),
                  keyboardType: TextInputType.text,
                  focusedBorderColor: const Color.fromRGBO(34, 112, 59, 1),
                  showFieldAsBox: true,
                  fillColor: Colors.blue,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  onCodeChanged: (String code) {},
                  onSubmit: (String verificationCode) {
                    _verifyOtp(verificationCode);

                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         title: Text("Verification Code"),
                    //         content: Text('Code entered is $verificationCode'),
                    //       );
                    //     });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class UpdatePasswordPage extends StatefulWidget {
  final String otp;
  final String email;
  const UpdatePasswordPage({Key? key, required this.email, required this.otp})
      : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends Base<UpdatePasswordPage> {
  bool _responseLoading = false;
  String userId = "";
  String otp = "";
  bool _showPasswordFields = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  _verifyOtp(String otpCode, String newPassword) async {
    var url = Uri.parse(AppConstants.baseUrl + "users/verify");
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
      "email": widget.email,
      "otpcode": widget.otp,
      "password": newPassword
    };

    var body = jsonEncode(bodyString);
    if (otpCode == widget.otp) {
      var response = await http.post(url,
          headers: {
            "Content-Type": "Application/json",
          },
          body: body);
      print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final item = json.decode(response.body);
        Future.delayed(const Duration(seconds: 2), () {
          pushAndRemoveUntil(const SignInPage());
        });
        showSnackBar("Password Updated: Head to Sign Up");
        _activateUser();
      } else {
        setState(() {
          _responseLoading = false;
        });
        showSnackBar("Update Failure: Invalid OTP.");
      }
    } else {
      showSnackBar("Update Failure: Invalid OTP.");
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
          child: SingleChildScrollView(
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
                      text: 'Verify your email address',
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
                      text: 'We have sent a verification code to ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: widget.email + "",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(34, 112, 59, 1),
                            fontSize: 16,
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
                      if (verificationCode == widget.otp) {
                        setState(() {
                          _showPasswordFields = true;
                          otp = verificationCode;
                        });
                      } else {
                        showSnackBar("Inavlid OTP!");
                      }
                      // _verifyOtp(verificationCode);

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
                Visibility(
                  visible: _showPasswordFields,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Row(
                      children: [
                        Expanded(
                          child: ReuseInput(
                            action: TextInputAction.done,
                            textInputType: TextInputType.text,
                            controller: passwordController,
                            obscureText: true,
                            text: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _showPasswordFields,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Row(
                      children: [
                        Expanded(
                          child: ReuseInput(
                            action: TextInputAction.done,
                            textInputType: TextInputType.text,
                            controller: confirmPasswordController,
                            obscureText: true,
                            text: 'Confirm Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                _responseLoading
                    ? Visibility(
                        visible: _showPasswordFields,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.primaryColor),
                          ),
                        ),
                      )
                    : Visibility(
                        visible: _showPasswordFields,
                        child: GestureDetector(
                          onTap: () {
                            _verifyOtp(otp, passwordController.text.trim());
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .05,
                            width: MediaQuery.of(context).size.width * .6,
                            child: ReuseButton(
                              radius: 20,
                              height: MediaQuery.of(context).size.height * .04,
                              width: MediaQuery.of(context).size.width * .6,
                              color: const Color.fromRGBO(34, 112, 59, 1),
                              child: const ReuseText(
                                text: 'Update Password',
                                color: Colors.white,
                                size: 14,
                                fWeight: FontWeight.w400,
                              ),
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
}

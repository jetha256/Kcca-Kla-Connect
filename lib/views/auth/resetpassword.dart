import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/models/user.dart';
import 'package:kcca_kla_connect/reusables/button.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:kcca_kla_connect/reusables/textinput.dart';
import 'package:kcca_kla_connect/views/auth/register.dart';
import 'package:kcca_kla_connect/views/auth/signin.dart';
import 'package:kcca_kla_connect/views/auth/updatepassword.dart';
import 'package:kcca_kla_connect/views/botomnav.dart';
import 'package:kcca_kla_connect/views/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/authtoken.dart';
import '../../models/profile.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends Base<ResetPasswordPage> {
  String? identify;
  String? password;
  TextEditingController identifyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _responseLoading = false;

  _resetPassword(String email) async {
    var url = Uri.parse(AppConstants.baseUrl + "users/resetpassword/$email");
    bool responseStatus = false;
    String _authToken = "";
    print("++++++" + "RESET PASSWORD FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _responseLoading = true;
    });

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    print("++++++ CODE IS" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      var otp = item["otp"];
      setState(() {
        _responseLoading = false;
      });
      pushAndRemoveUntil(UpdatePasswordPage(otp: otp, email: email));
    } else if (response.statusCode == 204) {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Account with this email does not exist.");
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Failed to reset password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signin.jpeg'),
                fit: BoxFit.fitHeight,
              ),
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
                      text: 'Reset Password',
                      color: Colors.black,
                      fWeight: FontWeight.w700,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                GlassmorphicContainer(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height * .4,
                  borderRadius: 20,
                  blur: 1,
                  alignment: Alignment.bottomCenter,
                  border: .5,
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
                      const Color(0xFFffffff).withOpacity(0.5),
                      const Color((0xFFFFFFFF)).withOpacity(0.5),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          children: [
                            ReuseInput(
                              controller: identifyController,
                              textInputType: TextInputType.emailAddress,
                              text: 'Email Address',
                              action: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      _responseLoading
                          ? SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .6,
                              child: GestureDetector(
                                onTap: () {
                                  _resetPassword(
                                      identifyController.text.trim());
                                },
                                child: ReuseButton(
                                  radius: 20,
                                  height:
                                      MediaQuery.of(context).size.height * .04,
                                  width: MediaQuery.of(context).size.width * .6,
                                  color: const Color.fromRGBO(34, 112, 59, 1),
                                  child: const ReuseText(
                                    text: 'Reset Password',
                                    color: Colors.white,
                                    size: 14,
                                    fWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ReuseText(
                              text: 'Don’t have an account? ',
                              color: Colors.black,
                              size: 12,
                              fWeight: FontWeight.w400,
                            ),
                            GestureDetector(
                              onTap: () {
                                pushReplacement(const RegisterPage());
                              },
                              child: const ReuseText(
                                text: 'Register here',
                                color: Colors.red,
                                size: 12,
                                fWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/models/user.dart';
import 'package:kcca_kla_connect/reusables/button.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:kcca_kla_connect/reusables/textinput.dart';
import 'package:kcca_kla_connect/views/auth/register.dart';
import 'package:kcca_kla_connect/views/auth/resetpassword.dart';
import 'package:kcca_kla_connect/views/botomnav.dart';
import 'package:kcca_kla_connect/views/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/authtoken.dart';
import '../../models/profile.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends Base<SignInPage> {
  String? identify;
  String? password;
  TextEditingController identifyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  bool _responseLoading = false;
  bool? passOb;
  bool usePhone = false;
  String _countryCode = "256";
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  String _validatedphoneNumber = "";

  String _validateMobile(String countrycode, phoneNumber) {
    String nonzeropattern = r'(^[1-9]{1}[0-9]{8}$)';
    String zeropattern = r'(^[0]{1}[1-9]{1}[0-9]{8}$)';
    RegExp nonzeroregExp = new RegExp(nonzeropattern);
    RegExp zeroregExp = new RegExp(zeropattern);
    if (phoneNumber.length == 10 && zeroregExp.hasMatch(phoneNumber)) {
      print('WITH ZERO NUMBER MATCHED');
      _validatedphoneNumber = countrycode + phoneNumber.substring(1);
    } else if (phoneNumber.length == 9 && nonzeroregExp.hasMatch(phoneNumber)) {
      print('NON ZERO NUMBER MATCHED');
      _validatedphoneNumber = countrycode + phoneNumber;
    } else {
      print('FAILED');
    }
    print("This is the validated number: " + _validatedphoneNumber);
    return _validatedphoneNumber;
  }

  _login(String username, String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "user/login");
    bool responseStatus = false;
    String _authToken = "";
    print("++++++" + "LOGIN FUNCTION" + "+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _responseLoading = true;
      if (usePhone) {
        url = Uri.parse(AppConstants.baseUrl + "user/login/mobile");
      }
    });
    var bodyString = {"username": username, "password": password};
    print(bodyString.toString());
    print(url.toString());
    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    print("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      UserModel user = UserModel.fromJson(item);
      _authToken = user.token;
      prefs.setString("authToken", _authToken);

      prefs.setString("firstName", user.firstname);
      prefs.setString("lastName", user.lastname);
      prefs.setString("email", user.email);
      prefs.setString("gender", user.gender);
      prefs.setString("username", user.username);
      prefs.setString("password", password);
      prefs.setString("phone", user.mobile);
      prefs.setString("photo", '');
      prefs.setString("userid", user.userid.toString());
      prefs.setString("dateJoined", user.datecreated.toIso8601String());
      prefs.setInt("incidentsCount", user.incidentscount);
      prefs.setBool(
          "isengineer", user.isengineer == null ? false : user.isengineer!);
      setState(() {
        _responseLoading = false;
      });
      pushAndRemoveUntil(const BottomNav());
    } else if (response.statusCode == 409) {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("User account not activated.");
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Authentication Failure: Invalid credentials.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passOb = false;
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
                      text: 'Sign in',
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
                  height: MediaQuery.of(context).size.height * .6,
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
                      Material(
                        elevation: 9,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    usePhone = !usePhone;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: usePhone ? 130 : 120,
                                  decoration: BoxDecoration(
                                    borderRadius: usePhone
                                        ? BorderRadius.circular(5)
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                    color: usePhone
                                        ? const Color.fromRGBO(34, 112, 59, 1)
                                        : Colors.white,
                                  ),
                                  child: Center(
                                      child: ReuseText(
                                    text: 'Phone',
                                    size: 14,
                                    color:
                                        usePhone ? Colors.white : Colors.black,
                                    fWeight: FontWeight.w400,
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    usePhone = !usePhone;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: !usePhone ? 130 : 120,
                                  decoration: BoxDecoration(
                                    borderRadius: !usePhone
                                        ? BorderRadius.circular(5)
                                        : const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                    color: !usePhone
                                        ? const Color.fromRGBO(34, 112, 59, 1)
                                        : Colors.white,
                                  ),
                                  child: Center(
                                      child: ReuseText(
                                    text: 'Email',
                                    size: 14,
                                    color:
                                        !usePhone ? Colors.white : Colors.black,
                                    fWeight: FontWeight.w400,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      if (!usePhone)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .1,
                          width: MediaQuery.of(context).size.width * .8,
                          child: Row(
                            children: [
                              ReuseInput(
                                controller: identifyController,
                                textInputType: TextInputType.text,
                                text: 'Email Address',
                                action: TextInputAction.next,
                              ),
                            ],
                          ),
                        ),
                      if (usePhone)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * .08,
                          child: Row(
                            children: [
                              Container(
                                width: 110,
                                margin: const EdgeInsets.only(right: 10),
                                child: InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print("CODE: " +
                                        number.phoneNumber.toString());
                                    setState(() {
                                      _countryCode =
                                          number.phoneNumber.toString();
                                    });
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      TextStyle(color: Colors.black),
                                  initialValue: number,
                                  textFieldController: countryCodeController,
                                  formatInput: false,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputBorder: OutlineInputBorder(),
                                  onSaved: (PhoneNumber number) {
                                    print('On Saved: $number');
                                  },
                                ),

                                // ReuseInput(
                                //   // controller: identifyController,
                                //   textInputType: TextInputType.text,
                                //   text: '+256',
                                //   action: TextInputAction.next,
                                // ),
                              ),
                              Expanded(
                                child: ReuseInput(
                                  controller: phoneController,
                                  textInputType: TextInputType.text,
                                  text: '770123123',
                                  action: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          children: [
                            ReuseInput(
                              action: TextInputAction.done,
                              textInputType: TextInputType.text,
                              controller: passwordController,
                              obscureText: passOb!,
                              text: 'Password',
                              last: passOb!
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          passOb = !passOb!;
                                        });
                                      },
                                      child: const Icon(Icons.visibility))
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          passOb = !passOb!;
                                        });
                                      },
                                      child: const Icon(Icons.visibility_off)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          push(ResetPasswordPage());
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                          width: MediaQuery.of(context).size.width * .8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              ReuseText(
                                text: 'Forgot password? ',
                                color: Colors.black,
                                size: 12,
                                fWeight: FontWeight.w400,
                              ),
                              ReuseText(
                                text: 'Reset',
                                color: Colors.red,
                                size: 12,
                                fWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
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
                                  if (usePhone) {
                                    setState(() {
                                      _validatedphoneNumber = _validateMobile(
                                          _countryCode, phoneController.text);
                                    });

                                    _login(_validatedphoneNumber.trim(),
                                        passwordController.text.trim());
                                  } else {
                                    _login(identifyController.text.trim(),
                                        passwordController.text.trim());
                                  }

                                  // push(const BottomNav());
                                },
                                child: ReuseButton(
                                  radius: 20,
                                  height:
                                      MediaQuery.of(context).size.height * .04,
                                  width: MediaQuery.of(context).size.width * .6,
                                  color: const Color.fromRGBO(34, 112, 59, 1),
                                  child: const ReuseText(
                                    text: 'Sign in',
                                    color: Colors.white,
                                    size: 14,
                                    fWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
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

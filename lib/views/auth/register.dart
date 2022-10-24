import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kcca_kla_connect/config/base.dart';
import 'package:kcca_kla_connect/models/signup.dart';
import 'package:kcca_kla_connect/models/user.dart';
import 'package:kcca_kla_connect/reusables/button.dart';
import 'package:kcca_kla_connect/reusables/constants.dart';
import 'package:kcca_kla_connect/reusables/text.dart';
import 'package:kcca_kla_connect/reusables/textinput.dart';
import 'package:kcca_kla_connect/views/auth/otp.dart';
import 'package:kcca_kla_connect/views/auth/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../config/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends Base<RegisterPage> {
  String? identify;
  String? password;
  bool _responseLoading = false;
  bool? passOb;
  bool? repassOb;
  String _validatedphoneNumber = "";
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  String _countryCode = "256";
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  String _selectedGender = "M";

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

  _register(String firstname, String lastname, String email, String phone,
      String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "users/signup");
    bool responseStatus = false;
    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _responseLoading = true;
      _validatedphoneNumber = _validateMobile(_countryCode, phone);
      // print("++++++ VALIDATED PHONE NUMBER ++++" + _validatedphoneNumber);
    });
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var bodyString = {
      "id": "0",
      "firstname": firstname,
      "lastname": lastname,
      "username": email,
      "email": email,
      "password": password,
      "gender": _selectedGender,
      "address": "",
      "addresslat": 0.0,
      "addresslong": 0.0,
      "phone": _validatedphoneNumber,
      "mobile": "",
      "photo": "",
      "nin": "",
      "dateofbirth": "1990-03-23",
      "iscitizen": true,
      "isclerk": false,
      "isengineer": false,
      "isadmin": false,
      "issuperadmin": false,
      "status": "0"
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
      push(OtpPage(
        user: userModel,
      ));
    } else if (response.statusCode == 409) {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("User already exists with this email.");
    } else {
      setState(() {
        _responseLoading = false;
      });
      showSnackBar("Registration Failure: Invalid data.(" +
          response.statusCode.toString() +
          ")");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passOb = true;
    repassOb = true;
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
                      text: 'Register',
                      color: Colors.black,
                      fWeight: FontWeight.w700,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Expanded(
                        child: ReuseInput(
                          controller: firstNameController,
                          textInputType: TextInputType.text,
                          text: 'Firstname',
                          action: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Expanded(
                        child: ReuseInput(
                          controller: lastNameController,
                          textInputType: TextInputType.text,
                          text: 'Lastname',
                          action: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Container(
                        width: 110,
                        margin: const EdgeInsets.only(right: 10),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print("CODE: " + number.phoneNumber.toString());
                            setState(() {
                              _countryCode = number.phoneNumber.toString();
                            });
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(color: Colors.black),
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
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Expanded(
                        child: ReuseInput(
                          controller: emailController,
                          textInputType: TextInputType.text,
                          text: 'Email',
                          action: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: GenderPickerWithImage(
                            showOtherGender: false,
                            verticalAlignedText: false,
                            selectedGender: Gender.Male,
                            selectedGenderTextStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            unSelectedGenderTextStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                            onChanged: (Gender? gender) {
                              if (gender == Gender.Male) {
                                print("Male");
                                setState(() {
                                  _selectedGender = "M";
                                });
                              } else {
                                print("Female");
                                _selectedGender = "F";
                              }
                            },
                            equallyAligned: true,
                            animationDuration: Duration(milliseconds: 300),
                            isCircular: true,
                            // default : true,
                            opacityOfGradient: 0.4,
                            padding: const EdgeInsets.all(3),
                            size: 50, //default : 40
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Expanded(
                        child: ReuseInput(
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    children: [
                      Expanded(
                        child: ReuseInput(
                          action: TextInputAction.done,
                          textInputType: TextInputType.text,
                          controller: confirmPasswordController,
                          obscureText: repassOb!,
                          text: 'Confirm Password',
                          last: repassOb!
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      repassOb = !repassOb!;
                                    });
                                  },
                                  child: const Icon(Icons.visibility))
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      repassOb = !repassOb!;
                                    });
                                  },
                                  child: const Icon(Icons.visibility_off)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                  width: MediaQuery.of(context).size.width * .8,
                  child: RichText(
                    text: TextSpan(
                      text: 'By continuing to sign up, you agree to our ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Service ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(Uri.parse(
                                  'https://aston-network.org/legal-notice/'));
                            },
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(34, 112, 59, 1),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: 'and that you have read our ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy. ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(
                                  Uri.parse('https://www.kcca.go.ug/privacy'));
                            },
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(34, 112, 59, 1),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              'You may receive SMS notifications from us and can opt out at any time.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
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
                          if (firstNameController.text.trim().isEmpty) {
                            showSnackBar('Your first name is required');
                          } else if (lastNameController.text.trim().isEmpty) {
                            showSnackBar('Your last name is required');
                          } else if (emailController.text.trim().isEmpty) {
                            showSnackBar('Your email is required');
                          } else if (phoneController.text.trim().isEmpty) {
                            showSnackBar('Your phone number is required');
                          } else if (phoneController.text.trim().length < 9) {
                            showSnackBar('Correct your phone number');
                          } else if (passwordController.text.trim().isEmpty ||
                              passwordController.text.trim() !=
                                  confirmPasswordController.text.trim()) {
                            showSnackBar(
                                'Your password must be filled and should be the same as the confirmed password');
                          } else {
                            _register(
                                firstNameController.text.trim(),
                                lastNameController.text.trim(),
                                emailController.text.trim(),
                                phoneController.text.trim(),
                                passwordController.text.trim());
                          }
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
                              text: 'Register',
                              color: Colors.white,
                              size: 14,
                              fWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ReuseText(
                        text: 'Already have an account? ',
                        color: Colors.black,
                        size: 12,
                        fWeight: FontWeight.w400,
                      ),
                      GestureDetector(
                        onTap: () {
                          pushReplacement(SignInPage());
                        },
                        child: const ReuseText(
                          text: 'Sign In',
                          color: Color.fromRGBO(34, 112, 59, 1),
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
        ),
      ),
    );
  }
}

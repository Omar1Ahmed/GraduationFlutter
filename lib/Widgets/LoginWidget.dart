import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Meetings/Widgets/ForgotPasswordWidget.dart';
import 'package:Meetings/Widgets/TestApi.dart';
import 'package:Meetings/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Grad.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();

  static void LogOut() async {
    initialize();

    loginInfo.clear();
    accData.clear();
  }

  static Future<SharedPreferences> initialize() async {
    loginInfo = await SharedPreferences.getInstance();
    accData = await SharedPreferences.getInstance();

    return accData;
  }
}

late ApiTest api;

bool checkedValue = false,
    passwordVisible = true,
    invalidMail = false,
    invalidPass = false,
    mailClicked = false,
    pressed = false;

GlobalKey<FormState> ValidateEmail = GlobalKey<FormState>();
GlobalKey<FormState> ValidatePass = GlobalKey<FormState>();

TextEditingController txtMail = TextEditingController();
TextEditingController PassTxt = TextEditingController();

late SharedPreferences accData, loginInfo, Language, Nearest;

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    txtMail.text = "";
    PassTxt.text = "";
    checkedValue = false;
    passwordVisible = true;
    invalidMail = false;
    invalidPass = false;
    mailClicked = false;
    pressed = false;
    isRememberd();

    languageSharedPrefInitialize();
    nearsetSharedPref();

    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    late double ScreenWidth;
    late double ScreenHeight;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      ScreenWidth = MediaQuery.of(context).size.width;
      ScreenHeight = MediaQuery.of(context).size.height;
    } else {
      ScreenWidth = MediaQuery.of(context).size.height;
      ScreenHeight = MediaQuery.of(context).size.width;
      // ScreenWidth = MediaQuery.of(context).size.width;
      // ScreenHeight = MediaQuery.of(context).size.height;
    }

    api = ApiTest(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Container(
                margin: EdgeInsets.only(
                    top: ScreenHeight * 0.056, bottom: ScreenHeight * 0.022),
                width: ScreenWidth * 0.24,
                height: ScreenHeight * 0.12,
                child: SvgPicture.asset('images/Logo.svg'),
              ),
              Text(
                "Meetings",
                style: TextStyle(
                    fontSize: ScreenWidth * 0.07, color: Colors.white),
              ),
              Divider(
                indent: ScreenWidth * 0.24,
                endIndent: ScreenWidth * 0.24,
              ),
              Container(
                width: ScreenWidth * 0.83,
                margin: EdgeInsets.only(
                    top: ScreenHeight * 0.056, bottom: ScreenHeight * 0.0111),
                child: Form(
                  key: ValidateEmail,
                  child: Material(
                    elevation: ScreenWidth * 0.03,
                    borderRadius: BorderRadius.circular(ScreenWidth * 0.06),
                    color: Colors.transparent,
                    child: TextFormField(
                      controller: txtMail,
                      validator: (value) {
                        if (value!.isEmpty) {

                          return S.of(context).mailEmptyErrorText;
                        } else if (invalidMail) {
                          invalidMail = false;
                          return S.of(context).mailInvalidErrorText;
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      onChanged: (value) =>
                          ValidateEmail.currentState!.validate(),
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenWidth * 0.06),
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: ScreenWidth * 0.0025)),
                        constraints: BoxConstraints(
                            minHeight: ScreenWidth * 0.11,
                            maxHeight: ScreenWidth * 0.18),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenHeight * 0.01,
                            horizontal: ScreenWidth * 0.04),
                        // Adjust the padding as needed
                        prefixIcon: SvgPicture.asset(
                          'images/user.svg',
                          height: ScreenHeight * 0.06,
                          fit: BoxFit.scaleDown,
                        ),
                        labelText: S.of(context).mailLabelText,
                        hintText: S.of(context).mailHintText,
                        focusColor: Colors.transparent,
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintMaxLines: 1,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenWidth * 0.09),
                            borderSide: BorderSide.none),
                        fillColor: const Color(0xff323644),
                        filled: true,
                        // isDense: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenWidth * 0.83,
                margin: EdgeInsets.only(
                    top: ScreenHeight * 0.022, bottom: ScreenHeight * 0.022),
                child: Form(
                  key: ValidatePass,
                  child: Material(
                    elevation: ScreenWidth * 0.03,
                    borderRadius: BorderRadius.circular(ScreenWidth * 0.06),
                    color: Colors.transparent,
                    child: TextFormField(
                      controller: PassTxt,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      onChanged: (value) =>
                          ValidatePass.currentState!.validate(),
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenWidth * 0.06),
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: ScreenWidth * 0.0025)),
                        constraints: BoxConstraints(
                            minHeight: ScreenWidth * 0.11,
                            maxHeight: ScreenWidth * 0.18),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenHeight * 0.01,
                            horizontal: ScreenWidth * 0.04),
                        prefixIcon: SvgPicture.asset(
                          "images/password.svg",
                          semanticsLabel: 'PassIcon',
                          height: ScreenHeight * 0.06,
                          fit: BoxFit.scaleDown,
                          // ),
                        ),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.only(right: ScreenHeight * 0.02),
                          icon: SvgPicture.asset(
                            passwordVisible
                                ? "images/showPassIcon.svg"
                                : "images/hidePassIcon.svg",
                            semanticsLabel: 'PassIcon',
                            height: ScreenHeight * 0.04,
                            fit: BoxFit.scaleDown,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        labelText: S.of(context).passwordLabelText,
                        hintText: S.of(context).passwordHintText,
                        focusColor: Colors.transparent,
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintMaxLines: 1,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenWidth * 0.09),
                            borderSide: BorderSide.none),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenWidth * 0.09),
                            borderSide: BorderSide.none),
                        fillColor: const Color(0xff323644),
                        filled: true,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passwordVisible,
                      obscuringCharacter: "*",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return S.of(context).passwordEmptyErrorText;
                        } else if (invalidPass) {
                          invalidPass = false;
                          return S.of(context).passworInvalidErrorText;
                        }
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: ScreenHeight * 0.25,
                ),
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                    ));
                  },
                  child: Text(S.of(context).ForgotPassword,
                      style: TextStyle(
                        color: const Color(0xff7E7EBE),
                        fontSize: ScreenWidth * 0.034,
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.only(left: ScreenWidth * 0.077),
                child: Row(
                  children: [
                    Checkbox(
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue!;
                        });
                      },
                      activeColor: const Color(0xff7E7EBE),
                    ),
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      onTap: () {
                        setState(() {
                          checkedValue = !checkedValue;
                        });
                      },
                      child: Text(
                        S.of(context).RememberMe,
                        style: TextStyle(
                            color: const Color(0xff7E7EBE),
                            fontSize: ScreenWidth * 0.032),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: ScreenWidth * 0.31,
                height: ScreenHeight * 0.056,
                margin: EdgeInsets.only(top: ScreenHeight * 0.034),
                child: ElevatedButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff7E7EBE)),
                    elevation: MaterialStateProperty.all(6),
                  ),
                  onPressed: () async {
                    print(MediaQuery.of(context).orientation);
                    if (await api.hasNetwork()) {
                      setState(() {
                        pressed = true;
                      });

                      if (ValidateEmail.currentState!.validate() &&
                          ValidatePass.currentState!.validate()) {
                        var Response = await api.postRequest(
                            'https://meetingss.onrender.com/auth/login',
                            {
                              "Content-Type": "application/json",
                            },
                            jsonEncode({
                              txtMail.text.contains('@')
                                  ? "E_mail"
                                  : "UserName": txtMail.text,
                              "PassWord": PassTxt.text,
                              "role": 'Manager',
                            }));

                        print('Response ${Response}');
                        if (api.getValue(Response, 'success')[0] == 'true') {
                          if (checkedValue) {
                            loginInfo.setString(
                                'token', api.getValue(Response, 'token')[0]);

                            loginInfo.setBool('remember', true);
                          } else {
                            loginInfo.setString(
                                'token', api.getValue(Response, 'token')[0]);
                            loginInfo.setBool('remember', false);
                          }




                          Response = await api.getRequest('https://meetingss.onrender.com/manager/getManagerDetails',
                              {'token': '${loginInfo.getString('token')}'});

                          if (api.getValue(Response, 'success')[0] == 'true') {
                            accData.setString('managerId',api.getValue(Response, 'manager_id')[0]);
                            accData.setString('firstName',api.getValue(Response, 'first_name')[0]);
                            accData.setString('lastName',api.getValue(Response, 'last_name')[0]);
                            accData.setString('email', api.getValue(Response, 'E_mail')[0]);
                            accData.setString('userName',api.getValue(Response, 'UserName')[0]);
                            accData.setStringList('Secretaries',api.getValue('${api.getValue(Response, 'Secretaries')[0]},','secretary_id'));


                          }
                          // connectToSocket();

                          Navigator.maybeOf(context)!.pushReplacement(MaterialPageRoute(builder: (context) => Grad(accData, loginInfo, Language, Nearest)));

                        } else if (api
                                .getValue(Response, 'message')[0]
                                .contains('Email') ||
                            api
                                .getValue(Response, 'message')[0]
                                .contains('UserName')) {
                          invalidMail = true;
                          ValidateEmail.currentState!.validate();
                        } else {
                          invalidPass = true;
                          ValidatePass.currentState!.validate();
                        }
                      }

                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Grad(),));
                      setState(() {
                        pressed = false;
                      });
                    }
                  },
                  child: pressed
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: ScreenWidth * 0.0015,
                        )
                      : Text(
                          S.of(context).Login,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 'en' == S.current
                                  ? ScreenWidth * 0.04
                                  : ScreenWidth * 0.033),
                        ),
                ),
              )
            ])),
      ),
    );
  }

  void isRememberd() async {
    loginInfo = await SharedPreferences.getInstance();
    accData = await SharedPreferences.getInstance();
    if (loginInfo.getBool('remember') == true) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Grad(accData, loginInfo, Language, Nearest)));
    }
  }

  void languageSharedPref() async {
    if (Language.getString('language') == 'en') {
      S.load(const Locale("en"));
    } else if (Language.getString('language') == 'ar') {
      S.load(const Locale("ar"));
    } else {
      S.load(const Locale("ar"));
      Language.setString('language', 'ar');
      setState(() {});
    }
  }

  void languageSharedPrefInitialize() async {
    Language = await SharedPreferences.getInstance();

    if (Language.getString('language').toString() == 'null') {

      languageSharedPref();
    } else {
      S.load(Locale(Language.getString('language')!));
      setState(() {});
    }
  }

  void nearsetSharedPref() async {
    Nearest = await SharedPreferences.getInstance();
    if (Nearest.getInt('Days') == null) {
      Nearest.setInt('Days', 3);
    }
    // NearestMeetingDayDate = DateTime.now().add(Duration(days: widget.Nearest!.getInt("Days")! )).toString().substring(0,10);
  }

}

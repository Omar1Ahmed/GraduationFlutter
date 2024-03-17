import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning/Widgets/ForgotPasswordWidget.dart';
import 'package:learning/Widgets/TestApi.dart';
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

late SharedPreferences accData, loginInfo;

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
  }

  @override
  Widget build(BuildContext context) {
    api = ApiTest(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 20),
            width: 100,
            height: 105,
            child: SvgPicture.asset('images/Logo.svg'),
          ),
          const Text(
            "Meetings",
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
          const Divider(
            indent: 100,
            endIndent: 100,
          ),
          Container(
            width: 350,
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Form(
              key: ValidateEmail,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(100),
                color: Colors.transparent,
                child: TextFormField(
                  controller: txtMail,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email/Username cannot be empty";
                    } else if (invalidMail) {
                      invalidMail = false;
                      return 'Invalid Email/Username';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  onChanged: (value) => ValidateEmail.currentState!.validate(),
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.red, width: 1)),
                    constraints: BoxConstraints(minHeight: 50, maxHeight: 70),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    // Adjust the padding as needed
                    prefixIcon: SvgPicture.asset(
                      'images/user.svg',
                      width: 1,
                      height: 1,
                      fit: BoxFit.scaleDown,
                    ),
                    labelText: "Email or Username",
                    hintText: "Enter your Email or Username",
                    focusColor: Colors.transparent,
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintMaxLines: 1,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
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
            width: 350,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Form(
              key: ValidatePass,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(100),
                color: Colors.transparent,
                child: TextFormField(
                  controller: PassTxt,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  onChanged: (value) => ValidatePass.currentState!.validate(),
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.red, width: 1)),
                    constraints: BoxConstraints(minHeight: 50, maxHeight: 70),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    prefixIcon: SvgPicture.asset(
                      "images/password.svg",
                      semanticsLabel: 'PassIcon',
                      height: 1,
                      width: 1,
                      fit: BoxFit.scaleDown,
                      // ),
                    ),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(right: 10),
                      icon: SvgPicture.asset(
                        passwordVisible
                            ? "images/showPassIcon.svg"
                            : "images/hidePassIcon.svg",
                        semanticsLabel: 'PassIcon',
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    labelText: "Password",
                    hintText: "Enter your Password",
                    focusColor: Colors.transparent,
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintMaxLines: 1,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none),
                    fillColor: const Color(0xff323644),
                    filled: true,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: passwordVisible,
                  obscuringCharacter: "*",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    } else if (invalidPass) {
                      invalidPass = false;
                      return 'Invalid Password';
                    }
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 220),
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPassword(),
                ));
              },
              child: Text('Forgot Password?',
                  style: TextStyle(
                    color: Color(0xff7E7EBE),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(left: 30),
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
                    'Remember me',
                    style: TextStyle(color: Color(0xff7E7EBE)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 130,
            height: 50,
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff7E7EBE)),
                elevation: MaterialStateProperty.all(6),
              ),
              onPressed: () async {
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
                          txtMail.text.contains('@') ? "E_mail" : "UserName":
                              txtMail.text,
                          "PassWord": PassTxt.text,
                          "role": 'Manager',
                        }));

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

                      Response = await api.getRequest(
                          'https://meetingss.onrender.com/manager/getManagerDetails',
                          {'token': '${loginInfo.getString('token')}'});
                      if (api.getValue(Response, 'success')[0] == 'true') {
                        accData.setString('managerId',
                            api.getValue(Response, 'manager_id')[0]);
                        accData.setString('firstName',
                            api.getValue(Response, 'first_name')[0]);
                        accData.setString(
                            'lastName', api.getValue(Response, 'last_name')[0]);
                        accData.setString(
                            'email', api.getValue(Response, 'E_mail')[0]);
                        accData.setString(
                            'userName', api.getValue(Response, 'UserName')[0]);
                        accData.setStringList(
                            'Secretaries',
                            api.getValue(
                                api.getValue(Response, 'Secretaries')[0] + ',',
                                'secretary_id'));
                      }

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Grad(accData, loginInfo)));
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
                      strokeWidth: 2,
                    )
                  : Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Grad(accData, loginInfo)));
    }
  }
}

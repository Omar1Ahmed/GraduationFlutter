import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Meetings/Grad.dart';
import 'package:Meetings/Widgets/HomePageWidegt.dart';
import 'package:Meetings/Widgets/TestApi.dart';
import 'package:Meetings/generated/l10n.dart';
import 'package:Meetings/main.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}


GlobalKey<FormState> ValidatMail = GlobalKey<FormState>();
TextEditingController txtMail = TextEditingController();
String Code = '', ErrMsg = '',mail = '';
bool invalidMail = false,
    ConfirmedMail = false,
    newPass = false,
    passwordVisible = true,
    passwordVisible2 = true,
    invalidPass = false,
    invalidPass2 = false,
    pressed = false;

GlobalKey<FormState> ValidatePass = GlobalKey<FormState>();
GlobalKey<FormState> ValidatePass2 = GlobalKey<FormState>();

TextEditingController PassTxt = TextEditingController();
TextEditingController PassTxt2 = TextEditingController();

late ApiTest api ;

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    super.initState();
  // S.load(const Locale('ar'));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,

    ]);

  }
  @override
  Widget build(BuildContext context) {


    api = ApiTest(context);
    return PopScope(

        onPopInvoked: (didPop) {


            invalidMail = false;
            ConfirmedMail = false;
            newPass = false;
            passwordVisible = true;
            passwordVisible2 = true;
            invalidPass = false;
            invalidPass2 = false;
            Code = '';
            ErrMsg = '';
            txtMail.text = '';
            PassTxt.text = '';
            PassTxt2.text = '';
            pressed = false;

            Navigator.of(context).maybePop();


        },
     child: Scaffold(
        backgroundColor: const Color(0xFF272A37),


        body: SafeArea(

            child: SingleChildScrollView(
              child: Center(
                  child: Column(children: [
                SvgPicture.asset(
                  newPass ? 'images/password.svg' : 'images/mail.svg',
                  height: ScreenHeight * 0.35,
                  fit: BoxFit.contain,
                ),
                ConfirmedMail
                    ? (newPass
                        ? Container(
                            child: Column(children: [
                              Container(
                                width: ScreenWidth * 0.85,
                                margin:
                                     EdgeInsets.only(top: ScreenHeight * 0.02, bottom: ScreenHeight * 0.02),
                                child: Form(
                                  key: ValidatePass,
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.transparent,
                                    child: TextFormField(
                                      controller: PassTxt,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      onChanged: (value) => ValidatePass.currentState!.validate(),
                                      decoration: InputDecoration(
                                        errorText:
                                            ErrMsg.isNotEmpty ? ErrMsg : null,
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 1)),
                                        constraints: BoxConstraints(
                                            minHeight: ScreenHeight * 0.07, maxHeight: ScreenHeight * 0.080),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: ScreenHeight * 0.001, horizontal: ScreenWidth * 0.02),
                                        prefixIcon: SvgPicture.asset(
                                          "images/password.svg",
                                          semanticsLabel: 'PassIcon',
                                          height: ScreenHeight * 0.05,
                                          fit: BoxFit.scaleDown,
                                          // ),
                                        ),
                                        suffixIcon: IconButton(
                                          padding: EdgeInsets.only(right: ScreenHeight * 0.01),
                                          icon: SvgPicture.asset(
                                            passwordVisible
                                                ? "images/showPassIcon.svg"
                                                : "images/hidePassIcon.svg",
                                            semanticsLabel: 'PassIcon',
                                            height: ScreenHeight * 0.05,

                                            fit: BoxFit.scaleDown,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        ),
                                      labelText: "${S.of(context).passwordLabelText}",
                                        hintText: "${S.of(context).passwordHintText}",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        hintMaxLines: 1,

                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            borderSide: BorderSide.none),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          borderSide: BorderSide.none,
                                        ),
                                        fillColor: const Color(0xff323644),
                                        filled: true,
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: passwordVisible,
                                      obscuringCharacter: "*",
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          ValidatePass2.currentState!.validate();
                                          return "${S.of(context).passwordEmptyErrorText}";
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: ScreenWidth * 0.85,
                                margin:
                                EdgeInsets.only(top: ScreenHeight * 0.02, bottom: ScreenHeight * 0.02),
                                child: Form(
                                  key: ValidatePass2,
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.transparent,
                                    child: TextFormField(
                                      controller: PassTxt2,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      maxLines: 1,
                                      onChanged: (value) => ValidatePass2.currentState!.validate(),
                                      decoration: InputDecoration(
                                        errorText:
                                            ErrMsg.isNotEmpty ? ErrMsg : null,
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 1)),
                                        constraints: BoxConstraints(
                                            minHeight: ScreenHeight * 0.07, maxHeight: ScreenHeight * 0.080),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: ScreenHeight * 0.001, horizontal: ScreenWidth * 0.02),
                                        prefixIcon: SvgPicture.asset(
                                          "images/password.svg",
                                          semanticsLabel: 'PassIcon',
                                          height: ScreenHeight * 0.05,
                                          fit: BoxFit.scaleDown,
                                          // ),
                                        ),
                                        suffixIcon: IconButton(
                                          padding: EdgeInsets.only(right: ScreenHeight * 0.01),
                                          icon: SvgPicture.asset(
                                            passwordVisible2
                                                ? "images/showPassIcon.svg"
                                                : "images/hidePassIcon.svg",
                                            semanticsLabel: 'PassIcon',
                                            height: ScreenHeight * 0.05,
                                            fit: BoxFit.scaleDown,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible2 =
                                                  !passwordVisible2;
                                            });
                                          },
                                        ),
                                        labelText: "${S.of(context).passwordLabelConfirmText}",
                                        hintText: "${S.of(context).passwordHintConfirmText}",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        hintMaxLines: 1,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            borderSide: BorderSide.none),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          borderSide: BorderSide.none,
                                        ),
                                        fillColor: const Color(0xff323644),
                                        filled: true,
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: passwordVisible2,
                                      obscuringCharacter: "*",
                                      validator: (value) {
                                        if (value!.isEmpty) {

                                          return "${S.of(context).passwordEmptyErrorText}";
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                OtpTextField(
                                  numberOfFields: 6,
                                  keyboardType: TextInputType.number,
                                  fillColor: const Color(0xff323644),
                                  filled: true,
                                  onSubmit: (code) {
                                    Code = code;
                                    ButtonClickedSendCode();
                                  },
                                  onCodeChanged: (value) => {
                                    // if(){Code += value};
                                    if (ErrMsg.isNotEmpty)
                                      {setState(() => ErrMsg = '')}
                                  },
                                  // autoFocus: true,
                                  showFieldAsBox: true,
                                  showCursor: true,
                                  borderRadius: BorderRadius.circular(100),
                                  borderColor: Colors.transparent,
                                  enabledBorderColor: Colors.transparent,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  fieldWidth: 50,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    ErrMsg,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            )))
                    : Container(
                        width: 360,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Form(
                            key: ValidatMail,
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.transparent,
                              child: TextFormField(
                                controller: txtMail,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: '${S.of(context).emailLabelText}',
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  prefixIcon: SvgPicture.asset(
                                    'images/user.svg',
                                    width: 1,
                                    height: 1,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  hintMaxLines: 1,
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      borderSide: BorderSide.none),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      borderSide: BorderSide.none),
                                  fillColor: const Color(0xff323644),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "${S.of(context).emailEmptyErrorText}";
                                  } else if (invalidMail) {
                                    // setState(() {

                                    invalidMail = false;
                                    // });
                                    return '${S.of(context).emailInvalidErrorText}';
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ),
                Container(
                    width: newPass ? 180 : 130,
                    height: 50,
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7E7EBE),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                              color: Color(0xff7E7EBE), width: 1),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {

                        pressed = true;
                        });

                        if (ConfirmedMail) {
                          if (newPass) {
                            ButtonClickedChangePass();

                          } else {
                            ButtonClickedSendCode();
                          }
                        } else {
                          if (ValidatMail.currentState!.validate()) {
                            ButtonClickedSendMail();
                          }
                        }
                          setState(() {
                            pressed = false;
                          });
                      },
                      child: pressed ? const CircularProgressIndicator( color: Colors.white,strokeWidth: 2,) : Text(
                        ConfirmedMail
                            ? (newPass ? "${S.of(context).changePassword}" : "${S.of(context).sendCode}")
                            : "${S.of(context).getCode}",
                        style:
                             TextStyle(color: Colors.white, fontSize: S.current == 'en' ? 15: 14),
                      ),
                    ))
              ])),
            ),
          ),
        ));
  }

  Future<void> ButtonClickedSendCode() async {
    ErrMsg = '';

    var Response = await api.postRequest(
        'https://meetingss.onrender.com/auth/verifyResetCode',
        {
          "Content-Type": "application/json",
        },
        jsonEncode({"E_mail": txtMail.text, "code": Code, "role": "Manager"}));

    print(Response);
    if (api.getValue(Response, 'success')[0] == 'true') {
      setState(() {
        newPass = true;
        ErrMsg = '';
      });
    } else if (api.getValue(Response, 'message')[0].contains('empty')) {
      setState(() {
        ErrMsg = Code.length == 0 ? "${S.of(context).codeEmptyErrorText}" : '${S.of(context).codeLengthErrorText}';
      });
    } else if (api.getValue(Response, 'message')[0].contains('First')) {
      setState(() {
        ErrMsg = '${S.of(context).codeResendErrorText}';
      });
    } else if (api.getValue(Response, 'message')[0].contains('Invalid')) {
      setState(() {
        ErrMsg = '${S.of(context).codeInvalidErrorText}';
      });
    }
  }

  Future<void> ButtonClickedSendMail() async {
    var Response = await api.postRequest(
        'https://meetingss.onrender.com/auth/send-forget-code',
        {
          "Content-Type": "application/json",
        },
        jsonEncode({"E_mail": txtMail.text, "role": "Manager"}));

    print(Response);
    if (api.getValue(Response, 'success')[0] == 'true') {
      setState(() {
        ConfirmedMail = true;
        ErrMsg = '';
      });
    } else if (api.getValue(Response, 'message')[0].contains('E_mail') || api.getValue(Response, 'message')[0].contains('Incorrect')) {
      setState(() {

      invalidMail = true;
      ValidatMail.currentState!.validate();
      });
    }
  }

  Future<void> ButtonClickedChangePass() async {
    if (ValidatePass.currentState!.validate() &&
        ValidatePass2.currentState!.validate()) {
      // if (PassTxt.text == PassTxt2.text) {
      var Response = await api.postRequest(
          'https://meetingss.onrender.com/auth/forget-password',
          {
            "Content-Type": "application/json",
          },
          jsonEncode({
            "E_mail": txtMail.text,
            "PassWord": PassTxt.text,
            "confirmPassword": PassTxt2.text,
            "role": "Manager"
          }));

      if (api.getValue(Response, 'success')[0] ==
          'true') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainApp(),
            ));
      } else if (api
          .getValue(Response, 'message')[0]
          .contains('required')) {
        setState(() {
          ErrMsg =
          '${S.of(context).passwordInvalidErrorText}';
        });
      } else if (api
          .getValue(Response, 'message')[0]
          .contains('Equal')) {
        setState(() {
          ErrMsg = '${S.of(context).passwordNotMatchErrorText}';
        });
      }
      //   }
    }

  }
}

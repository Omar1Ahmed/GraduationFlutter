// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Email or Username`
  String get mailLabelText {
    return Intl.message(
      'Email or Username',
      name: 'mailLabelText',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email or Username`
  String get mailHintText {
    return Intl.message(
      'Enter your Email or Username',
      name: 'mailHintText',
      desc: '',
      args: [],
    );
  }

  /// `Email/Username cannot be Empty`
  String get mailEmptyErrorText {
    return Intl.message(
      'Email/Username cannot be Empty',
      name: 'mailEmptyErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email/Username`
  String get mailInvalidErrorText {
    return Intl.message(
      'Invalid Email/Username',
      name: 'mailInvalidErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get passworInvalidErrorText {
    return Intl.message(
      'Invalid Password',
      name: 'passworInvalidErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be Empty`
  String get passwordEmptyErrorText {
    return Intl.message(
      'Password cannot be Empty',
      name: 'passwordEmptyErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Password`
  String get passwordHintText {
    return Intl.message(
      'Enter Your Password',
      name: 'passwordHintText',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Your Password`
  String get passwordHintConfirmText {
    return Intl.message(
      'Confirm Your Password',
      name: 'passwordHintConfirmText',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabelText {
    return Intl.message(
      'Password',
      name: 'passwordLabelText',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get ForgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'ForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get RememberMe {
    return Intl.message(
      'Remember Me',
      name: 'RememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get emailInvalidErrorText {
    return Intl.message(
      'Invalid Email',
      name: 'emailInvalidErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be Empty`
  String get emailEmptyErrorText {
    return Intl.message(
      'Email cannot be Empty',
      name: 'emailEmptyErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Enter Email`
  String get emailLabelText {
    return Intl.message(
      'Enter Email',
      name: 'emailLabelText',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get passwordLabelConfirmText {
    return Intl.message(
      'Confirm Password',
      name: 'passwordLabelConfirmText',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message(
      'Send Code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Get Code`
  String get getCode {
    return Intl.message(
      'Get Code',
      name: 'getCode',
      desc: '',
      args: [],
    );
  }

  /// `Code is Required`
  String get codeEmptyErrorText {
    return Intl.message(
      'Code is Required',
      name: 'codeEmptyErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Code Length must be 6`
  String get codeLengthErrorText {
    return Intl.message(
      'Code Length must be 6',
      name: 'codeLengthErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Resend The Code`
  String get codeResendErrorText {
    return Intl.message(
      'Resend The Code',
      name: 'codeResendErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Code is Invalid`
  String get codeInvalidErrorText {
    return Intl.message(
      'Code is Invalid',
      name: 'codeInvalidErrorText',
      desc: '',
      args: [],
    );
  }

  /// `at least 8 characters long, only contains [A-Z] and [0-9]`
  String get passwordInvalidErrorText {
    return Intl.message(
      'at least 8 characters long, only contains [A-Z] and [0-9]',
      name: 'passwordInvalidErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Passwords does not match`
  String get passwordNotMatchErrorText {
    return Intl.message(
      'Passwords does not match',
      name: 'passwordNotMatchErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Person or Entity`
  String get personOrEntity {
    return Intl.message(
      'Person or Entity',
      name: 'personOrEntity',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get topic {
    return Intl.message(
      'Topic',
      name: 'topic',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Nearby Meetings`
  String get nearbyMeetings {
    return Intl.message(
      'Nearby Meetings',
      name: 'nearbyMeetings',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get Today {
    return Intl.message(
      'Today',
      name: 'Today',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get Tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'Tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `About the Meeting`
  String get comments {
    return Intl.message(
      'About the Meeting',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Open Pdf`
  String get openPdf {
    return Intl.message(
      'Open Pdf',
      name: 'openPdf',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get addNote {
    return Intl.message(
      'Add Note',
      name: 'addNote',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get Time {
    return Intl.message(
      'Time',
      name: 'Time',
      desc: '',
      args: [],
    );
  }

  /// `Without Meetings`
  String get noMeetings {
    return Intl.message(
      'Without Meetings',
      name: 'noMeetings',
      desc: '',
      args: [],
    );
  }

  /// `Your Name`
  String get yourName {
    return Intl.message(
      'Your Name',
      name: 'yourName',
      desc: '',
      args: [],
    );
  }

  /// `User Name:`
  String get userName {
    return Intl.message(
      'User Name:',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Email:`
  String get email {
    return Intl.message(
      'Email:',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password:`
  String get password {
    return Intl.message(
      'Password:',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get personalInfo {
    return Intl.message(
      'Account Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get searchHint {
    return Intl.message(
      'Search...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Search By`
  String get searchBy {
    return Intl.message(
      'Search By',
      name: 'searchBy',
      desc: '',
      args: [],
    );
  }

  /// `Results Found`
  String get resultsTxt {
    return Intl.message(
      'Results Found',
      name: 'resultsTxt',
      desc: '',
      args: [],
    );
  }

  /// `No Results Found`
  String get noResultsTxt {
    return Intl.message(
      'No Results Found',
      name: 'noResultsTxt',
      desc: '',
      args: [],
    );
  }

  /// `Select a Search Filter First`
  String get selectFilterTxt {
    return Intl.message(
      'Select a Search Filter First',
      name: 'selectFilterTxt',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to Search By Date`
  String get swipeTxt {
    return Intl.message(
      'Swipe to Search By Date',
      name: 'swipeTxt',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Date`
  String get selectDatesTxt {
    return Intl.message(
      'Please Select Date',
      name: 'selectDatesTxt',
      desc: '',
      args: [],
    );
  }

  /// `Please Select (To) Date`
  String get selectToDateTxt {
    return Intl.message(
      'Please Select (To) Date',
      name: 'selectToDateTxt',
      desc: '',
      args: [],
    );
  }

  /// `Please Select (From) Date`
  String get selectFromDateTxt {
    return Intl.message(
      'Please Select (From) Date',
      name: 'selectFromDateTxt',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get searchBtn {
    return Intl.message(
      'Done',
      name: 'searchBtn',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get toTxt {
    return Intl.message(
      'To',
      name: 'toTxt',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get fromTxt {
    return Intl.message(
      'From',
      name: 'fromTxt',
      desc: '',
      args: [],
    );
  }

  /// `No Data Found`
  String get noDataFound {
    return Intl.message(
      'No Data Found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Show Meetings`
  String get showMeeting {
    return Intl.message(
      'Show Meetings',
      name: 'showMeeting',
      desc: '',
      args: [],
    );
  }

  /// `Click on The Days to Show Meetings`
  String get noMeetings_Calender {
    return Intl.message(
      'Click on The Days to Show Meetings',
      name: 'noMeetings_Calender',
      desc: '',
      args: [],
    );
  }

  /// `{numberOfMeetings} Meetings to Show`
  String totalMeetings(int numberOfMeetings) {
    return Intl.message(
      '$numberOfMeetings Meetings to Show',
      name: 'totalMeetings',
      desc: 'Greet the user by their name.',
      args: [numberOfMeetings],
    );
  }

  /// `Show Note`
  String get ShowNote {
    return Intl.message(
      'Show Note',
      name: 'ShowNote',
      desc: '',
      args: [],
    );
  }

  /// `Write Your title`
  String get noTitle {
    return Intl.message(
      'Write Your title',
      name: 'noTitle',
      desc: '',
      args: [],
    );
  }

  /// `Write Your Content`
  String get noContent {
    return Intl.message(
      'Write Your Content',
      name: 'noContent',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Nearest Meetings`
  String get NearestMeetings {
    return Intl.message(
      'Nearest Meetings',
      name: 'NearestMeetings',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `You hava a Meeting With `
  String get meetingNotification {
    return Intl.message(
      'You hava a Meeting With ',
      name: 'meetingNotification',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

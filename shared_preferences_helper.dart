
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunrise_diamond/model/user_model.dart';
import 'package:sunrise_diamond/model/users_action_rights.dart';
import 'package:sunrise_diamond/services/user_action_right_services.dart';
import 'package:sunrise_diamond/services/user_menu_rights_services.dart';

class PrefSettings {
  static final PrefSettings _instance = PrefSettings
      ._internal();

  factory PrefSettings() => _instance;


  PrefSettings._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String keyUserName = 'keyUserName';
  static const String keyPassword = 'keyPassword';
  static const String keyCurrentUserId = 'keyCurrentUserId';
  static const String keyUserModel = 'keyUserModel';
  static const String keyTempSearchFilterData = 'keyTempSearchFilterData';
  static const String keyProcessCompleted = 'keyProcessCompleted';

  String get currentUserName => _prefs.getString(keyUserName) ?? '';
  set currentUserName(String value) => _prefs.setString(keyUserName, value);

  String get currentUserPassword => _prefs.getString(keyPassword) ?? '';
  set currentUserPassword(String value) => _prefs.setString(keyPassword, value);

  int get currentUserId => _prefs.getInt(keyCurrentUserId) ?? 0;
  set currentUserId(int value) => _prefs.setInt(keyCurrentUserId, value);

  bool get isAdmin => _prefs.getBool('isAdmin') ?? false;
  set isAdmin(bool value) => _prefs.setBool('isAdmin', value);

  String get userType => _prefs.getString('userType') ?? '';
  set userType(String value) => _prefs.setString('userType', value);

  String get selectedViewFormat => _prefs.getString('selectedViewFormat') ?? '';
  set selectedViewFormat(String value) => _prefs.setString('selectedViewFormat', value);

  String get selectedCartFormat => _prefs.getString('selectedCartFormat') ?? '';
  set selectedCartFormat(String value) => _prefs.setString('selectedCartFormat', value);


  bool get isBuyer => _prefs.getString('userType')?.contains("Buyer")??false;

  bool get isBiometricOn => _prefs.getBool('isBiometricOn') ?? true;
  set isBiometricOn(bool value) => _prefs.setBool('isBiometricOn', value);

  String get accessToken => _prefs.getString('accessToken') ?? '';
  set accessToken(String value) => _prefs.setString('accessToken', value);

  String get tempSearchFilterData => _prefs.getString('keyTempSearchFilterData') ?? '';
  set tempSearchFilterData(String value) => _prefs.setString('keyTempSearchFilterData', value);

  bool get isProcessCompleted => _prefs.getBool(keyProcessCompleted) ?? false;
  set isProcessCompleted(bool value) => _prefs.setBool(keyProcessCompleted, value);

  List<String> get cutOrderList => _prefs.getStringList('cutOrderList') ?? [];
  set cutOrderList(List<String> value) => _prefs.setStringList('cutOrderList', value);

  List<String> get colorOrderList => _prefs.getStringList('colorOrderList') ?? [];
  set colorOrderList(List<String> value) => _prefs.setStringList('colorOrderList', value);

  List<String> get flsOrderList => _prefs.getStringList('flsOrderList') ?? [];
  set flsOrderList(List<String> value) => _prefs.setStringList('flsOrderList', value);

  List<String> get clarityOrderList => _prefs.getStringList('clarityOrderList') ?? [];
  set clarityOrderList(List<String> value) => _prefs.setStringList('clarityOrderList', value);


  UserModel get currentUserModel{
    String userValue = _prefs.getString('keyUserModel') ?? '';
    if(userValue.isEmpty) return UserModel();
    return userModelFromJson(userValue);
  }

  set currentUserModel(UserModel value){
    String userValue = userModelToJson(value);
    _prefs.setString('keyUserModel', userValue);
  }

  /// Set user auth session
  void setPreferenceFromUser(UserModel user) {
    if(user.isEmpty)return;
    currentUserModel = user;
    currentUserId = (user.userId??0);
    isAdmin = user.isAdmin??false;
    userType = user.userType??"";
    accessToken = user.token??"";
    UserActionRightServices.initUserActionRights();
    UserMenuRightsServices.initUserMenuRights();
    log("Access Token : $accessToken");
  }

  /// Clear user auth session
  void clearUserAuthSession([bool isFromLogout = true]) {
    currentUserModel = UserModel();
    if(isFromLogout){
      currentUserName = "";
      currentUserPassword = "";
      selectedViewFormat =  "";
      selectedCartFormat =  "";
      isBiometricOn = true;
    }
    currentUserId = 0;
    isAdmin = false;
    userType = "";
    accessToken = "";
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qoncert/const/globle_variable.dart';
import 'package:qoncert/main.dart';
import 'package:qoncert/model/profile_model.dart';
import 'package:qoncert/screen/auth_screen.dart';
import 'package:qoncert/widget/show_widget.dart';

import '../controller/profile_controller.dart';
import '../model/response_msg_model.dart';
import '../services/shared_preference_services.dart';

import '../const/api_const.dart';
import '../const/const_string.dart';

class HttpCaller{

  static Future<ResponseMsg> fetch({
    String action = ApiAction.login,
    String dataKey = ApiResponseParam.data,
    bool isData = true,
    bool isFullBody = false,
    String method = ApiMethod.post,
    Map<String,String> payLoad = const {},
    Map<String,List<String>> images = const {}
  })async{

    String message = "";
    bool status = false;

    try {
      var request = http.MultipartRequest(method, Uri.parse(ApiEndPoint.getEndPointByAction(action)));

      List<Future<http.MultipartFile>> newList = [];

      images.forEach((key, value) {
        for (var element in value) {
          if(!element.contains("http")){
            var multipartFile = http.MultipartFile.fromPath(key, element);
            newList.add(multipartFile);
          }
        }
      });

      request.files.addAll(await Future.wait<http.MultipartFile>(newList));
      request.fields.addAll({
        ApiParam.action : action
      });

      if(action != ApiAction.login || action != ApiAction.loginWithMedia || action != ApiAction.signup){
        String token = await SharedPreferenceFun.getToken();
        request.fields.addAll({
          ApiParam.token : token,
        });
        print("TOKEN : $token");
      }
      request.fields.addAll(payLoad);
      http.StreamedResponse response = await request.send();
      String dataString = await response.stream.bytesToString();
      Map data = json.decode(dataString);
      print(payLoad);
      if(data[ApiResponseParam.status] == true){
        status = true;
        if(action == ApiAction.login || action == ApiAction.signup || action == ApiAction.loginWithMedia){
          try{
            profileStatus = data[ApiResponseParam.profileStatus]??0;
            await SharedPreferenceFun.setProfileStatus(profileStatus);
            await SharedPreferenceFun.setToken(token: data[ApiResponseParam.token]??"");
          }catch(_){}
        }
        if(action == ApiAction.getMyProfile){
          Get.find<ProfileController>().notificationCount.value = data[ApiResponseParam.notificationCount]??0;
          Get.find<ProfileController>().unreadMessageCount.value = data[ApiResponseParam.unreadMessageCount]??0;
        }
        if(action == ApiAction.updateProfile && data[ApiResponseParam.data] != null){
          Get.find<ProfileController>().profile.value = Profile.fromJson(data[ApiResponseParam.data]);
        }
        if(isFullBody){
          message = dataString;
        }else if(isData){
          if(data.containsKey(dataKey)){
            message = jsonEncode(data[dataKey]??"");
          }
        }else{
          message = data[ApiResponseParam.message]??"";
        }
      }else if(data[ApiResponseParam.message] == errInvalidToken){
        appKey.currentState!.pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
        );
      }else{
        message = data[ApiResponseParam.message]??"";
      }
    } on SocketException catch (_){
      ShowFunction.showErrorPopUp(message: errCheckInternet);
      message = errCheckInternet;
    } catch (_) {
      message = errSomethingWrong;
    }

    return ResponseMsg(
        status: status,
        message: message
    );
  }

}
import 'dart:io' show File, Platform;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mjs/Utils/helper_fun.dart';

import '../main.dart';


class PickImageFun {

  static int imageQuality = 40;

  static Future<String?> pickImage(ImageSource imageSource) async {
    String? imagePath;
    ImagePicker imagePicker = ImagePicker();
    if(Platform.isIOS){
      final value = await imagePicker.pickImage(source: imageSource,requestFullMetadata: false);
      if(value != null){
        String path = await HelperFun.downloadImagePath();
        File newImagePath = File("${path}image_${DateTime.now().toString().removeAllWhitespace}.jpg");
        newImagePath.create(recursive: true);
        var result = await FlutterImageCompress.compressAndGetFile(
          value.path,newImagePath.path,
          quality: imageQuality,
        );
        if(result != null){
          imagePath = result.path;
        }
      }
    }else{
      final value = await imagePicker.pickImage(source: imageSource,imageQuality: imageQuality,requestFullMetadata: false);
      if(value != null){
        imagePath = value.path;
      }
    }
    return imagePath;
  }

  static Future<List<String>> pickMultiImage({int maxImage = 12}) async {
    List<String> imagePathList = [];
    ImagePicker imagePicker = ImagePicker();

    if(Platform.isIOS){
      List<XFile> value = await imagePicker.pickMultiImage(requestFullMetadata: false);
      if(value.length > maxImage){
        Future.delayed(const Duration(milliseconds: 0),(){
          HelperFun.buildSnackBar(appKey.currentState!.context, "Maximum image upload limit is 12");
        });
        value = value.sublist(0,maxImage);
      }
      for(final element in value){
        String path = await HelperFun.downloadImagePath();
        File newImagePath = File("${path}image_${DateTime.now().toString().removeAllWhitespace}.jpg");
        newImagePath.create(recursive: true);
        var result = await FlutterImageCompress.compressAndGetFile(
          element.path, newImagePath.path,
          quality: imageQuality,
        );
        if(result != null){
          imagePathList.add(result.path);
        }
      }
    }else{
      List<XFile> value = await imagePicker.pickMultiImage(requestFullMetadata: false,imageQuality: imageQuality);
      if(value.length > maxImage){
        Future.delayed(const Duration(milliseconds: 0),(){
          HelperFun.buildSnackBar(appKey.currentState!.context, "Maximum image upload limit is 12");
        });
        value = value.sublist(0,maxImage);
      }
      for(final element in value){
        imagePathList.add(element.path);
      }
    }

    return imagePathList;
  }

}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mjs/Widget/cached_image_widget.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final String? placeHolder;
  final Color placeHolderColor;

  const ImageWidget({
    super.key,
    this.imageUrl,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.placeHolder,
    this.placeHolderColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: borderRadius??BorderRadius.zero,
        child: getImage,
      ),
    );
  }

  Widget get getImage{
    if((imageUrl??"").isEmpty){
      if((placeHolder??"").isEmpty){
        return const SizedBox();
      }else if(placeHolder!.contains("svg")){
        return SvgPicture.asset(placeHolder!,colorFilter: ColorFilter.mode(placeHolderColor, BlendMode.srcIn),);
      }else if(placeHolder!.toString().toLowerCase().contains("assets")){
        return Image.asset(placeHolder!,fit: fit,);
      }else{
        return Image.file(File(placeHolder??""),fit: fit,);
      }
    }else if(imageUrl!.contains("http")){
      return CachedNetworkImageWidget(imageUrl: imageUrl!,fit: fit,);
    }else if(imageUrl!.toString().toLowerCase().contains("assets")){
      return Image.asset(imageUrl!,fit: fit,);
    }else{
      return Image.file(File(imageUrl??""),fit: fit,);
    }
  }
}

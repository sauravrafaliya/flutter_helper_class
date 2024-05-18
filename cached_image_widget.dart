import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;

  const CachedNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: borderRadius??BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: getImageUrl(imageUrl),
          progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(),
          errorWidget: (context, url, error) {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(),
              errorWidget: (context, url, error) => const SizedBox(),
              fit: fit,
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String getImageUrl(String url){
    // String finalUrl = "";
    // List<String> splitString = url.split("/");
    // splitString.removeLast();
    // if(["car","cover","notification"].contains(splitString.last.toLowerCase())){
    //   finalUrl = "$BUCKET_BASEURL${splitString.last}/${url.split("/").last}";
    // }else{
    //   finalUrl = url;
    // }
    return url;
  }

}

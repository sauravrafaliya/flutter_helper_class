import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xyz/const/globle_variable.dart';
import 'package:xyz/main.dart';
import 'package:xyz/services/http/user_services.dart';
import 'package:xyz/widget/show_widget.dart';

import '../const/const_string.dart';
import '../model/response_msg_model.dart';

class GoogleAuth{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<ResponseMsg> signInWithGoogle() async {
    String message = "";
    bool status = false;

    try {
      try{
        await _googleSignIn.signOut();
      }catch(_){}
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential;
        userCredential = await _auth.signInWithCredential(credential);
        loginEmail = userCredential.user?.email??"";
        artist_name = userCredential.user?.displayName??"";
        ShowFunction.showProgressIndicator();
        await UserServices.logout();
        ResponseMsg authStatus = await UserServices.loginWithMedia(
            userCredential.user?.email??"",
            "google",
            userCredential.user?.uid??""
        );
        appKey.currentState!.pop();
        message = authStatus.message;
        status = authStatus.status;
      }else{
        message = errUserCanceledTheSignFlow;
      }
    } on FirebaseAuthException catch (e) {
      message = e.message??"";
    } on SocketException catch (e) {
      message = errCheckInternet;
    } catch (e){
      message = errSomethingWrong;
    }

    return ResponseMsg(
        status: status,
        message: message
    );
  }

}

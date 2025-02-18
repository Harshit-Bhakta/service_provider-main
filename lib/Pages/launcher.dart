import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/UserController.dart';
import 'package:service_provider/Pages/login.dart';
import 'package:service_provider/Pages/provider_home.dart';
import 'package:service_provider/Pages/userHome.dart';
import 'package:service_provider/Services/firebaseHelper.dart';
late bool loginType;

class launcherPage extends StatefulWidget {
  const launcherPage({super.key});

  @override
  State<launcherPage> createState() => _launcherPageState();
}

class _launcherPageState extends State<launcherPage> {
  UserController controllerU=Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, ()async{
      if(AuthServices.currentUser != null){
        controllerU.currUserDoc=AuthServices.currentUser!.email.toString();
        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.email).get().then((value) {
          if(!value.exists){
            loginType=false;
          }else{
            loginType=true;
          }
          Get.offAll(() =>loginType?userHomePage():ProviderHomePage());
        });

      }else{
        Get.offAll(() =>LoginPage());
      }
    });
    return const Center(
        child: CircularProgressIndicator(),
    );
  }
}



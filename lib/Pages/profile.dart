import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/UserController.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Pages/launcher.dart';
import 'package:service_provider/Pages/selectedServiceInfo.dart';
import 'editProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserController controllerU=Get.find<UserController>();
    ProvidersController controller=Get.find<ProvidersController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Color(0xff4c505b),
          onPressed: (){
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 35,
            color: Color(0xff4c505b),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Get.to(()=>EditProfile(),arguments: loginType==true?controllerU.currUserModel:controller.currProviderModel);
              },
              icon: Icon(Icons.edit,size: 30,)
          )
        ],
      ),
      body: profileBody(controllerU: controllerU,controller: controller,
      ),
    );
  }
}

class profileBody extends StatefulWidget {
  const profileBody({
    super.key,
    required this.controllerU,
    required this.controller,
  });

  final UserController controllerU;
  final ProvidersController controller;

  @override
  State<profileBody> createState() => _profileBodyState();
}

class _profileBodyState extends State<profileBody> {
  String profileAvater='https://firebasestorage.googleapis.com/v0/b/service-provider-2798f.appspot.com/o/user-male-circle.png?alt=media&token=f95cd854-6136-4118-94cd-4abfb3f48656';

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        if(loginType==true){
          controllerU.getCurrUserModel();
        }else{
          controller.getCurrProviderModel();
        }
        setState(() {});
      },
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: GetBuilder<UserController>(
                builder: (uController){
                return GetBuilder<ProvidersController>(
                  builder: (pController) {
                    return ListView(
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.35,
                          child: CircleAvatar(
                            backgroundColor: Colors.lightBlueAccent,
                            radius: MediaQuery.of(context).size.width * 0.35,
                            child: Center(child: CircularProgressIndicator(),),
                            foregroundImage: NetworkImage(
                              loginType==true?
                                  uController.currUserModel.image==''?profileAvater:uController.currUserModel.image
                                  :pController.currProviderModel.image==''?profileAvater:pController.currProviderModel.image,
                            ),
                            //backgroundImage: ,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            loginType==true?uController.currUserModel.name:pController.currProviderModel.name,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 80),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      )),
                                  horizontalTitleGap: 5,
                                  minLeadingWidth: 20,
                                  title: Text(
                                    loginType==true?uController.currUserModel.address:pController.currProviderModel.address,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  dense: true,
                                ),
                                ListTile(
                                  leading: Container(
                                      child: Icon(
                                        Icons.alternate_email,
                                        color: Colors.grey,
                                      )),
                                  horizontalTitleGap: 5,
                                  minLeadingWidth: 20,
                                  title: Text(
                                    loginType==true?uController.currUserModel.email:pController.currProviderModel.email,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  dense: true,
                                  onTap: (){} ,
                                ),
                                ListTile(
                                  leading: Container(
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.grey,
                                      )),
                                  horizontalTitleGap: 5,
                                  minLeadingWidth: 20,
                                  title: Text(
                                    loginType==true?uController.currUserModel.phone:pController.currProviderModel.phone,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                );
              },)
          ),
        ],
      ),
    );
  }
}
